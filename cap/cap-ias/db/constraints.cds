using { demo.orders as db } from './schema';

annotate db.Orders with {
    customerName @mandatory;
    totalAmount  @readonly;
};

annotate db.OrderItems with {
    productId   @mandatory;
    productName @mandatory;
    quantity    @assert.range: [(0),_];
    unitPrice   @assert.range: [0,_];
};
