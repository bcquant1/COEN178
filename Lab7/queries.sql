SET serveroutput ON
CREATE TABLE EMP7(
    empid VARCHAR(5) PRIMARY KEY,
    empName VARCHAR (20),
    deptId VARCHAR(5),
    salary NUMBER(10,2)
);

CREATE TABLE Project7(
    projectID VARCHAR(5) PRIMARY KEY,
    title VARCHAR(20),
    budget NUMBER (10,2),
    startDate Date,
    endDate Date,
    managerId VARCHAR(5)
);

CREATE TABLE EMP_Project(
    projectId VARCHAR(5),
    empid VARCHAR(5),
    commission NUMBER(10,2)
);

INSERT INTO EMP7 VALUES('e1','J.Smith','d1',100000);
INSERT INTO EMP7 VALUES('e2','M.Jones','d1',120000);
INSERT INTO EMP7 VALUES('e3','D.Clark','d2',200000);
INSERT INTO EMP7 VALUES('e4','B.Wayne','d3',300000);
INSERT INTO EMP7 VALUES('e5','O.Queen','d4',400000);

INSERT INTO Project7 VALUES('pj1','Research',1000000,'10-Jan-2019','20-Feb-2020','e1');
INSERT INTO Project7 VALUES('pj2','Research',100000,'10-Feb-2019','20-Apr-2019','e2');
INSERT INTO Project7 VALUES('pj3','Testing',200000,'12-Apr-2019','20-Sep-2021','e3');
INSERT INTO Project7 VALUES('pd4','Leadership',40000,'15-Sep-2019','21-Oct-2021','e5');

INSERT INTO EMP_Project VALUES('pj2','e2',10000);
INSERT INTO EMP_Project VALUES('pj3','e3',20000);
INSERT INTO EMP_Project VALUES('pd4','e5',30000);

/* Question  1 */
CREATE OR REPLACE VIEW CurrentProjects AS 
SELECT projectID,title,managerId
FROM Project7
WHERE endDate > SYSDATE;

CREATE OR REPLACE VIEW PastProjects AS
SELECT title,managerId 
FROM Project7
WHERE endDate < SYSDATE;

SELECT * FROM CurrentProjects;
SELECT * FROM PastProjects;

INSERT INTO CurrentProjects VALUES('p99','Testing','e2');
SELECT * FROM Project7;

INSERT INTO PastProjects VALUES('testing','e2');

CREATE OR REPLACE VIEW ManagedProjects AS
SELECT projectID,title AS Project_Title, empName AS ManagerName
FROM EMP7,Project7
WHERE EMP7.empid = Project7.managerid;

SELECT * FROM ManagedProjects;

INSERT INTO ManagedProjects VALUES('p88','Design','Mary Mason');


/* Question 4 */
CREATE TABLE ItemOrder(
    orderNo VARCHAR(5) PRIMARY KEY,
    qty INTEGER
);

CREATE OR REPLACE TRIGGER ItemOrder_after_insert_trig
AFTER INSERT
    ON ItemOrder
    FOR EACH ROW
DECLARE
    v_quantity INTEGER;
BEGIN
    SELECT qty INTO v_quantity
    FROM ItemOrder
    WHERE orderNo = 'o1';
END;
/
Show Errors;

INSERT INTO ItemOrder values('o1',100);

/* Question 5 */
CREATE TABLE Course(
    courseNo INTEGER PRIMARY KEY,
    courseName VARCHAR(20)
);

CREATE TABLE Course_Prereq(
    courseNo INTEGER,
    prereqNo INTEGER,
    FOREIGN KEY(prereqNo) REFERENCES Course(courseNo)
);

INSERT INTO Course VALUES(10,'C++');
INSERT INTO Course VALUES(11,'Java');
INSERT INTO Course VALUES(12,'Python');
INSERT INTO Course VALUES(121,'Web');
INSERT INTO Course VALUES(133,'Software Eng');

CREATE OR REPLACE TRIGGER LimitTest
    BEFORE INSERT OR UPDATE ON Course_Prereq
    FOR EACH ROW -- A row level trigger
DECLARE
    v_MAX_PREREQS CONSTANT INTEGER := 2;
    v_CurNum INTEGER;
BEGIN
    BEGIN
	SELECT COUNT(*) INTO v_CurNum FROM Course_Prereq
	WHERE courseNo = :new.CourseNo GROUP BY courseNo;
	EXCEPTION
	    -- Before you enter the first row, no data is found
	    WHEN no_data_found THEN
	    DBMS_OUTPUT.put_line('not found');
		v_CurNum := 0;
    END;
    if v_curNum > 0 THEN
	IF v_CurNum + 1 > v_MAX_PREREQS THEN
	    RAISE_APPLICATION_ERROR(-20000,'Only 2 prereqs or course');
	END IF;
    END IF;
END;
/
Show Errors;

INSERT INTO Course_Prereq VALUES(121,11);
INSERT INTO Course_Prereq VALUES(121,10);
SELECT * FROM Course_Prereq;

INSERT INTO Course_Prereq VALUES(121,12);
SELECT * FROM Course_Prereq;

INSERT INTO Course_Prereq VALUES(133,12);
SELECT * FROM Course_Prereq;

update COURSE_PREREQ
SET courseno = 121 where courseno = 133;

SELECT * FROM Course_Prereq;

/* Question 6 */
DELETE FROM Course_Prereq;

CREATE OR REPLACE TRIGGER LimitTest
FOR INSERT OR UPDATE
ON Course_Prereq
COMPOUND TRIGGER

/* Declaration Section*/
v_MAX_PREREQS CONSTANT INTEGER := 2;
    v_CurNum INTEGER := 1;
    v_cno INTEGER;

--ROW level
BEFORE EACH ROW IS
BEGIN
    v_cno := :NEW.COURSENO;
END BEFORE EACH ROW;

--Statement level
AFTER STATEMENT IS
BEGIN
SELECT COUNT(*) INTO v_CurNum FROM Course_Prereq
    WHERE courseNo = v_cno GROUP BY courseNo;
    IF v_CurNum > v_MAX_PREREQS THEN
	RAISE_APPLICATION_ERROR(-20000,'Only 2 prereqs for course');
    END IF;
END AFTER STATEMENT;
END;
/
Show Errors; 


INSERT INTO Course_Prereq VALUES(121,11);
INSERT INTO Course_Prereq VALUES(121,10);
INSERT INTO Course_Prereq VALUES(121,12);
INSERT INTO Course_Prereq VALUES(133,12);

SELECT * FROM Course_Prereq;

update COURSE_PREREQ
SET courseno = 121 where courseno = 133;

SELECT * FROM Course_Prereq;
