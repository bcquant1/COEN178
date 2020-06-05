INSERT INTO Customer VALUES('c1','John','Smith','SJ');
INSERT INTO Customer VALUES('c2','Mary','Jones','SFO');
INSERT INTO Customer VALUES('a1','Vincent','Chen','SJ');
INSERT INTO Customer VALUES('a12','Greg','King','SJ');
INSERT INTO Customer VALUES('c7','James','Bond','LA');
INSERT INTO Customer VALUES('x10','Susan','Blogg','SFO');
INSERT INTO Customer VALUES('c4','Steph','Curry','SFO');
INSERT INTO Customer VALUES('q1','Bat','Man','Gotham');

INSERT INTO DeliveryService VALUES('dsg1','grocery','SJ',25.0);
INSERT INTO DeliveryService VALUES('dsb1','books','SJ',10.0);
INSERT INTO DeliveryService VALUES('dsm2','movies','LA',10.0);
INSERT INTO DeliveryService VALUES('dby3','babygoods','SFO',15.0);
INSERT INTO DeliveryService VALUES('dsg2','grocery','SFO',20.0);
INSERT INTO DeliveryService VALUES('dg5','greengoods','SFO',30.0);
INSERT INTO DeliveryService VALUES('dubs5','jerseys','SFO',123.45);
INSERT INTO DeliveryService VALUES('dxy5','cars','Atlantis',56.78);

INSERT INTO Schedule VALUES('dsg1','c1','m');
INSERT INTO Schedule VALUES('dsg1','a12','w');
INSERT INTO Schedule VALUES('dby3','x10','f');
INSERT INTO Schedule VALUES('dg5','c1','r');
INSERT INTO Schedule VALUES('dg5','c1','t');
INSERT INTO Schedule VALUES('dg5','c32','t');
