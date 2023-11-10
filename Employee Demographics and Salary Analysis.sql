-- Query 1: Explore the gender distribution organization-wide
SELECT
	gender,
	COUNT(*) AS employee_count,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS proportion
FROM employees
GROUP BY gender;

-- Query 2: Investigate gender distribution in each department
SELECT
	dept_name,
	gender,
	COUNT(*) AS employee_count,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS proportion
FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no
INNER JOIN dept_emp ON dept_emp.emp_no = salaries.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_name, gender 
ORDER BY dept_name, proportion DESC;

-- Query 3: Analyze gender distribution by department
SELECT
	dept_name,
	gender,
	COUNT(*) AS employee_count,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY dept_name), 4) AS proportion
FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no
INNER JOIN dept_emp ON dept_emp.emp_no = salaries.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
GROUP BY dept_name, gender 
ORDER BY dept_name, proportion DESC;

-- Query 4: Explore job title distribution
SELECT
	DISTINCT title,
	COUNT(*) AS employee_count,
	ROUND(COUNT(*) / SUM(COUNT(*)) OVER (), 4) AS proportion
FROM titles
GROUP BY title
ORDER BY proportion;

-- Query 5: Identify employees hired in the year 2000
SELECT
	emp_no,
	first_name,
	last_name,
	EXTRACT('year' FROM hire_date) AS hire_year
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 2000
ORDER BY first_name;

-- Query 6: Obtain average salary values by gender and department
SELECT
	dept_name,
	gender,
	ROUND(AVG(salary), 2) AS avg_sal
FROM employees
INNER JOIN salaries ON employees.emp_no = salaries.emp_no
INNER JOIN dept_emp ON dept_emp.emp_no = salaries.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
GROUP BY gender, dept_name
ORDER BY dept_name;

-- Query 7: Explore gender and department of employees with salaries over 150,000
SELECT
	subquery.emp_no,
	gender,
	dept_name,
	salary
FROM (
	SELECT *
	FROM salaries
	WHERE salary > 150000
) AS subquery
INNER JOIN employees ON subquery.emp_no = employees.emp_no
INNER JOIN dept_emp ON dept_emp.emp_no = subquery.emp_no
INNER JOIN departments ON departments.dept_no = dept_emp.dept_no
ORDER BY salary DESC;

-- Query 8: Retrieve employee salary details for those hired in 2000
SELECT
	emp_no,
	salary,
	EXTRACT('year' FROM from_date) AS hire_year
FROM salaries
WHERE EXTRACT('year' FROM from_date) IN
	(SELECT EXTRACT('year' FROM hire_date) AS hire_year
	FROM employees
	WHERE EXTRACT('year' FROM hire_date) = 2000)
ORDER BY EXTRACT('year' FROM from_date);
