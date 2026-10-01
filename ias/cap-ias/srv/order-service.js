const cds = require('@sap/cds');

module.exports = class OrderService extends cds.ApplicationService {

    async init() {

        const { Orders, OrderItems } = this.entities;

        /*
         * ============================================================
         * ORDERS
         * ============================================================
         */

        /*
         * Set business defaults when creating an order.
         *
         * CDS constraints handle:
         * - customerName @mandatory
         * - totalAmount  @readonly
         */
        this.before('CREATE', Orders, req => {

            req.data.status ??= 'OPEN';
            req.data.currency ??= 'EUR';

            // totalAmount is derived data.
            req.data.totalAmount = 0;
        });


        /*
         * Completed and cancelled orders are immutable.
         */
        this.before(
            ['UPDATE', 'DELETE'],
            Orders,
            async req => {

                const order = await SELECT.one
                    .from(Orders)
                    .where({ ID: req.data.ID });

                if (!order) {
                    return;
                }

                if (['COMPLETED', 'CANCELLED'].includes(order.status)) {
                    req.error(
                        400,
                        `Order ${order.ID} is already ${order.status}`
                    );
                }
            }
        );


        /*
         * Validate status transitions.
         */
        this.before('UPDATE', Orders, async req => {
            if (!req.data.status) {
                return;
            }

            const order = await SELECT.one
                .from(Orders)
                .where({ ID: req.data.ID });

            if (!order) {
                return;
            }

            // Status hasn't changed — nothing to validate
            if (req.data.status === order.status) {
                return;
            }

            const allowedTransitions = {
                OPEN: ['PROCESSING', 'CANCELLED'],
                PROCESSING: ['COMPLETED', 'CANCELLED'],
                COMPLETED: [],
                CANCELLED: []
            };

            const allowed = allowedTransitions[order.status] || [];

            if (!allowed.includes(req.data.status)) {
                req.error(
                    400,
                    `Invalid status transition: ${order.status} → ${req.data.status}`
                );
            }
        });


        /*
         * Recalculate totals after an Order is created.
         *
         * This is important for deep inserts:
         *
         * POST Orders
         * {
         *   customerName: "...",
         *   items: [...]
         * }
         *
         * At this point the composed OrderItems have been persisted
         * as part of the same transaction.
         */
        this.after('CREATE', Orders, async (_, req) => {

            const orderId = req.data.ID;

            if (orderId) {
                await this.recalculateOrderTotal(orderId);
            }
        });


        /*
         * ============================================================
         * ORDER ITEMS
         * ============================================================
         */

        /*
         * Validate the parent order before modifying an item.
         *
         * CDS constraints handle:
         * - productId   @mandatory
         * - productName @mandatory
         * - quantity    @assert.range
         * - unitPrice   @assert.range
         */
        this.before(
            ['CREATE', 'UPDATE'],
            OrderItems,
            async req => {

                const orderId =
                    req.data.order_ID ||
                    req.data.order;

                if (!orderId) {
                    return;
                }

                const order = await SELECT.one
                    .from(Orders)
                    .where({ ID: orderId });

                if (!order) {
                    req.error(404, 'Order not found');
                    return;
                }

                if (['COMPLETED', 'CANCELLED'].includes(order.status)) {
                    req.error(
                        400,
                        `Cannot modify items of a ${order.status} order`
                    );
                }
            }
        );

        this.before('UPDATE', OrderItems, async req => {

            if (!req.data.productId) {
                return;
            }

            const existing = await SELECT.one
                .from(OrderItems)
                .where({ ID: req.data.ID });

            if (!existing) {
                return;
            }

            if (existing.productId !== req.data.productId) {
                req.error(
                    400,
                    'Product cannot be changed after the order item is created'
                );
            }
        });

        /*
         * DELETE is slightly different.
         *
         * The client may only send the OrderItem ID, so order_ID
         * might not be available in req.data.
         *
         * We therefore look up the parent before deletion and
         * remember it for the after-handler.
         */
        this.before('DELETE', OrderItems, async req => {

            const itemId = req.data.ID;

            const item = await SELECT.one
                .from(OrderItems)
                .where({ ID: itemId });

            if (!item) {
                return;
            }

            const order = await SELECT.one
                .from(Orders)
                .where({ ID: item.order_ID });

            if (!order) {
                req.error(404, 'Order not found');
                return;
            }

            if (['COMPLETED', 'CANCELLED'].includes(order.status)) {
                req.error(
                    400,
                    `Cannot modify items of a ${order.status} order`
                );
            }

            /*
             * Remember the parent because the item will no longer
             * exist after DELETE.
             */
            req._orderId = item.order_ID;
        });


        /*
         * Recalculate after an individual item is created or updated.
         */
        this.after(
            ['CREATE', 'UPDATE'],
            OrderItems,
            async (_, req) => {

                const orderId =
                    req.data.order_ID ||
                    req.data.order;

                if (orderId) {
                    await this.recalculateOrderTotal(orderId);
                }
            }
        );


        /*
         * Recalculate after an item is deleted.
         */
        this.after('DELETE', OrderItems, async (_, req) => {

            if (req._orderId) {
                await this.recalculateOrderTotal(req._orderId);
            }
        });


        await super.init();
    }


    /*
     * ================================================================
     * TOTAL CALCULATION
     * ================================================================
     *
     * totalAmount =
     *
     *     SUM(quantity × unitPrice)
     *
     * This function deliberately reads the persisted OrderItems
     * instead of trusting a value supplied by the client.
     */
    async recalculateOrderTotal(orderId) {

        const { Orders, OrderItems } = this.entities;

        const items = await SELECT
            .from(OrderItems)
            .where({ order_ID: orderId });

        const total = items.reduce(
            (sum, item) =>
                sum +
                Number(item.quantity) *
                Number(item.unitPrice),
            0
        );

        await UPDATE(Orders)
            .set({ totalAmount: total })
            .where({ ID: orderId });
    }
};
