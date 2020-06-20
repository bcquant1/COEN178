CREATE TABLE StoreItems(
    ItemId VARCHAR(20) PRIMARY KEY,
    price NUMBER(10,2)
);

CREATE TABLE ComicBooks(
    ItemId VARCHAR(20),
    ISBN CHAR(13) UNIQUE,
    Title VARCHAR(20),
    PublishedDate DATE,
    --constraint: number of copies of a ComicBook cannot be < 0
    Copies INTEGER CHECK (Copies >= 0),
    PRIMARY KEY(ItemId),
    FOREIGN KEY (ItemId) REFERENCES StoreItems(ItemId)
);

CREATE TABLE Tshirts(
    ItemId VARCHAR(20),
    ShirtSize VARCHAR(5),
    PRIMARY KEY(ItemId),
    FOREIGN KEY (ItemId) REFERENCES StoreItems(ItemId)
);

CREATE TABLE Customers(
    CustId VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(20),
    --constraint: email must be unique and not null
    Email VARCHAR(20) UNIQUE NOT NULL,
    Address VARCHAR(40),
    DateJoined DATE,
    --constraint: custType of a customer can only be one of two values, 'regular' or 'gold'
    CustType VARCHAR(8) CHECK (CustType = 'regular' OR CustType = 'gold') 
);

CREATE TABLE ItemOrder(
    orderId VARCHAR(10) PRIMARY KEY,
    ItemId VARCHAR(20) REFERENCES StoreItems(ItemId),
    CustId VARCHAR(10) REFERENCES Customers(CustId),
    OrderDate DATE,
    noOfItems INTEGER,
    ShippedDate DATE,
    ShippingFee NUMBER(10,2),
    --constraint: shippedDate cannot be less than the OrderedDate
    CONSTRAINT checkDate CHECK (ShippedDate >= OrderDate)
);
