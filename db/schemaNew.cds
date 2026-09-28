namespace NewApp.db;

using { cuid, Currency } from '@sap/cds/common';

using { NewApp.commonNew as commonNew } from './commonNew';


context master {
    entity BusinessPartners {
        key NODE_KEY : commonNew.Guid;
        BP_ROLE      : commonNew.Role;
        EMAIL        : commonNew.Email;
        MOBILE       : commonNew.PhoneNumber;
        FAX          : commonNew.String32;
        WEB          : commonNew.String255;  
        BP_ID        : commonNew.Guid;
        COMPANY_NAME : commonNew.String255;
        // Managed Association
        AD           : Association to Addresses;
    }


    entity Addresses : commonNew.Address {
        key NODE_KEY : commonNew.Guid;
        ADDRESS_TYPE : commonNew.String32;
        VAL_START    : Date;
        VAL_END      : Date;
        LATITUDE     : Decimal(9,6);
        LONGITUDE    : Decimal(9,6);
        // Back-link Association
        BP           : Association to one BusinessPartners on BP.AD = $self;

    }


    entity Products {
        key NODE_KEY : commonNew.Guid;
        PRODUCT_ID      : commonNew.String32;
        TYPE_CODE       : String(2);
        CATEGORY        : commonNew.String32;
        DESCRIPTION     : commonNew.String255;
        TAX_TARIF_CODE  : Integer;
        MEASURE_UNIT    : String(2);
        WEIGHT_MEASURE  : Decimal(5,2);
        WEIGHT_UNIT     : String(2);
        PRICE           : Decimal(15,2);
        CURRENCY_CODE   : String(5);
        WIDTH           : Decimal(5,2);
        DEPTH           : Decimal(5,2);
        HEIGHT          : Decimal(5,2);
        DIM_UNIT        : String(2);
        // Supplier Business Partner
        SUPPLIERS       : Association to BusinessPartners;
    }


    entity Employees : cuid {
        nameFirst      : commonNew.String64;
        nameLast       : commonNew.String64;
        nameInitials   : commonNew.String64;
        nameMiddle     : commonNew.String64;
        gender         : commonNew.Gender;
        language       : String(2);
        loginName      : String(16);
        phoneNumber    : commonNew.PhoneNumber;
        email          : commonNew.Email;
        Currency       : String(5);
        salaryAmount   : commonNew.AmountT; 
        accountNumber  : commonNew.String32;
        bankId         : String(16);
        bankName       : commonNew.String64;
    }

}


context transaction {
    entity PurchaseOrders : commonNew.Amount {
        key NODE_KEY : commonNew.Guid;
        PO_ID            : commonNew.Guid;
        // Managed Association
        PARTNER          : Association to master.BusinessPartners;
        LIFECYCLE_STATUS : String(1);
        OVERALL_STATUS   : String(1);
        // Unmanaged Association
        Items            : Association to many PurchaseItems on Items.PARENT = $self;
    }


    entity PurchaseItems : commonNew.Amount {
        key NODE_KEY : commonNew.Guid; 
        // Parent Purchase Order
        PARENT      : Association to PurchaseOrders;
        PO_ITEM_POS : Integer;
        // Product Reference
        PRODUCT     : Association to master.Products;
    }

}