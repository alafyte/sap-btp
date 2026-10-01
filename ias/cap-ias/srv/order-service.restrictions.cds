using OrderService from './order-service';

annotate OrderService.Orders with @restrict: [
    {
        grant: ['READ'],
        to   : 'OrderViewer'
    },
    {
        grant: [
            'CREATE',
            'UPDATE',
            'DELETE'
        ],
        to   : 'OrderManager'
    }
];

annotate OrderService.OrderItems with @restrict: [
    {
        grant: ['READ'],
        to   : 'OrderViewer'
    },
    {
        grant: [
            'CREATE',
            'UPDATE',
            'DELETE'
        ],
        to   : 'OrderManager'
    }
];
