using CatalogService as service from '../../srv/cat-service';

annotate service.PurchaseOrderSrv with {
    PO_ID              @(Common: {
        Text     : PO_ID,
        ValueList: {
            Label          : 'Purchase Order ID',
            CollectionPath : 'PurchaseOrderSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: PO_ID,
                ValueListProperty: 'PO_ID'
            }]
        }
    });
    partnerCountryDesc @(Common: {
        Text     : COUNTRY,
        ValueList: {
            Label          : 'Country',
            CollectionPath : 'CountrySrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: partnerCountryDesc,
                ValueListProperty: 'Description'
            }]
        }
    });
    COMPANY_NAME       @(
        Common.Text     : COMPANY_NAME,

        Common.ValueList: {
            Label          : 'Company Name',
            CollectionPath : 'BusinessPartnerSrv',
            SearchSupported: true,

            Parameters     : [
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: BP_ID,
                    ValueListProperty: 'BP_ID'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: COMPANY_NAME,
                    ValueListProperty: 'COMPANY_NAME'
                }
            ]
        }
    );
    LSTEXT             @(Common: {
        Text     : LIFECYCLE_STATUS,
        ValueList: {
            Label          : 'Life Cycle Status',
            CollectionPath : 'LifeCycleStatusSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: LSTEXT,
                ValueListProperty: 'LSTEXT'
            }]
        }
    });
    OSTEXT             @(Common: {
        Text     : OVERALL_STATUS,
        ValueList: {
            Label          : 'Overall Status',
            CollectionPath : 'OverAllStatusSrv',
            SearchSupported: true,
            Parameters     : [{
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: OSTEXT,
                ValueListProperty: 'OSTEXT'
            }]
        }
    });

};


annotate service.PurchaseItemSrv with @(
    Aggregation.ApplySupported            : {
        Transformations       : [
            'aggregate',
            'groupby',
            'filter',
            'orderby',
            'top',
            'skip'
        ],
        GroupableProperties   : [PO_ITEM_POS],
        AggregatableProperties: [{Property: GROSS_AMOUNT}]
    },
    Analytics.AggregatedProperty #sumGross: {
        Name                : 'sumGross',
        AggregationMethod   : 'sum',
        AggregatableProperty: GROSS_AMOUNT,
        ![@Common.Label]    : 'Gross Amount'
    },

    UI.Chart #GrossAnalytics              : {
        Title              : 'Gross Amount per Item',
        ChartType          : #Column,
        Dimensions         : [PO_ITEM_POS],
        DimensionAttributes: [{
            Dimension: PO_ITEM_POS,
            Role     : #Series
        }],
        DynamicMeasures    : ['@Analytics.AggregatedProperty#sumGross'],
        MeasureAttributes  : [{
            DynamicMeasure: '@Analytics.AggregatedProperty#sumGross',
            Role          : #Axis1
        }]
    }
);

annotate CatalogService.PurchaseItemSrv with {
    GROSS_AMOUNT @Semantics.amount.currencyCode: 'CURRENCY_code';
    NET_AMOUNT   @Semantics.amount.currencyCode: 'CURRENCY_code';
    TAX_AMOUNT   @Semantics.amount.currencyCode: 'CURRENCY_code';
};


