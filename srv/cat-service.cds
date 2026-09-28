using {NewApp.db as database} from '../db/schemaNew';
using {NewApp.commonNew as common} from '../db/common';

service CatalogService {
  //Master data which is in the Master Context

  @Capabilities: {
    InsertRestrictions.Insertable: true,
    UpdateRestrictions.Updatable : true,
    DeleteRestrictions.Deletable : true,
    ReadRestrictions.Readable    : true
  }

  entity EmployeeSrv        as projection on database.master.Employees {
    *
  } actions {
    action increaseSalary() returns array of EmployeeSrv;
function top20HighestPaid() returns array of EmployeeSrv; 
  };

/*  entity ProductSrv         as
    projection on database.master.Products {
      *
    }
    actions {
      action   increasePrice() returns array of ProductSrv;
      function top20product()  returns array of ProductSrv;
    }; */

  //Transactional data which is in Transaction contex
  /*entity ProductSrv   as
    projection on database.master.Products {
      *
    }
    actions {
      //Declare instance bounded action
      action   increasePrice() returns array of ProductSrv;
      function top20product()  returns array of ProductSrv;
    }; */

  entity ProductService   as
    projection on database.master.Products {
      *
    }
    actions {
      //Declare instance bounded action
      action   increasePrice() returns array of ProductService;
      function top20product()  returns array of ProductService;
    };

  entity BusinessPartnerSrv as projection on database.master.BusinessPartners;

  @Capabilities: {
    InsertRestrictions.Insertable: true,
    UpdateRestrictions.Updatable : true,
    DeleteRestrictions.Deletable : true,
    ReadRestrictions.Readable    : false
  }
  entity AddressSrv         as projection on database.master.Addresses;

  //Transactional data which is in Transaction contex
  entity PurchaseOrderSrv   as
    projection on database.transaction.PurchaseOrders {
      *
    }
    actions {
      //Declare instance bounded action
      action   discountPrice() returns array of PurchaseOrderSrv;

      function largestOrder()  returns array of PurchaseOrderSrv;

    };

  entity PurchaseItemSrv    as projection on database.transaction.PurchaseItems;

  action   createEmployee(Currency_code: String(3),
                          ID: UUID,
                          accountNumber: common.String32,
                          bankId: String(16),
                          bankName: common.String64,
                          email: common.Email,
                          gender: common.Gender,
                          language: String(2),
                          loginName: String(16),
                          nameFirst: common.String64,
                          nameInitials: common.String64,
                          nameLast: common.String64,
                          nameMiddle: common.String64,
                          phoneNumber: common.PhoneNumber,
                          salaryAmount: common.AmountT) returns array of EmployeeSrv;


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
                         VAL_START: Date, )             returns array of AddressSrv;

  action   updateAddress(NODE_KEY: UUID,
                         CITY: common.String255)        returns String;

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
                         WIDTH: Decimal(5, 2))          returns array of ProductService;

  action   updateProduct(NODE_KEY: UUID,
                         PRICE: Decimal(15, 2))         returns String;

  action   deleteAddress(NODE_KEY: UUID)                returns String;

  // Custom Function Declaration

  function getHighestSalariedEmployees()                returns array of EmployeeSrv;
  // Custom Function Declaration
  function getHeighestPricedProduct()                   returns array of ProductService;

  function getUtilities() returns String;
}
