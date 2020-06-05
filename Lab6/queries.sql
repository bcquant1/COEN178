/* Part 1 */
/* Exercise 1*/
SET serveroutput ON;
CREATE TABLE BANKCUST_6(
    custno VARCHAR(5) PRIMARY KEY,
    custname VARCHAR(10),
    street VARCHAR(30),
    city VARCHAR(20)
);

CREATE TABLE ACCOUNTS_6(
    AccountNo VARCHAR(5) PRIMARY KEY,
    accountType VARCHAR(10),
    amount NUMBER(10,2),
    custno VARCHAR(5),
    CONSTRAINT accounts_fkey FOREIGN KEY (custno) REFERENCES BANKCUST_6(custno)
);

CREATE TABLE TOTALS_6(
    custno VARCHAR(5),
    totalAmount NUMBER(10,2),
    CONSTRAINT totals_fkey FOREIGN KEY (custno) REFERENCES BANKCUST_6(custno)
);


CREATE or REPLACE TRIGGER display_customer_trig
    AFTER  INSERT on BankCust_6
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('From Trigger '||'Customer NO: '||:new.custno||' Customer Name: '||:new.custname||' City: '||:new.city);
END;
/
show errors;

INSERT INTO BANKCUST_6 VALUES('c1','Smith','32 Lincoln st','SJ');
INSERT INTO BANKCUST_6 VALUES('c2','Jones','44 Benton st','SJ');
INSERT INTO BANKCUST_6 VALUES('c3','Peters','12 palm st','SFO');
INSERT INTO BANKCUST_6 VALUES('c20','Chen','20 san felipo','LA');
INSERT INTO BANKCUST_6 VALUES('c33','Williams','11 cherry Ave','SFO');

/* Exercise 2 */
Alter trigger display_customer_trig disable;

CREATE Or REPLACE Trigger Acct_Cust_Trig
AFTER INSERT ON Accounts_6
FOR EACH ROW
BEGIN
    update totals_6
    set totalAmount = totalAmount + :new.amount
    where custno = :new.custno;

insert into totals_6(select :new.custno, :new.amount from dual where not exists (select * from TOTALS_6 where custno = :new.custno));
END;
/
show errors;

DELETE FROM ACCOUNTS_6;
DELETE FROM TOTALS_6;

INSERT INTO ACCOUNTS_6 VALUES('a1523','checking',2000.00,'c1');
INSERT INTO ACCOUNTS_6 VALUES('a2134','saving',5000.00,'c1');
INSERT INTO ACCOUNTS_6 VALUES('a4378','checking',1000.00,'c2');
INSERT INTO ACCOUNTS_6 VALUES('a5363','saving',8000.00,'c2');
INSERT INTO ACCOUNTS_6 VALUES('a7236','checking',500.00,'c33');
INSERT INTO ACCOUNTS_6 VALUES('a8577','checking',150.00,'c20');

SELECT * FROM TOTALS_6;
SELECT * FROM ACCOUNTS_6;

/* Exercise 3 */
update Accounts_6
set amount = 1000
where accountno = 'a1523';

SELECT * FROM TOTALS_6;
SELECT * FROM ACCOUNTS_6;

/* Exercise 4 */
CREATE or REPLACE Trigger Acct_Cust_Trig
AFTER INSERT OR UPDATE ON Accounts_6
FOR EACH ROW
BEGIN
    If inserting then
	update totals_6
	set totalAmount = totalAmount + :new.amount
	where custno = :new.custno;
	
	insert into totals_6(select :new.custno, :new.amount from dual
	where not exists(select * from TOTALS_6 where custno = :new.custno));
    END IF;
    if updating then
	update totals_6
	set totalAmount = totalAmount + :new.amount - :old.amount
	where custno = :new.custno;
    END IF;
END;
/
show errors;

DELETE FROM ACCOUNTS_6;
DELETE FROM TOTALS_6;

INSERT INTO ACCOUNTS_6 VALUES('a1523','checking',2000.00,'c1');
INSERT INTO ACCOUNTS_6 VALUES('a2134','saving',5000.00,'c1');
INSERT INTO ACCOUNTS_6 VALUES('a4378','checking',1000.00,'c2');
INSERT INTO ACCOUNTS_6 VALUES('a5363','saving',8000.00,'c2');
INSERT INTO ACCOUNTS_6 VALUES('a7236','checking',500.00,'c33');
INSERT INTO ACCOUNTS_6 VALUES('a8577','checking',150.00,'c20');

SELECT * FROM TOTALS_6;
SELECT * FROM ACCOUNTS_6;

update Accounts_6
set amount = 1000
where accountno = 'a1523';

SELECT * FROM TOTALS_6;
SELECT * FROM ACCOUNTS_6;

/* Exercise 5 */
CREATE OR REPLACE Trigger NoUpdatePK_trig
AFTER UPDATE ON BANKCUST_6
FOR EACH ROW
BEGIN
    if updating ('custno') then
	raise_application_error(-20999,'Cannot update a Primary Key');
    END IF;
END;
/
show errors;

SELECT * FROM BANKCUST_6;

UPDATE BANKCUST_6
Set custno = 'c99'
Where custno = 'c1';

SELECT * FROM BANKCUST_6;
