namespace NewApp.db;

using { cuid, Currency } from '@sap/cds/common';

using { NewApp.commonNew as commonNew } from './commonNew';


context master {
    entity BusinessPartners {
        key NODE_KEY : commonNew.Guid @(title : '{i18n>NODE_KEY}');
        BP_ROLE      : commonNew.Role @(title : '{i18n>BP_ROLE}');
        EMAIL        : commonNew.Email @(title : '{i18n>EMAIL}');
        MOBILE       : commonNew.PhoneNumber @(title : '{i18n>MOBILE}');
        FAX          : commonNew.String32 @(title : '{i18n>FAX}');
        WEB          : commonNew.String255 @(title : '{i18n>WEB}');  
        BP_ID        : commonNew.Guid @(title : '{i18n>BP_ID}');
        COMPANY_NAME : commonNew.String255 @(title : '{i18n>COMPANY_NAME}');
        // Managed Association
        AD           : Association to Addresses;
    }


    entity Addresses : commonNew.Address {
        key NODE_KEY : commonNew.Guid @(title : '{i18n>NODE_KEY}');
        ADDRESS_TYPE : commonNew.String32 @(title : '{i18n>ADDRESS_TYPE}');
        VAL_START    : Date @(title : '{i18n>VAL_START}');
        VAL_END      : Date @(title : '{i18n>VAL_END}');
        LATITUDE     : Decimal(9,6) @(title : '{i18n>LATITUDE}');
        LONGITUDE    : Decimal(9,6) @(title : '{i18n>LONGITUDE}');
        // Back-link Association
        BP           : Association to one BusinessPartners on BP.AD = $self;

    }


    entity Products {
        key NODE_KEY : commonNew.Guid @(title : '{i18n>NODE_KEY}');
        PRODUCT_ID      : commonNew.String32 @(title : '{i18n>PRODUCT_ID}');
        TYPE_CODE       : String(2) @(title : '{i18n>TYPE_CODE}');
        CATEGORY        : commonNew.String32 @(title : '{i18n>CATEGORY}');
        DESCRIPTION     : commonNew.String255 @(title : '{i18n>DESCRIPTION}');
        TAX_TARIF_CODE  : Integer @(title : '{i18n>TAX_TARIF_CODE}');
        MEASURE_UNIT    : String(2) @(title : '{i18n>MEASURE_UNIT}');
        WEIGHT_MEASURE  : Decimal(5,2) @(title : '{i18n>WEIGHT_MEASURE}');
        WEIGHT_UNIT     : String(2) @(title : '{i18n>WEIGHT_UNIT}');
        PRICE           : Decimal(15,2) @(title : '{i18n>PRICE}');
        CURRENCY_CODE   : String(5) @(title : '{i18n>CURRENCY_CODE}');
        WIDTH           : Decimal(5,2) @(title : '{i18n>WIDTH}');
        DEPTH           : Decimal(5,2) @(title : '{i18n>DEPTH}');
        HEIGHT          : Decimal(5,2) @(title : '{i18n>HEIGHT}');
        DIM_UNIT        : String(2) @(title : '{i18n>DIM_UNIT}');
        // Supplier Business Partner
        SUPPLIERS       : Association to BusinessPartners;
    }


    entity Employees : cuid {
        nameFirst      : commonNew.String64 @(title : '{i18n>nameFirst}');
        nameLast       : commonNew.String64 @(title : '{i18n>nameLast}');
        nameInitials   : commonNew.String64 @(title : '{i18n>nameInitials}');
        nameMiddle     : commonNew.String64 @(title : '{i18n>nameMiddle}');
        gender         : commonNew.Gender @(title : '{i18n>gender}');
        language       : String(2) @(title : '{i18n>language}');
        loginName      : String(16) @(title : '{i18n>loginName}');
        phoneNumber    : commonNew.PhoneNumber @(title : '{i18n>phoneNumber}');
        email          : commonNew.Email @(title : '{i18n>email}');
        Currency       : String(5) @(title : '{i18n>Currency}');
        salaryAmount   : commonNew.AmountT @(title : '{i18n>salaryAmount}'); 
        accountNumber  : commonNew.String32 @(title : '{i18n>accountNumber}');
        bankId         : String(16) @(title : '{i18n>bankId}');
        bankName       : commonNew.String64 @(title : '{i18n>bankName}');
    }

}


context transaction {
    entity PurchaseOrders : commonNew.Amount {
        key NODE_KEY : commonNew.Guid @(title : '{i18n>NODE_KEY}');
        PO_ID            : commonNew.Guid @(title : '{i18n>PO_ID}');
        // Managed Association
        PARTNER          : Association to master.BusinessPartners;
        LIFECYCLE_STATUS : String(1) @(title : '{i18n>LIFECYCLE_STATUS}');
        OVERALL_STATUS   : String(1) @(title : '{i18n>OVERALL_STATUS}');
        // Unmanaged Association
        Items            : Association to many PurchaseItems on Items.PARENT = $self;
    }


    entity PurchaseItems : commonNew.Amount {
        key NODE_KEY : commonNew.Guid @(title : '{i18n>NODE_KEY}'); 
        // Parent Purchase Order
        PARENT      : Association to PurchaseOrders @(title : '{i18n>PARENT}');
        PO_ITEM_POS : Integer @(title : '{i18n>PO_ITEM_POS}');
        // Product Reference
        PRODUCT     : Association to master.Products;
    }

}

entity Countries {
    Code:String(2);
    key Description : String(200);
}
entity LifeCycleStatus {
    key LSTEXT : String(20);
}
entity OverAllStatus {
    key OSTEXT : String(20);
}

entity BPRoleFltr {
    code: Integer @(title : '{i18n>BP_ROLE}');
    description : String(80) @(title : '{i18n>BP_ROLE}')
}