namespace NewApp.cdsview;

using {NewApp.db as database} from './schemaNew';

define view ![NAWorklist] as
    select from database.transaction.PurchaseOrders {
        key PO_ID                     as ![PurchaseOrderID],
        key Items.PO_ITEM_POS         as ![ItemPosition],
            PARTNER.BP_ID             as ![businessPartnerID],
            PARTNER.COMPANY_NAME      as ![CompanyName],
            GROSS_AMOUNT              as ![GrossAmount],
            NET_AMOUNT                as ![NetAmount],
            TAX_AMOUNT                as ![TaxAmount],
            CURRENCY                  as ![Currency],
            LIFECYCLE_STATUS          as ![LifeCycleStatus],
            OVERALL_STATUS            as ![OverallStatus],
            Items.PRODUCT.PRODUCT_ID  as ![ProductID],
            Items.PRODUCT.DESCRIPTION as ![Description],
            PARTNER.AD.CITY           as ![City],
            PARTNER.AD.COUNTRY        as ![Country],
    }

define view ![ItemView] as
    select from database.transaction.PurchaseItems {
        PARENT.PARTNER.NODE_KEY as ![CustomerKey],
        PRODUCT.NODE_KEY        as ![ProductKey],
        CURRENCY                as ![Currency],
        GROSS_AMOUNT            as ![GrossAmount],
        NET_AMOUNT              as ![NetAmount],
        TAX_AMOUNT              as ![Tax Amount],
        PARENT.OVERALL_STATUS   as ![OverallStatus]
    }

define view ProductView as
    select from database.master.Products
    mixin {
        PO_ORDER : Association[ * ] to ItemView
                       on PO_ORDER.ProductKey = $projection.ProductKey
    }
    into {
        NODE_KEY               as ![ProductKey],
        DESCRIPTION            as ![Description],
        CATEGORY               as ![ProductCategory],
        PRICE                  as ![Price],
        SUPPLIERS.BP_ID        as ![SupplierID],
        SUPPLIERS.COMPANY_NAME as ![CompanyName],
        SUPPLIERS.AD.CITY      as ![City],
        SUPPLIERS.AD.COUNTRY   as ![Country],
        PO_ORDER               as ![ToItems]
    }

define view ![OrderView] as
    select from database.transaction.PurchaseOrders
    {
        key PO_ID                                as ![PurchaseOrderID],
        key Items.PO_ITEM_POS                    as ![ItemPosition],
            PARTNER.BP_ID                        as ![BusinessPartnerID],
            PARTNER.COMPANY_NAME                 as ![CustomerCompanyName],
            GROSS_AMOUNT                         as ![GrossAmount],
            NET_AMOUNT                           as ![NetAmount],
            TAX_AMOUNT                           as ![TaxAmount],
            CURRENCY                             as ![Currency],
            LIFECYCLE_STATUS                     as ![LifeCycleStatus],
            OVERALL_STATUS                       as ![OverallStatus],
            Items.PRODUCT.SUPPLIERS.NODE_KEY     as ![SupplierKey],
            Items.PRODUCT.SUPPLIERS.BP_ID        as ![SupplierID],
            Items.PRODUCT.SUPPLIERS.COMPANY_NAME as ![SupplierCompanyName],
    }

define view ![SupplierView] as
    select from database.master.BusinessPartners
    mixin {
        TO_ORDERS : Association[ * ] to OrderView
                        on TO_ORDERS.SupplierKey = $projection.SupplierKey
    }into {
        key NODE_KEY     as ![SupplierKey],
            BP_ID        as ![SupplierID],
            COMPANY_NAME as ![CompanyName],
            AD.CITY      as ![City],
            AD.COUNTRY   as ![Country],
            TO_ORDERS    as ![ToOrders]
    }
