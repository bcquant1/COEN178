/* Question 5 */
CREATE Or Replace TRIGGER titlecountchange_trig
AFTER INSERT ON AlphaCoEmp
FOR EACH ROW
BEGIN
Update EmpStats
set Empcount = Empcount + 1, lastmodified = SYSDATE
where title = :new.title;
END;
/
Show errors;

SELECT * FROM EmpStats;
INSERT INTO AlphaCoEmp Values('mickeymouse','advisor',null);
SELECT * FROM EmpStats;

/* Question 6 */
drop trigger titlecountchange_trig;

CREATE Or Replace TRIGGER countchange_trig
AFTER INSERT or DELETE ON AlphaCoEmp
FOR EACH ROW
BEGIN
    IF DELETING THEN
	Update EmpStats
	set Empcount = Empcount -1, lastmodified = SYSDATE
	where title = :old.title;
    END IF;
    IF Inserting THEN
	Update EmpStats
	/* Complete the query here */
	set Empcount = Empcount + 1, lastmodified = SYSDATE
	where title = :new.title;
    End IF;
END;
/
Show errors;

SELECT * FROM EmpStats;
DELETE FROM AlphaCoEmp WHERE name = 'mickeymouse';
SELECT * FROM EmpStats;

