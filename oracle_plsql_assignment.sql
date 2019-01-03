--1. Display the last name concatenated with the job ID, separated by a comma and space, and name the column Employee and Title
SELECT concat(LAST_NAME,concat(',  ',JOB_ID))  "Employee and Title" from EMPLOYEES;
--or
SELECT LAST_NAME||',  '|| JOB_ID  "Employee and Title" from EMPLOYEES;

--2.	Create a query to display all the data from the EMPLOYEES table. Separate each column by a comma. Name the column THE_OUTPUT
SELECT EMPLOYEE_ID ||','|| FIRST_NAME ||','|| LAST_NAME ||','|| EMAIL ||','|| PHONE_NUMBER ||','|| HIRE_DATE ||','|| JOB_ID ||','|| SALARY ||','||COMMISSION_PCT||','|| MANAGER_ID||','||DEPARTMENT_ID as THE_OUTPUT from EMPLOYEES;

--3.	Create a query to display the last name and salary for all employees whose salary is not in the range of 5,000 and 12,000.
SELECT LAST_NAME, SALARY from EMPLOYEES where SALARY not between 5000 AND 12000;

--4.	Display the employee last name, job ID, and start date of employees hired between February 20, 1998, and May 1, 1998. Order the query in ascending order by start date.
SELECT LAST_NAME, JOB_ID, HIRE_DATE from EMPLOYEES where HIRE_DATE between '20-feb-1998' and '01-may-1998' order by HIRE_DATE ASC;
--or
SELECT LAST_NAME, JOB_ID, HIRE_DATE from EMPLOYEES where HIRE_DATE between '20-02-1998' and '01-05-1998' order by HIRE_DATE;

--5.	Display the last name and department number of all employees in departments 20 and 50 in alphabetical order by name
SELECT LAST_NAME,DEPARTMENT_ID from EMPLOYEES where DEPARTMENT_ID in (20,50) order by LAST_NAME;

--6.	Display the last name and job title of all employees who do not have a manager.
SELECT LAST_NAME, JOB_TITLE from EMPLOYEES e, JOBS j where MANAGER_ID is null AND e.JOB_ID = j.JOB_ID;

--7.	Display the last name, salary, and commission for all employees who earn commissions. Sort data in descending order of salary and commissions.
SELECT LAST_NAME, SALARY, (SALARY*COMMISSION_PCT) "COMMISSIONS" from EMPLOYEES where COMMISSION_PCT is not null order by SALARY,COMMISSION_PCT desc;

--8.	For each employee, display the employee number, last_name, salary, and salary increased by 15% and expressed as a whole number. Label the column New Salary
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, round(SALARY+(SALARY*0.15)) "New Salary" from EMPLOYEES; 

--9.	Modify your above query to add a column that subtracts the old salary from the new salary. Label the column Increase
SELECT EMPLOYEE_ID, LAST_NAME, SALARY, round(SALARY+(SALARY*0.15)) "New Salary",round(SALARY + (SALARY *0.15)) - SALARY "Increase" from EMPLOYEES; 

--10.	Write a query that displays the employee’s last names with the first letter capitalized and all other letters lowercase and the length of the name for all employees whose name starts with J, A, or M. Give each column an appropriate label. Sort the results by the employees’ last names
WITH 
pattern_list AS (
SELECT 'J%' pattern FROM DUAL UNION ALL 
SELECT 'A%' pattern FROM DUAL UNION ALL 
SELECT 'M%' pattern FROM DUAL
)
SELECT INITCAP(LAST_NAME) "last name", length(LAST_NAME) "length of the name"  from EMPLOYEES
  JOIN pattern_list
    ON LAST_NAME LIKE pattern
 ORDER BY LAST_NAME;

--or 
SELECT  INITCAP(LAST_NAME) "last name", length(LAST_NAME) "length of the name" from EMPLOYEES where LAST_NAME like 'J%'
or LAST_NAME like 'A%' or LAST_NAME like 'M%' order by LAST_NAME;

--11.	Create a unique listing of all jobs that are in department 80. Include the location of the department in the output.
SELECT distinct(j.JOB_ID),job_title,loc from jobs j inner join 
EMPLOYEES e on e.JOB_ID = j.JOB_ID inner join
DEPARTMENT ON DEPARTMENT_ID = DEPTNO AND DEPTNO = 80;

--or
SELECT distinct(j.job_id),job_title,loc from EMPLOYEES e, JOBS j, DEPARTMENT d where d.DEPTNO=80 AND e.DEPARTMENT_ID = d.DEPTNO AND e.JOB_ID=j.JOB_ID;

--12.	Display the employee last name and department name for all employees who have an “a” (lowercase) in their last names.
SELECT distinct e.LAST_NAME, d.DNAME from EMPLOYEES e left outer join
DEPARTMENT d ON (e.DEPARTMENT_ID = d.DEPTNO) where LAST_NAME like '%a%';

--or
SELECT distinct last_name,dname from EMPLOYEES,DEPARTMENT where DEPARTMENT_ID = DEPTNO AND LAST_NAME like '%a%';

