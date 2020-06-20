set serveroutput ON

/* Testing addItemOrder and computeTotal*/

--adding Batman Comic Book for Brandon
exec addItemOrder('1','Bat','1234','01-MAY-20',1,NULL);
SELECT computeTotal('1') FROM DUAL;

--adding rest of Batman Comics to Klay
exec addItemOrder('2','Bat','30','03-MAY-20',9,NULL);
SELECT computeTotal('2') FROM DUAL;

--Checking if discount for gold customers work
--adding Superman Comic Book for Steph (regular customer)
exec addItemOrder('3','Super','30','02-MAY-20',100,NULL);
SELECT computeTotal('3') FROM DUAL;

--adding Superman Comic Book for Tony (gold customer)
exec addItemOrder('4','Super','3456','03-MAY-20',100,NULL);
SELECT computeTotal('4') FROM DUAL;

--adding tshirts to a gold customer 
exec addItemOrder('5','123','1234','17-MAY-20',50,NULL);
SELECT computeTotal('5') FROM DUAL;

--adding tshirts to a regular customer
exec addItemOrder('6','789','420','06-MAY-20',10,NULL);
SELECT computeTotal('6') FROM DUAL;

--output of not enough books
SELECT * FROM ComicBooks;
exec addItemOrder('7','Bat','3456','07-MAY-20',1,NULL);
exec addItemOrder('8','Fla','3456','07-MAY-20',10,NULL);



/* Testing changeCustType_trig */
SELECT * FROM Customers;
SELECT * FROM ItemOrder;

update Customers SET CustType = 'gold', DateJoined = '25-DEC-17' WHERE CustId = '420';
update Customers SET CustType = 'regular', DateJoined = NULL WHERE CustId = '3456';

SELECT * FROM Customers;
SELECT * FROM ItemOrder;


/* Testing setShippingDate */
SELECT * FROM ItemOrder;

exec setShippingDate('1','02-MAY-20');
exec setShippingDate('2','04-MAY-20');
exec setShippingDate('3','03-MAY-20');
exec setShippingDate('4','04-MAY-20');
exec setShippingDate('5','18-MAY-20');
--Testing constraint of shippingDate >= OrderDate
exec setShippingDate('6','01-MAY-20');

SELECT * FROM ItemOrder;

/* Testing showItemOrders*/
exec showItemOrders('30','01-JAN-20');
--Testing inputDate constraint
exec showItemOrders('1234','03-MAY-20');
