/* Question 1 */
Create or Replace Procedure assignJobTitlesAndSalaries
As
    type titlesList IS VARRAY(6) OF AlphaCoEmp.title%type;
    type salaryList IS VARRAY(6) of AlphaCoEmp.salary%type;
    v_titles titlesList;
    v_salaries salaryList;
Cursor Emp_cur IS
    Select * from AlphaCoEmp;
    l_emprec Emp_cur%rowtype;
    l_title AlphaCoEmp.title%type;  
    l_salary AlphaCoEmp.salary%type;
    l_randomnumber INTEGER := 1;

BEGIN
/* Titles are stored in the v_titles array  */
/* Salaries for each title are stored in the v_salaries array.
The salary of v_titles[0] title is at v_salaries[0].*/
v_titles := titlesList('advisor', 'director', 'assistant', 'manager', 'supervisor', 'janitor');
v_salaries := salaryList(130000, 100000, 600000, 500000, 800000, 1000000);

/* use a for loop to iterate through the set */
for l_emprec IN Emp_cur
LOOP
    /* We get a random number between 1-5 both inclusive */
    l_randomnumber := dbms_random.value(1,6);
	
    /* Get the title using the random value as the index into thev_tiles array */
    l_title := v_titles(l_randomnumber);
	
    /* Get the salary using the same random value as the index into the v_salaries array */
    l_salary := v_salaries(l_randomnumber);

    /* Update the employee title and salary using the l_titleand l_salary */
    update AlphaCoEmp
    set title = l_title
    where name = l_emprec.name;
	
    update AlphaCoEmp
    set salary = l_salary
    where name = l_emprec.name;
END LOOP;

commit;
END;
/
Show errors;

exec assignJobTitlesAndSalaries

SELECT * FROM  AlphaCoEmp;

/* Question 2 */
Create or Replace Function calcSalaryRaise( p_name in AlphaCoEmp.name%type, percentRaise IN NUMBER)
RETURN NUMBER
IS
    l_salary AlphaCoEmp.salary%type;
    l_raise AlphaCoEmp.salary%type;
    l_cnt Integer;
BEGIN
    -- Find the current salary of p_name from AlphaCoEMP table.
    Select salary into l_salary from AlphaCoEmp
    where UPPER(name) = UPPER(p_name);

    -- Calculate the raise amount
    l_raise := l_salary * (percentRaise/100);

    -- Check if the p_name is in Emp_Work table.
    -- If so, add a $1000 bonus to the
    -- raise amount
    Select count(*) into l_cnt from Emp_Work
    where name = p_name;
    if l_cnt >= 1 THEN
    l_raise := l_raise + 1000;
End IF;

/* return a value from the function */
    return l_raise;
END;
/
Show Errors;

SELECT calcSalaryRaise('Stone',2) from Dual;

Select name, title, salary CURRENTSALARY, 
trunc(calcSalaryRaise(name,2)) NEWSALARY
from AlphaCoEmp where upper(name) = upper('Stone');

/* Question 3 */
Create table EmpStats (title VARCHAR(20) Primary KEY,empcount INTEGER, lastModified DATE);

Create or Replace Function countByTitle(p_title in AlphaCoEmp.title%type)
RETURN NUMBER IS
    l_cnt Integer;
BEGIN
/* Complete the query below */
    Select COUNT(*) into l_cnt from AlphaCoEmp
    Group by title
    Having title = p_title;
    return l_cnt;
END;
/
Show errors;

SELECT countByTitle('director') from Dual;
SELECT countByTitle('advisor') from Dual;

/* Question 4 */
CREATE or REPLACE procedure saveCountByTitle
AS
l_advisor_cnt integer := 0;
l_director_cnt integer := 0;
l_assistant_cnt integer := 0;
l_manager_cnt integer := 0;
l_supervisor_cnt integer := 0;
l_janitor_cnt integer := 0;

BEGIN
l_advisor_cnt := countByTitle('advisor');
l_director_cnt := countByTitle('director');
l_assistant_cnt := countByTitle('assistant');
l_manager_cnt := countByTitle('manager');
l_supervisor_cnt := countByTitle('supervisor');
l_janitor_cnt := countByTitle('janitor');

delete from EmpStats; -- Any previously loaded data is deleted
/* inserting count of employees with title, ‘advisor’.*/
insert into EmpStats values ('advisor',l_advisor_cnt,SYSDATE);
insert into EmpStats values ('director',l_director_cnt,SYSDATE);
insert into EmpStats values ('assistant',l_assistant_cnt,SYSDATE);
insert into EmpStats values ('manager',l_manager_cnt,SYSDATE);
insert into EmpStats values ('supervisor',l_supervisor_cnt,SYSDATE);
insert into EmpStats values ('janitor',l_janitor_cnt,SYSDATE);

END;
/
Show errors;

exec saveCountByTitle;
SELECT * FROM EmpStats;

