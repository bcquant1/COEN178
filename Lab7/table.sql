/* Question 3 */

DROP TABLE MyExpenses;

CREATE TABLE MyExpenses(
    category VARCHAR(15),
    price NUMBER(10,2)
);

INSERT INTO MyExpenses VALUES('Groceries',60.23);
INSERT INTO MyExpenses VALUES('Groceries',34.83);
INSERT INTO MyExpenses VALUES('Groceries',94.32);
INSERT INTO MyExpenses VALUES('Groceries',29.12);

INSERT INTO MyExpenses VALUES('Entertainment',15.23);
INSERT INTO MyExpenses VALUES('Entertainment',23.34);
INSERT INTO MyExpenses VALUES('Entertainment',44.44);
INSERT INTO MyExpenses VALUES('Entertainment',10.15);

INSERT INTO MyExpenses VALUES('Gas',30.23);
INSERT INTO MyExpenses VALUES('Gas',27.34);
INSERT INTO MyExpenses VALUES('Gas',35.44);
INSERT INTO MyExpenses VALUES('Gas',40.15);

SELECT * FROM MyExpenses;