annotate service.PurchaseOrderSrv with @(
    UI.SelectionFields       : [
        PO_ID,
        COMPANY_NAME,
        LSTEXT,
        OSTEXT,
        partnerCountryDesc
    ],
    UI.LineItem              : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createEmployee',
            Label : 'Create',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/updateEmployee',
            Label : 'Update',
            Inline: false
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/deleteEmployee',
            Label : 'Delete',
            Inline: false
        },
        // {
        //     $Type : 'UI.DataFieldForAction',
        //     Action: 'CatalogService.discountPrice',
        //     Label : 'Discount',
        //     Inline: true
        // },
        /* {
            $Type: 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createEmployee',
            Label: 'Create Employee'
        }, */
        {
            $Type: 'UI.DataField',
            Value: CITY
        },
        {
            $Type      : 'UI.DataField',
            Value      : LSTEXT,
            Criticality: LSC
        },
        {
            $Type      : 'UI.DataField',
            Value      : OSTEXT,
            Criticality: OSC
        },

        {
            $Type: 'UI.DataField',
            Value: partnerCountryDesc
        }
    ],

    UI.HeaderFacets          : [{
        $Type : 'UI.CollectionFacet',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'General Information',
                Target: '@UI.FieldGroup#BPInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Communication Information',
                Target: '@UI.FieldGroup#BPCommInfo'
            },
        ]
    }],

    UI.FieldGroup #BPInfo    : {Data: [
        {
            $Type: 'UI.DataField',
            Value: BP_ID
        },
        {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: BP_ROLE
        }
    ]},
    UI.FieldGroup #BPCommInfo: {Data: [
        {
            $Type: 'UI.DataField',
            Value: EMAIL
        },
        {
            $Type: 'UI.DataField',
            Value: MOBILE
        },
        {
            $Type: 'UI.DataField',
            Value: FAX
        }
    ]},
    UI.HeaderInfo            : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        ImageUrl      : 'https://images.squarespace-cdn.com/content/v1/65a5d81bca27523f618feccf/68d9a6e3-ae27-4f3e-8c5e-f306ac36b8a3/Capgemini.png'
    },
    UI.Facets                : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Other details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Amount Information',
                    Target: '@UI.FieldGroup#BPAmtInfo'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Address Information',
                    Target: '@UI.FieldGroup#BPAddrInfo'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ItemGrossChart',
            Label : 'Gross Amount per Item',
            Target: 'Items/@UI.Chart#GrossAnalytics'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Purchase Item Details',
            Target: 'Items/@UI.LineItem'
        }
    ],
    UI.FieldGroup #BPAmtInfo : {Data: [
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        }
    ]},
    UI.FieldGroup #BPAddrInfo: {Data: [
        {
            $Type: 'UI.DataField',
            Value: COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: BUILDING
        },
        {
            $Type: 'UI.DataField',
            Value: STREET
        },
        {
            $Type: 'UI.DataField',
            Value: CITY
        },
        {
            $Type: 'UI.DataField',
            Value: POSTAL_CODE
        },
        {
            $Type: 'UI.DataField',
            Value: partnerCountryDesc
        }
    ]}
);

annotate service.PurchaseItemSrv @(
    UI.Identification : [
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/createPurchaseItem',
            Label : 'Create'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/updatePurchaseItem',
            Label : 'Update'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.EntityContainer/deletePurchaseItem',
            Label : 'Delete'
        }
    ],

    UI.SelectionFields      : [
        PO_ITEM_POS,
        PRODUCT_NODE_KEY
    ],

    UI.LineItem             : [
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/createPurchaseItem',
            Label : 'Create',
            Inline: false
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/updatePurchaseItem',
            Label : 'Update',
            Inline: false
        },

        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.EntityContainer/deletePurchaseItem',
            Label : 'Delete',
            Inline: false
        },


        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        }

    ],
    UI.HeaderInfo           : {
        TypeName      : 'Purchase Item',
        TypeNamePlural: 'purchase Item',
        Title         : {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: PRODUCT.DESCRIPTION
        },
        ImageUrl      : '//static.vecteezy.com/system/resources/thumbnails/035/857/991/small/assembling-pc-personal-computer-hardware-png.png'
    },
    UI.Facets               : [{
        $Type : 'UI.CollectionFacet',
        Label : 'Other details',
        Facets: [
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Amount Information',
                Target: '@UI.FieldGroup#BPPoInf'
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : 'Address Information',
                Target: '@UI.FieldGroup#BPAddrInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                ID    : 'ProductInformation',
                Label : 'Product Information',
                Target: '@UI.FieldGroup#ProdInfo'
            },
            {
                $Type : 'UI.ReferenceFacet',
                ID    : 'GrossInformation',
                Label : 'Gross Information',
                Target: '@UI.FieldGroup#GrossInfo'
            }
        ]
    }],
    UI.FieldGroup #ProdInfo : {Data: [
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        }
    ]},
    UI.FieldGroup #GrossInfo: {
        Data                     : [
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.PRODUCT_ID
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WEIGHT_MEASURE
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WEIGHT_UNIT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.HEIGHT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WEIGHT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.PRICE
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WIDTH
            }
        ],
        UI.FieldGroup #BPAmtInfo : {Data: [
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: CURRENCY
            }
        ]},
        UI.FieldGroup #BPAddrInfo: {Data: [
            {
                $Type: 'UI.DataField',
                Value: COMPANY_NAME
            },
            {
                $Type: 'UI.DataField',
                Value: BUILDING
            },
            {
                $Type: 'UI.DataField',
                Value: STREET
            },
            {
                $Type: 'UI.DataField',
                Value: CITY
            },
            {
                $Type: 'UI.DataField',
                Value: POSTAL_CODE
            },
            {
                $Type: 'UI.DataField',
                Value: partnerCountryDesc
            }
        ]}
    }
);
