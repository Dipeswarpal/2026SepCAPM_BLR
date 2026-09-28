namespace NewApp.common;
using { Country, Currency } from '@sap/cds/common';
// type ![Employee] : String(50); This is the syntax for the identifier

type namestd  : String(50);
type idstd : Integer;

aspect address {
    drNo : String(50);
    street : String(50);
    landMark : String(50);
    city : String(50);
    postal : Integer;
    state    : String(100);
    country  : Country;
    region   : String(20);
}

aspect fee {
    gross_fee : Decimal;
    currency : Currency;
    tax : Decimal(10,2);
    total_fee : Decimal(10,2);
}
type Gender : String(20) enum {
    M = 'Male';
    F = 'Female';
    U = 'Undisclosed';
}

type Status : String(10) enum {
    S = 'Submitted';
    A = 'Approved';
    I = 'Isuued';
    R = 'Rejected';
}



type AmountT : Decimal(10,2) @(
    semantics.amount.currencyCode : 'CURRENCY_CODE',
    sap.unit : 'CURRENCY_CODE'
);


type PhoneNumber : String(20) @assert.format : '^(?:(?:\+|00)?91[\-\s]?)?[6-9]\d{9}$';
aspect fees2 {
    gross_fee :AmountT;
    currency : Currency;
    tax : AmountT;
    total_fee : AmountT;
}

type Email : String(100)
    @assert.format: '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}';
