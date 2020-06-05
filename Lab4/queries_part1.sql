/* Question 1 */
CREATE TABLE AlphaCoEmp(
    Name VARCHAR(25) PRIMARY KEY,
    Title VARCHAR(20) DEFAULT NULL,
    Salary NUMBER(10,2) DEFAULT 0
);

/* INSERT INTO AlphaCoEmp(name) SELECT last from Staff_2010; */

INSERT INTO AlphaCoEmp(name) SELECT DISTINCT last from Staff_2010;

SELECT * FROM AlphaCoEmp;

/* Question 2 */
CREATE TABLE Emp_Work(
    name VARCHAR(25) PRIMARY KEY,
    Project VARCHAR(20) DEFAULT NULL,
    CONSTRAINT FK_AlphaCo
    FOREIGN KEY (name) REFERENCES AlphaCoEmp(name)
);

INSERT INTO Emp_Work(name) SELECT Name FROM AlphaCoEmp 
WHERE REGEXP_LIKE(name, '(^[ags])', 'i');

SELECT Name FROM AlphaCoEmp WHERE REGEXP_LIKE(name, '(^[ags])','i');

DELETE FROM AlphaCoEmp WHERE name = 'Smith';

/* Question 3 */
ALTER TABLE Emp_Work 
DROP CONSTRAINT FK_AlphaCo;

ALTER TABLE EMP_Work 
ADD CONSTRAINT FK_AlphaCo
FOREIGN KEY (name) REFERENCES AlphaCoEmp(name)
ON DELETE CASCADE;

DELETE FROM AlphaCoEmp WHERE name = 'Smith';

SELECT * FROM Emp_Work WHERE name = 'Smith';


