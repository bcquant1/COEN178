/* Exercise 1 */
SELECT first||last as FullName, salary
FROM Staff_2010
WHERE salary >= ALL(Select salary FROM Staff_2010);

SELECT first||last as FullName, salary
FROM Staff_2010
WHERE salary = (Select MAX(salary) FROM Staff_2010);

/* Exercise 2 */
SELECT last, salary
FROM Staff_2010
WHERE salary = (SELECT salary FROM Staff_2010 WHERE last = 'Zichal');

SELECT last, salary
FROM Staff_2010
WHERE salary = (SELECT salary FROM Staff_2010 WHERE UPPER(last) = 'ZICHAL');

SELECT last, salary
FROM Staff_2010
WHERE salary = ANY(SELECT salary FROM Staff_2010 WHERE UPPER(last) = 'YOUNG');


/* Exercise 3 */
SELECT COUNT(salary) as SALARIES_100K_ABOVE
FROM Staff_2010
WHERE salary > 100000;

/* Exercise 4 */
SELECT salary, COUNT(salary) as SALARIES_100K_ABOVE
FROM Staff_2010
WHERE salary > 100000
GROUP BY salary;

/* Exercise 5 */
SELECT salary, COUNT(salary) as SALARIES_100K_ABOVE
FROM Staff_2010
WHERE salary > 100000
GROUP BY salary
HAVING COUNT(salary) >= 10;

/* Exercise 6 */
SELECT last
FROM Staff_2010
WHERE REGEXP_LIKE (last, '([aeiou])\1', 'i');
