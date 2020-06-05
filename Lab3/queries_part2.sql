/* Exercise 7 */
SELECT deptid AS deptno, COUNT(*) AS empcount
FROM L_EMP
GROUP BY deptid;

/* Exercise 8 */
SELECT deptNo, deptName, empcount
FROM (SELECT deptid as deptNo, COUNT(*) AS empcount FROM L_EMP GROUP BY deptid), L_DEPT 
WHERE deptNo = L_DEPT.deptId;

SELECT deptNo, deptName, empcount
FROM (SELECT deptid as deptNo, COUNT(*) AS empcount FROM L_EMP GROUP BY deptid), L_DEPT
WHERE deptNO = L_DEPT.deptId
ORDER BY empcount;

/* Exercise 9 */
/* Attempt 1

SELECT deptid, max(count(*)) FROM L_EMP
GROUP BY deptid;

Attempt 2
SELECT deptid FROM L_EMP
GROUP BY deptId
HAVING COUNT(*) = (SELECT COUNT(*) FROM L_EMP GROUP BY deptId);
*/

SELECT deptid, COUNT(*) as NumberOfEmployees
FROM L_EMP
GROUP BY deptId
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM L_EMP GROUP BY deptid); 

SELECT deptname FROM L_DEPT
WHERE deptId = (SELECT deptid FROM L_EMP 
		GROUP BY deptId 
		HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM L_EMP GROUP BY deptid));

/* Exercise 10*/
SELECT * FROM L_EMP NATURAL JOIN L_DEPT;

SELECT L_EMP.deptid, empNo, empName, deptName FROM L_EMP, L_DEPT
WHERE L_EMP.deptID = L_DEPT.deptId;
