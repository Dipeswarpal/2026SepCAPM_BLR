namespace NewApp;

entity Albums {
    key ID : Integer;
        Title : String(120);
        Description : String(250);
        View : Integer;
        Photos : Association to many Photos on Photos.Album = $self;
}

entity Locations {
    key ID : Integer;
        Name : String(50);
        Shortname : String(50);
        Photos : Association to many Photos on Photos.Location = $self;
}

entity Members {
    key ID : Integer;
        Name : String(250);
        PhoneNum : String(20);
        Email : String(200);
        Address : String(250);
        Photos : Association to many Photos on Photos.Member = $self;
}

entity Photos {
    key ID : Integer;
        Album : Association to Albums;
        Location : Association to Locations;
        Member : Association to Members;
        Title : String(120);
        Description : String(250);
        Privacy : String(20);
        UploadDate  : Date;
        View : Integer;
        ImagePath : String(50);
        Comments : Association to many Comments on Comments.Photo = $self;
        TagPhotos : Association to many Tag_Photos on TagPhotos.Photo = $self;
}

entity Tags {
    key ID : Integer;
        Title : String(120);

        TagPhotos : Association to many Tag_Photos on TagPhotos.Tag = $self;
}

entity Tag_Photos {
    key ID : Integer;
        Tag : Association to Tags;
        Photo : Association to Photos;
}

entity Comments {
    key ID : Integer;
        Photo : Association to Photos;
        PostDate : Date;
        Content : String(250);
}