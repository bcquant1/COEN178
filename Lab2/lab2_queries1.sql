SELECT custid, firstname||lastname AS fullname, city FROM Customer;
SELECT * FROM Customer ORDER BY lastname ASC;
SELECT * FROM Schedule ORDER By serviceid ASC, custid DESC;
SELECT serviceid FROM DeliveryService MINUS SELECT serviceid FROM Schedule;

/* Select name from customer, schedule where day = 'M';
does not work because there is no name attribute in the Customer table
*/

SELECT firstname||lastname AS name FROM Customer WHERE custid IN (SELECT custid FROM Schedule WHERE day = 'm');
SELECT lastname FROM Customer WHERE custid IN (SELECT custid FROM Schedule);
SELECT MAX(servicefee) AS highest_Servicefee FROM DeliveryService;

SELECT day, COUNT(day) FROM Schedule GROUP BY day;

/*
Select A.custid, B.custid, A.city
from Customer A, Customer B
where A.city = B.city
--> doesn't work because it will print out duplicate pairs of tuples
*/ 

SELECT A.custid, B.custid, A.city FROM Customer A, Customer B WHERE A.city = B.city AND A.custid > B.custid;
SELECT firstname, lastname, city from Customer NATURAL JOIN Schedule NATURAL JOIN DeliveryService WHERE (location = city);

SELECT MAX(salary) AS MaxSalary FROM Staff_2010;
SELECT MIN(salary) AS MinSalary FROM Staff_2010;

