INSERT INTO StoreItems VALUES('Bat',12.50);
INSERT INTO ComicBooks VALUES('Bat', 123456789, 'Batman', '09-MAY-39', 10);
INSERT INTO StoreItems VALUES('Fla',10.01);
INSERT INTO ComicBooks VALUES('Fla', 975463646, 'Flash', '12-JUN-96', 1);
INSERT INTO StoreItems VALUES('Super',5.25);
INSERT INTO ComicBooks VALUES('Super',364635346, 'Superman','14-OCT-38', 2000);

INSERT INTO StoreItems VALUES('123',20.50);
INSERT INTO Tshirts VALUES('123','M');
INSERT INTO StoreItems VALUES('456',130.00);
INSERT INTO Tshirts VALUES('456','L');
INSERT INTO StoreItems VALUES('789',10.25);
INSERT INTO Tshirts VALUES ('789','XXL');

INSERT INTO Customers VALUES('1234','Brandon Quant', 'quant@gmail.com', '253 Stark Ave', '05-JAN-18','gold');
INSERT INTO Customers VALUES('3456','Tony Stark', 'stark@stark.com','100 Victory Road','23-JAN-12','gold');
INSERT INTO Customers VALUES('420','John Smith','jsmith@gmail.com','123 Smith Road', NULL, 'regular');
INSERT INTO Customers VALUES('30','Steph Curry','curry@warriors.com','1 Chase Ave', NULL, 'regular');
INSERT INTO Customers VALUES('11', 'Klay Thompson','klay@warriors.com','2 Chase Ave', '15-NOV-11','gold');

SELECT * FROM StoreItems;
SELECT * FROM ComicBooks;
SELECT * FROM Tshirts;
SELECT * FROM Customers;



