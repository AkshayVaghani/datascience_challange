-- CASE STUDY # 1
-- Please answer the SQL questions. There are several ways to write these SQL statement and any form (  PostgreSQL, MySQL, MS SQL) is acceptable as long as it generates the correct answers.

-- 1.  The salary table contains salary information of all employees in various departments of ABC Company. A partial view of the table is given below.

-- a.  Write a SQL statement to find the highest salaried employee in each department.
select a.Department,a.max_salary,b.Emp_ID,b.Name from
(Select a1.Department , max(a2.Yearly_Salary) as max_salary from
EE_information as a1
left join
EE_salary as a2
on a1.Emp_ID = a2.Emp_ID group by a1.Department) a
left join
(select b1.* ,b2.Name, b2.DOB, b2.Yearly_Salary from
EE_information as b1
left join
EE_salary as b2
on b1.Emp_ID = b2.Emp_ID) b
on a.Department=b.Department and a.max_salary=b.Yearly_Salary;


-- b.  Write a SQL statement to calculate average salary per department.
Select a1.Department , avg(a2.Yearly_Salary) as avg_salary from
EE_information as a1
left join
EE_salary as a2
on a1.Emp_ID = a2.Emp_ID group by a1.Department;


-- c.  Write a SQL statement to find employees whose name starts with ‘J’.
select * from EE_salary where Name like 'j%';


-- d.  Write a SQL statement to find employees who have been in the company 5+ years.
-- using age() function
select Emp_ID from EE_information where EXTRACT(YEAR from age(CURRENT_DATE,Hire_Date))>5;
-- using datediff function
select Emp_ID from EE_information where DATEDIFF(YEAR,CURRENT_DATE,Hire_Date)>5;


--e.  Write a SQL statement to find the number of employees who work in Finance department
select count(distinct Emp_ID) from EE_information where Department='Finance';


--f.  Write a SQL statement to list employee names and their tenure in the company.
select a.Emp_ID, b.Name, DATEDIFF(day,CURRENT_DATE,Hire_Date) as tenure_days
from EE_information as a
left join EE_salary as b
on a.Emp_ID =b.Emp_ID ;


--g.  Write a SQL statement to list employees with the highest tenure in each department.
select a1.department, a1.higest_tenure, a2.Emp_ID from
(select department, max(DATEDIFF(day,CURRENT_DATE,Hire_Date)) as higest_tenure from EE_information group by department) a1
left join
(select Emp_ID, department, DATEDIFF(day,CURRENT_DATE,Hire_Date) as tenure from EE_information) a2
on a1.department=a2.department, a1.higest_tenure=a2.tenure ;



--2.  Employee Benefit table contains an array of structure with Benefit code and deduction amount for each employee. DNT Dental Insurance deduction amount, HB Health Insurance Deduction Amount and FSA FSA deductiom amount. Write a SQL statement to calculate total amount of benefit deductions for each employee, e.g. John Doe’s total benefit deduction should be 200(50+150).
select name, Emp_ID,sum(cast(tmp1) as int) as total_benefit from
(select a.*, explode(split(regexp_replace(benefit,'[\"a-z:{}]',''),',')) as tmp1 from EE_Benefit as a) b
group by name, Emp_ID order by name, Emp_ID;
