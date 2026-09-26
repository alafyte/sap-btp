using { demo.orders as db } from '../db/schema';

@path: '/orders'
@requires: 'authenticated-user'
service OrderService {

    @odata.draft.enabled
    entity Orders as projection on db.Orders;

    entity OrderItems as projection on db.OrderItems;

}