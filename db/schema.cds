
namespace NewApp;

using { NewApp.common as common } from './common';
// using { managed, temporal} from '@sap/cds/common';

// type ![Employee] : String(50); This is the syntax for the identifier

entity Students : common.address, common.fee{

    key studentId : common.idstd;
    studentName : common.namestd;
    fatherName : common.namestd;
    motherName : common.namestd;
    contactNo : common.PhoneNumber;
    email : common.Email;
    gender : common.Gender;
    //Managed Association
    class: Association to Classes;
    //unmanaged Association
    bookId : Association to many Libraries on bookId.parent = $self;

}

entity Classes {
    key classId : Integer;
    className : String(50);
    teacherName : String(50);

}

entity Libraries{
    key bookId : Integer;
    bookName : common.namestd;
    parent : Association to Students;
    studentName : common.namestd;
    issueDate : Date;
    returnDate : Date;
    status : common.Status;
    AuthorName : common.namestd; 
}

entity Employees {
    key empId: Integer;
    empName: String(50);
    salary: String(20);
    dept: String(20);
    city: String(20);
    country: String(20);
    division: Association to one Divisions;
}
 
entity Divisions {
    key divId: Integer;
    divName: String(20);
    city: String(20);
    country: String(20);
}