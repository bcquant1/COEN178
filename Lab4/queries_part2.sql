set serveroutput on
/* Question 5 */
Create or Replace Procedure DisplayMessage(message in VARCHAR) 
As
BEGIN
    DBMS_OUTPUT.put_line('Hello '||message);
END;
/
Show Errors;

exec DisplayMessage('include a message');

SELECT ROUND(DBMS_RANDOM.value (10,100)) FROM DUAL;

Create or Replace Procedure setSalaries(low in INTEGER, high in INTEGER)
As
Cursor Emp_cur IS
	SELECT * from AlphaCoEmp;
	-- Local Variables
	l_emprec Emp_cur%rowtype;
	l_salary AlphaCoEmp.salary%type;
BEGIN
	for l_emprec IN Emp_cur
	loop
	    l_salary := ROUND(dbms_random.value(low,high));
	    update AlphaCoEmp
	    set salary = l_salary
	    where name = l_emprec.name;
    END LOOP;
    commit;
END;
/
show errors;

exec setSalaries(50000,100000);

SELECT * FROM AlphaCoEmp;

/* Question 6 */
SELECT name FROM AlphaCoEmp
WHERE salary > 80000 AND salary < 100000;

/* Question 7 */
Create or Replace Procedure setEmpSalary(p_name in VARCHAR, low in INTEGER, high in INTEGER)
As
	l_salary_temp AlphaCoEmp.salary%type;
BEGIN
	l_salary_temp := ROUND(dbms_random.value(low,high));
	update AlphaCoEmp
	set salary = l_salary_temp
	where name = p_name;
    commit;
END;
/
show errors;

exec setEmpSalary('Maher',100,200);
SELECT * FROM AlphaCoEmp;

/* Question 8 */
Create or Replace FUNCTION getEmpSalary(p_name in VARCHAR)
Return NUMBER IS
    l_salary AlphaCoEmp.salary%type;
BEGIN
    SELECT salary INTO l_salary
    FROM AlphaCoEmp
    WHERE name = p_name;

    return l_salary; 
END;
/
show errors;

SELECT getEmpSalary('Maher') FROM Dual;

