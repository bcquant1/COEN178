CREATE TABLE Customer(
  custid VARCHAR(5) PRIMARY KEY,
  firstname VARCHAR(10),
  lastname VARCHAR(15),
  city VARCHAR(10)
);

CREATE TABLE DeliveryService(
  serviceid VARCHAR(10) PRIMARY KEY,
  item VARCHAR(15),
  location VARCHAR(15),
  servicefee NUMBER(5,2)
 );

CREATE TABLE Schedule(
  serviceid VARCHAR(10),
  custid VARCHAR(5),
  day VARCHAR(2) NOT NULL CHECK (day IN ('m','t','w','r','f')),
  FOREIGN KEY (serviceid) REFERENCES DeliveryService(serviceid),
  FOREIGN KEY (custid) REFERENCES Customer(custid)
);