--13.	Write a query to display the last name, job, department number, and department name for all employees who work in Toronto.
SELECT e.LAST_NAME, e.JOB_ID, e.DEPARTMENT_ID,d.DNAME from EMPLOYEES e
inner join DEPARTMENT d ON (e.DEPARTMENT_ID = d.DEPTNO) where d.LOC ='Toronto';

--14.	Create a query that displays employee last names, department numbers, and all the employees who work in the same department as a given employee. Give each column an appropriate label.
SELECT LAST_NAME "Last Name", DEPARTMENT_ID "Department Number" from EMPLOYEES emp
where DEPARTMENT_ID in (SELECT DEPARTMENT_ID from EMPLOYEES emp1 where emp1.LAST_NAME = '&Name');

--15.	Display the names and hire dates for all employees who were hired before their managers, along with their manager’s names and hire dates. Label the columns Employee, Emp Hired, Manager, and Mgr Hired, respectively.
SELECT e.EMPLOYEE_ID, e.FIRST_NAME||' '||e.LAST_NAME "Employee", e.HIRE_DATE "Emp Hired", 
m.FIRST_NAME||' '||m.LAST_NAME "Manager", m.HIRE_DATE "Mgr Hired"
from EMPLOYEES e left outer join 
EMPLOYEES m on (e.MANAGER_ID = m.EMPLOYEE_ID)
where e.HIRE_DATE < m.HIRE_DATE order by e.EMPLOYEE_ID;

--16.	Display the highest, lowest, sum, and average salary of all employees. Label the columns Maximum, Minimum, Sum, and Average, respectively. Round your results to the nearest whole number
SELECT ROUND(MAX(SALARY)) as "Maximun", ROUND(MIN(SALARY)) as "Minimum", ROUND(SUM(SALARY)) as "Sum", ROUND(AVG(SALARY)) as "Average" from EMPLOYEES;

--17.	Determine the number of managers without listing them. Label the column Number of Managers.
SELECT count(distinct(Manager_id)) "Number of Managers" from EMPLOYEES;

--18.	Create a query that will display the total number of employees and, of that total, the number of employees hired in 1995, 1996, 1997, and 1998. Create appropriate column headings.
SELECT count(*) "Total No. of Employees",SUM(case when  year in (1995,1996,1997,1998) then 1 else 0 end) "Total employees from 95 to 98"  from (SELECT EXTRACT(year FROM hire_date) as year from EMPLOYEES);

--19.	Create a matrix query to display the job, the salary for that job based on department number, and the total salary for that job, for departments 20, 50, 80, and 90, giving each column an appropriate heading.
SELECT  *
  FROM  (SELECT job_id,
                SUM(DECODE(DEPARTMENT_ID,20,SALARY)) "Department 20",
                SUM(DECODE(DEPARTMENT_ID,50,SALARY)) "Department 50",
                SUM(DECODE(DEPARTMENT_ID,80,SALARY)) "Department 80",
                SUM(DECODE(DEPARTMENT_ID,90,SALARY)) "Department 90"
           FROM EMPLOYEES
       GROUP BY job_id)
ORDER BY job_id;

--20.	Write a query that displays the employee numbers and last names of all employees who work in a department with any employee whose last name contains a “u”.
SELECT EMPLOYEE_ID, LAST_NAME from EMPLOYEES where DEPARTMENT_ID IS NOT NULL AND LAST_NAME like '%u%'; 
--or
SELECT EMPLOYEE_ID,LAST_NAME from EMPLOYEES where DEPARTMENT_ID in (SELECT distinct(DEPARTMENT_ID) from EMPLOYEES where LAST_NAME like '%u%');

--21.	Write a query to display the last name, department number, and salary of any employee whose department number and salary both match the department number and salary of any employee who earns a commission
SELECT LAST_NAME, DEPARTMENT_ID, SALARY from EMPLOYEES e1
where (e1.DEPARTMENT_ID,e1.SALARY) in (SELECT DEPARTMENT_ID,SALARY from EMPLOYEES e2 where e2.COMMISSION_PCT is not null);

--22.	Create a query to display the last name, hire date, and salary for all employees who have the same salary and commission as Kochhar
SELECT LAST_NAME, HIRE_DATE, SALARY from EMPLOYEES e1
where (e1.SALARY,e1.COMMISSION_PCT) in 
(SELECT e2.SALARY, e2.COMMISSION_PCT from EMPLOYEES e2 where e2.LAST_NAME = 'Kochhar');

--23.	Write a query to find all employees who earn more than the average salary in their departments. Display last name, salary, department ID, and the average salary for the department. Sort by average salary. Use aliases for the columns retrieved by the query as shown in the sample output.
WITH AVG_SAL as (SELECT DEPARTMENT_ID, avg(SALARY) AVG_SALARY from EMPLOYEES group by DEPARTMENT_ID)
SELECT e.LAST_NAME "Last Name", e.SALARY "Salary", e.DEPARTMENT_ID "Department ID", sal.AVG_SALARY "Avg Salary of Dept"
from EMPLOYEES e,AVG_SAL sal where e.SALARY > sal.AVG_SALARY and
e.DEPARTMENT_ID = sal.DEPARTMENT_ID order by sal.AVG_SALARY;
