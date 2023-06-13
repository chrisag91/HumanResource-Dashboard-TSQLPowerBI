--Created a new Database and Table and began cleaning data--

CREATE DATABASE Projects;
GO


SELECT *
FROM Projects.dbo.HumanResource

--Added age column--


ALTER TABLE Projects.dbo.HumanResource
ADD age AS DATEDIFF
(YEAR, birthdate, GETDATE());


--Renaming of Column and Data Type change--

EXEC sp_rename 'dbo.HumanResource.id', 
			   'Emp_ID', 
			   'COLUMN';

ALTER TABLE Projects.dbo.HumanResource
ALTER COLUMN Emp_ID VARCHAR (20) NULL;

--Checking to make sure all values are correct--

SELECT MIN(age) AS youngest
	  ,MAX(age) AS oldest
FROM Projects.dbo.HumanResource


SELECT COUNT(*)
FROM Projects.dbo.HumanResource
WHERE age < 18;



--What is the gender breakdown of employees in the company?--

SELECT gender
	 ,COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender;


--What is the race/ethnicity breakdown of employees in the company?--

SELECT race
	 ,COUNT(*) AS count
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY COUNT (*) DESC;


--What is the age distribution of employees in the company?--

SELECT MIN(age) AS youngest
	  ,MAX(age) AS oldest
FROM Projects.dbo.HumanResource



--By age--

SELECT CASE
WHEN age >= 18 AND age <= 24 THEN '18-24'
WHEN age >= 25 AND age <= 34 THEN '25-34'
WHEN age >= 35 AND age <= 44 THEN '35-44'
WHEN age >= 45 AND age <= 54 THEN '45-54'
WHEN age >= 55 AND age <= 64 THEN '55-64'
ELSE '65+'
END AS age_group,
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY CASE
WHEN age >= 18 AND age <= 24 THEN '18-24'
WHEN age >= 25 AND age <= 34 THEN '25-34'
WHEN age >= 35 AND age <= 44 THEN '35-44'
WHEN age >= 45 AND age <= 54 THEN '45-54'
WHEN age >= 55 AND age <= 64 THEN '55-64'
ELSE '65+'
END
ORDER BY age_group;

--Gender Included--

SELECT CASE
WHEN age >= 18 AND age <= 24 THEN '18-24'
WHEN age >= 25 AND age <= 34 THEN '25-34'
WHEN age >= 35 AND age <= 44 THEN '35-44'
WHEN age >= 45 AND age <= 54 THEN '45-54'
WHEN age >= 55 AND age <= 64 THEN '55-64'
ELSE '65+'
END AS age_group, gender,
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY gender,
CASE
WHEN age >= 18 AND age <= 24 THEN '18-24'
WHEN age >= 25 AND age <= 34 THEN '25-34'
WHEN age >= 35 AND age <= 44 THEN '35-44'
WHEN age >= 45 AND age <= 54 THEN '45-54'
WHEN age >= 55 AND age <= 64 THEN '55-64'
ELSE '65+'
END
ORDER BY age_group;


--How many employees work at headquarters VS remote locations?--

SELECT [location],
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY [location];

--What is the average length of employment for employees who've been terminated?--

SELECT AVG(DATEDIFF(YEAR, (hire_date), (termdate))) AS avg_length_emp
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NOT NULL AND termdate <= '2023-06-13'


--How does the gender distribution vary across departments and job titles?--

SELECT department,
	   gender,
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NULL
GROUP BY department
		,gender
ORDER BY department;

--What is the distribution of job titles across the company?--

SELECT jobtitle,
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
GROUP BY jobtitle
ORDER BY jobtitle DESC;

--Which department has the highest turnover rate?--

SELECT department
	  ,total_count
	  ,terminated_count
	  ,CAST(terminated_count AS DECIMAL (7,2))/total_count AS termination_rate
FROM (
SELECT department,
COUNT(*) AS total_count,
SUM(CASE WHEN termdate IS NOT NULL AND termdate <= '2023-06-13'
		 THEN 1 ELSE 0 END) AS terminated_count
FROM Projects.dbo.HumanResource
WHERE age >= 18
GROUP BY department) AS subquery
ORDER BY termination_rate DESC

--What is the distribution of employees across locaitons by city and state?--

SELECT location_state,
COUNT(*) AS [count]
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NOT NULL AND termdate <= '2023-06-13'
GROUP BY location_state
ORDER BY [count] DESC;


--How has the company's employee count changed over time based on hire and term dates?--

SELECT YEAR
	  ,hires
	  ,terminations
	  ,hires - terminations AS net_change
	  ,CAST(hires - terminations AS DECIMAL (7,2)) / hires*100 AS net_change_percent
FROM(
	SELECT YEAR(hire_date) AS YEAR
		  ,COUNT(*) AS hires
		  ,SUM(CASE WHEN termdate IS NOT NULL AND termdate <= '2023-06-13'
		  THEN 1 ELSE 0 END) AS terminations
FROM Projects.dbo.HumanResource
WHERE age >=18
GROUP BY YEAR(hire_date)) AS subquery
ORDER BY YEAR ASC;


--What is the tenure distribution for each department?--

SELECT department,
AVG(DATEDIFF(YEAR, (hire_date), (termdate))) AS avg_tenure
FROM Projects.dbo.HumanResource
WHERE age >= 18 AND termdate IS NOT NULL AND termdate <= '2023-06-13'
GROUP BY department;
	


