namespace demo.orders;

using { cuid, managed, Currency } from '@sap/cds/common';

type OrderStatus : String enum {
    OPEN;
    PROCESSING;
    COMPLETED;
    CANCELLED;
}

entity Orders : cuid, managed {
    customerName : String(100);
    status       : OrderStatus default 'OPEN';
    totalAmount  : Decimal(15,2);
    currency     : Currency default 'EUR';

    items : Composition of many OrderItems
        on items.order = $self;
}

entity OrderItems : cuid {
    order        : Association to Orders;
    productId    : String(50);
    productName  : String(100);
    quantity     : Integer;
    unitPrice    : Decimal(15,2);
}
