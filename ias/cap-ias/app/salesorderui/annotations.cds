using OrderService as service from '../../srv/order-service';

annotate service.Orders with @(
    UI.HeaderInfo                    : {
        TypeName      : 'Order',
        TypeNamePlural: 'Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: customerName
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: status
        }
    },

    UI.SelectionFields               : [
        customerName,
        status,
        currency
    ],

    UI.PresentationVariant           : {
        $Type         : 'UI.PresentationVariantType',
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : createdAt,
            Descending: true
        }],
        Visualizations: ['@UI.LineItem']
    },

    UI.LineItem                      : [
        {
            $Type: 'UI.DataField',
            Value: customerName,
            Label: 'Customer'
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: 'Status'
        },
        {
            $Type: 'UI.DataField',
            Value: totalAmount,
            Label: 'Total Amount'
        },
        {
            $Type: 'UI.DataField',
            Value: currency_code,
            Label: 'Currency'
        },
        {
            $Type: 'UI.DataField',
            Value: createdAt,
            Label: 'Created'
        },
        {
            $Type: 'UI.DataField',
            Value: modifiedAt,
            Label: 'Last Changed'
        }
    ],

    UI.Facets                        : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneralInformation',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneralInformation'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'OrderItems',
            Label : 'Order Items',
            Target: 'items/@UI.LineItem'
        }
    ],

    UI.FieldGroup #GeneralInformation: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: customerName,
                Label: 'Customer'
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Label: 'Status'
            },
            {
                $Type: 'UI.DataField',
                Value: totalAmount,
                Label: 'Total Amount'
            },
            {
                $Type: 'UI.DataField',
                Value: currency_code,
                Label: 'Currency'
            },
            {
                $Type: 'UI.DataField',
                Value: createdAt,
                Label: 'Created'
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedAt,
                Label: 'Last Changed'
            }
        ]
    },

    UI.Identification                : [
        {
            $Type: 'UI.DataField',
            Value: customerName,
            Label: 'Customer'
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: 'Status'
        },
        {
            $Type: 'UI.DataField',
            Value: totalAmount,
            Label: 'Total Amount'
        }
    ]
);

annotate service.OrderItems with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Value: productId,
        Label: 'Product ID'
    },
    {
        $Type: 'UI.DataField',
        Value: productName,
        Label: 'Product'
    },
    {
        $Type: 'UI.DataField',
        Value: quantity,
        Label: 'Quantity'
    },
    {
        $Type: 'UI.DataField',
        Value: unitPrice,
        Label: 'Unit Price'
    }
]);
annotate service.Orders with {
    customerName @Common.Label : 'Customer'
};

annotate service.Orders with {
    status @Common.Label : 'Status'
};

annotate service.OrderItems with @(
    UI.HeaderInfo : {
        TypeName       : 'Order Item',
        TypeNamePlural : 'Order Items',
        Title : {
            $Type : 'UI.DataField',
            Value : productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : productId
        }
    },

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : productId,
            Label : 'Product ID'
        },
        {
            $Type : 'UI.DataField',
            Value : productName,
            Label : 'Product'
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : 'Quantity'
        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Label : 'Unit Price'
        }
    ],

    UI.FieldGroup #GeneralInformation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : productId,
                Label : 'Product ID'
            },
            {
                $Type : 'UI.DataField',
                Value : productName,
                Label : 'Product'
            },
            {
                $Type : 'UI.DataField',
                Value : quantity,
                Label : 'Quantity'
            },
            {
                $Type : 'UI.DataField',
                Value : unitPrice,
                Label : 'Unit Price'
            }
        ]
    },

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInformation',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInformation'
        }
    ],

    UI.Identification : [
        {
            $Type : 'UI.DataField',
            Value : productId,
            Label : 'Product ID'
        },
        {
            $Type : 'UI.DataField',
            Value : productName,
            Label : 'Product'
        },
        {
            $Type : 'UI.DataField',
            Value : quantity,
            Label : 'Quantity'
        },
        {
            $Type : 'UI.DataField',
            Value : unitPrice,
            Label : 'Unit Price'
        }
    ]
);