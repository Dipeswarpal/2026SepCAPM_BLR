using {NewApp.db as database} from '../db/schemaNew';
using {NewApp.commonNew as common} from '../db/common';

service CatalogService {

  @Capabilities: {
    InsertRestrictions.Insertable: true,
    UpdateRestrictions.Updatable : true,
    DeleteRestrictions.Deletable : true,
    ReadRestrictions.Readable    : true
  }
  entity EmployeeSrv        as
    projection on database.master.Employees {
      *
    }
    actions {
      action   increaseSalary()   returns array of EmployeeSrv;
      function top20HighestPaid() returns array of EmployeeSrv;
    };

  entity CountrySrv         as projection on database.Countries;
  entity LifeCycleStatusSrv as projection on database.OverAllStatus;
  entity OverAllStatusSrv   as projection on database.OverAllStatus;

  entity ProductService     as
    projection on database.master.Products {
      *
    }
    actions {
      action   increasePrice() returns array of ProductService;
      function top20product()  returns array of ProductService;
    };

  entity BusinessPartnerSrv as projection on database.master.BusinessPartners;

  @Capabilities: {
    InsertRestrictions.Insertable: false,
    UpdateRestrictions.Updatable : true,
    DeleteRestrictions.Deletable : false,
    ReadRestrictions.Readable    : false
  }
  entity AddressSrv         as projection on database.master.Addresses;

  @Capabilities: {
    DeleteRestrictions: {
      $Type    : 'Capabilities.DeleteRestrictionsType',
      Deletable: false
    },
    UpdateRestrictions: {
      $Type    : 'Capabilities.UpdateRestrictionsType',
      Updatable: false
    },
    InsertRestrictions: {
      $Type     : 'Capabilities.InsertRestrictionsType',
      Insertable: false
    }
  }
  entity PurchaseOrderSrv   as
    select from database.transaction.PurchaseOrders as po
    inner join database.master.BusinessPartners as bp
      on bp.NODE_KEY = po.PARTNER.NODE_KEY
    inner join database.master.Addresses as addr
      on addr.NODE_KEY = bp.AD.NODE_KEY
    inner join database.Countries as country
      on addr.COUNTRY = country.Code
    inner join database.BPRoleFltr as role
      on bp.BP_ROLE = role.code
    {
      key po.NODE_KEY,
          po.PO_ID,
          po.GROSS_AMOUNT,
          po.NET_AMOUNT,
          po.TAX_AMOUNT,
          po.CURRENCY,
          bp.COMPANY_NAME,
          bp.BP_ID,
          role.description    as BP_ROLE,
          bp.MOBILE,
          bp.FAX,
          bp.EMAIL,
          bp.WEB,
          addr.ADDRESS_TYPE,
          addr.BUILDING,
          addr.CITY,
          addr.COUNTRY,
          addr.LATITUDE,
          addr.LONGITUDE,
          addr.STREET,
          addr.POSTAL_CODE,
          po.Items,
          bp.COMPANY_NAME     as partnerName,
          bp.BP_ID            as partnerId,
          addr.COUNTRY        as partnerCountry,
          country.Description as partnerCountryDesc  @(title: '{i18n>COUNTRY}'),

          case
            LIFECYCLE_STATUS
            when 'N'
                 then 2
            when 'S'
                 then 3
            when 'C'
                 then 3
            else 1
          end                 as LSC    : Integer,

          case
            OVERALL_STATUS
            when 'R'
                 then 1
            when 'P'
                 then 3
            when 'D'
                 then 3
            else 2
          end                 as OSC    : Integer,

          case
            LIFECYCLE_STATUS
            when 'N'
                 then 'Not Started'
            when 'S'
                 then 'Started'
            when 'C'
                 then 'Completed'
            else 'Cancelled'
          end                 as LSTEXT : String(20) @(title: '{i18n>LIFECYCLE_STATUS}'),

          case
            OVERALL_STATUS
            when 'R'
                 then 'Returned'
            when 'P'
                 then 'Processed'
            when 'D'
                 then 'Delivered'
            else 'New'
          end                 as OSTEXT : String(20) @(title: '{i18n>OVERALL_STATUS}')
    }
    actions {
      action   discountPrice() returns array of PurchaseOrderSrv;
      function largestOrder()  returns array of PurchaseOrderSrv;
    };

  entity PurchaseItemSrv    as projection on database.transaction.PurchaseItems;

  action   createEmployee(Currency_code: String(3)        @(title: '{i18n>Currency_code}'),
                          ID: UUID                        @(title: '{i18n>ID}'),
                          accountNumber: common.String32  @(title: '{i18n>accountNumber}'),
                          bankId: String(16)              @(title: '{i18n>bankId}'),
                          bankName: common.String64       @(title: '{i18n>bankName}'),
                          email: common.Email             @(title: '{i18n>email}'),
                          gender: common.Gender           @(title: '{i18n>gender}'),
                          language: String(2)             @(title: '{i18n>language}'),
                          loginName: String(16)           @(title: '{i18n>loginName}'),
                          nameFirst: common.String64      @(title: '{i18n>nameFirst}'),
                          nameInitials: common.String64   @(title: '{i18n>nameInitials}'),
                          nameLast: common.String64       @(title: '{i18n>nameLast}'),
                          nameMiddle: common.String64     @(title: '{i18n>nameMiddle}'),
                          phoneNumber: common.PhoneNumber @(title: '{i18n>phoneNumber}'),
                          salaryAmount: common.AmountT    @(title: '{i18n>salaryAmount}')
  )                                              returns array of EmployeeSrv;

  action   updateEmployee(Currency_code: String(3)       @(title: '{i18n>Currency_code}'),
                          ID: UUID                       @(title: '{i18n>ID}'),
                          accountNumber: common.String32 @(title: '{i18n>accountNumber}'),
                          bankId: String(16)             @(title: '{i18n>bankId}'),
                          salaryAmount: common.AmountT   @(title: '{i18n>salaryAmount}')
  )                                              returns String;

  action   deleteEmployee(ID: UUID @(title: '{i18n>ID}')
  )                                              returns String;

  action   createPurchaseItem(GROSS_AMOUNT: Decimal(10, 2) @(title: '{i18n>GROSS_AMOUNT}'),
                              NET_AMOUNT: Decimal(10, 2)   @(title: '{i18n>NET_AMOUNT}'),
                              TAX_AMOUNT: Decimal(10, 2)   @(title: '{i18n>TAX_AMOUNT}'),
                              NODE_KEY: String(36)         @(title: '{i18n>NODE_KEY}'),
                              PARENT_NODE_KEY: String(36)  @(title: '{i18n>PARENT_NODE_KEY}'),
                              PO_ITEM_POS: Integer         @(title: '{i18n>PO_ITEM_POS}'),
                              PRODUCT_NODE_KEY: String(36) @(title: '{i18n>PRODUCT_NODE_KEY}'),
                              CURRENCY_CODE: String(3)     @(title: '{i18n>CURRENCY_CODE}')
  )                                              returns array of PurchaseItemSrv;

  action   updatePurchaseItem(NODE_KEY: String(36)         @(title: '{i18n>NODE_KEY}'),
                              GROSS_AMOUNT: Decimal(10, 2) @(title: '{i18n>GROSS_AMOUNT}'),
                              NET_AMOUNT: Decimal(10, 2)   @(title: '{i18n>NET_AMOUNT}'),
                              TAX_AMOUNT: Decimal(10, 2)   @(title: '{i18n>TAX_AMOUNT}'),
                              PRODUCT_NODE_KEY: String(36) @(title: '{i18n>PRODUCT_NODE_KEY}')
  )                                              returns String;

  action   deletePurchaseItem(NODE_KEY: String(36) @(title: '{i18n>NODE_KEY}')
  )                                              returns String;

  action   createAddress(ADDRESS_TYPE: common.String64,
                         BUILDING: common.String64,
                         CITY: common.String64,
                         COUNTRY: common.String64,
                         LATITUDE: Integer64,
                         LONGITUDE: Integer64,
                         NODE_KEY: Integer64,
                         POSTAL_CODE: Integer64,
                         STREET: Integer64,
                         VAL_END: Date,
                         VAL_START: Date)        returns array of AddressSrv;

  action   updateAddress(NODE_KEY: UUID,
                         CITY: common.String255) returns String;

  action   createProduct(CATEGORY: common.String32,
                         CURRENCY_CODE: String(5),
                         DEPTH: Decimal(5, 2),
                         DESCRIPTION: common.String255,
                         DIM_UNIT: String(2),
                         HEIGHT: Decimal(5, 2),
                         MEASURE_UNIT: String(2),
                         NODE_KEY: UUID,
                         PRICE: Decimal(15, 2),
                         PRODUCT_ID: common.String32,
                         SUPPLIERS_NODE_KEY: common.String32,
                         TAX_TARIF_CODE: Integer,
                         TYPE_CODE: String(2),
                         WEIGHT_MEASURE: Decimal(5, 2),
                         WEIGHT_UNIT: String(2),
                         WIDTH: Decimal(5, 2))   returns array of ProductService;

  action   updateProduct(NODE_KEY: UUID,
                         PRICE: Decimal(15, 2))  returns String;

  action   deleteAddress(NODE_KEY: UUID)         returns String;

  function getHighestSalariedEmployees()         returns array of EmployeeSrv;

  function getHeighestPricedProduct()            returns array of ProductService;

  function getUtilities()                        returns String;
}
