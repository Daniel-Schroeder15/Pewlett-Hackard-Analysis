queries.sql


SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;


SELECT * FROM retirement_info;

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- To recreate retirement_info. first DROP TABLE. Recreate to
-- add emp_no into the table.
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name
     , dept_manager.emp_no
     , dept_manager.from_date
     , dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;
-- this did not include start and end dates to see the people who have already left the company

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no
	, retirement_info.first_name
	, retirement_info.last_name
	, dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--An alias in SQL allows developers to give nicknames to tables.
--This helps improve code readability by shortening longer names into one-, two-, or three-letter temporary names. 
--This is commonly used in joins because multiple tables and columns are often listed.
-- Joining retirement_info and dept_emp tables USING ALIAS
SELECT ri.emp_no
	, ri.first_name
	, ri.last_name
	, dept_emp.to_date
FROM retirement_info as ri 
LEFT JOIN dept_emp
ON ri.emp_no = dept_emp.emp_no;

-- alias practice
-- Joining departments and dept_manager tables
SELECT dep.dept_name
     , dm.emp_no
     , dm.from_date
     , dm.to_date
FROM departments as dep
INNER JOIN dept_manager as dm
ON dep.dept_no = dm.dept_no;

SELECT ri.emp_no
	, ri.first_name
	, ri.last_name
	, de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
-- current employees only 

-- create a csv file for current_emp by export

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
into current_emp_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


SELECT * FROM salaries
ORDER BY to_date DESC;

ALTER TABLE employees RENAME COLUMN "genger" TO "gender";


SELECT e.emp_no
	, e.first_name
	, e.last_name
	, e.gender
	, s.salary
	, de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
	ON (dm.dept_no = d.dept_no)
INNER JOIN current_emp AS ce
	ON (dm.emp_no = ce.emp_no);

-- department retirees
SELECT ce.emp_no
	, ce.first_name
	, ce.last_name
	, d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de 
	on (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);

-- Retiring INFO FOR SALES TEAM 
SELECT dep.emp_no
	, dep.first_name
	, dep.last_name
	, dep.dept_name
FROM dept_info as dep
WHERE dep.dept_name as 'Sales'

-- Retiring INFO FOR SALES and DEVELOPMENT TEAM 
SELECT dep.emp_no
	, dep.first_name
	, dep.last_name
	, dep.dept_name
FROM dept_info as dep
WHERE dep.dept_name IN ('Sales', 'Development')

-- first cahllenge table
SELECT e.emp_no
	, e.first_name
	, e.last_name
	, ti.title
	, ti.from_date
	, sa.salary
INTO retiring_by_title
FROM employees as e
INNER JOIN titles as ti
on (e.emp_no = ti.emp_no)
INNER JOIN salaries as sa
on (e.emp_no = sa.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- gets the most recent job title
-- temporary table to run count
-- table of employees close to retirment with most recent job title. 
SELECT * 
INTO temp_table
FROM
	(SELECT *, ROW_NUMBER(*) OVER (PARTITION BY emp_no ORDER BY from_date DESC) AS rn
FROM retiring_by_title) tmp
WHERE tmp.rn = 1
ORDER BY emp_no
	 
-- NUMBER OF TITLES RETIRING
SELECT COUNT(tt.emp_no), tt.title
INTO retirement_title_count
FROM temp_table as tt
GROUP BY tt.title
ORDER BY tt.title

-- eligible CURRENT employees for mentorship
SELECT e.emp_no
	, e.first_name
	, e.last_name
	, ti.title
	, de.from_date
	, de.to_date
INTO duplicate_eligible_list
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN  '1965-01-01' AND '1965-12-31')
AND de.to_date = ('9999-01-01')

-- take out duplicates
SELECT * 
INTO eligible_list
FROM
	(SELECT *, ROW_NUMBER(*) OVER (PARTITION BY emp_no ORDER BY from_date DESC) AS rn
FROM duplicate_eligible_list) tmp
WHERE tmp.rn = 1
