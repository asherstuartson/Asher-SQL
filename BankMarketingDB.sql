-- Create the Database using the statement below.
CREATE DATABASE BankMarketing;

-- Ensure the table to be created is not already in the database
-- and if it is, delete it to create a new table with the same features.
DROP TABLE IF EXISTS CustomerDetails;

-- Create the table using the CREATE function and the table name.
-- Specify all columns in the table and their data types.
CREATE TABLE CustomerDetails (
    Customer_Id int,
    Age int,
    AgeBracket varchar(100),
    Job varchar(100),
    MaritalStatus varchar(100),
    Education varchar(100),
    LoanDefault varchar(100),
    Balance int,
    Housing varchar(100),
    Loan varchar(100),
    ContactMode varchar(100),
    Day int,
    Month varchar(100),
    Duration int,
    Campaign int,
    PDays int,
    Previous int,
    POutcome varchar(100),
    Deposit varchar(100)
);

-- Populate the table created by using the COPY function from the Bank CSV file directory
COPY CustomerDetails (
    Customer_Id,
    Age,
    AgeBracket,
    Job,
    MaritalStatus,
    Education,
    LoanDefault,
    Balance,
    Housing,
    Loan,
    ContactMode,
    Day,
    Month,
    Duration,
    Campaign,
    PDays,
    Previous,
    POutcome,
    Deposit
)
FROM 'D:\SQL\Data Sets\My Projects\Easy\1. bank.csv'
DELIMITER ','
CSV HEADER;

-- Explore the data fields by physical inspection
SELECT *
FROM CustomerDetails;

-- Then respond to the following questions

-- 1) Which professions are the most popular among customers over 45 years old?
SELECT job, COUNT(*) AS MstPopJob
FROM CustomerDetails
WHERE age > 45
GROUP BY job
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 2) For how many people with loans did the marketing campaign succeed?
SELECT COUNT(*) AS num_of_people_with_loan
FROM CustomerDetails
WHERE loan = 'yes' AND poutcome = 'success';

-- 3) Does the success depend on the balance, deposit, or loan?
SELECT customer_id, balance, deposit, loan, poutcome
FROM CustomerDetails
WHERE loan = 'yes' AND poutcome = 'success'
GROUP BY customer_id, balance, deposit, loan, poutcome
ORDER BY customer_id;

-- 4) What is the average balance with respect to age bracket?
SELECT agebracket, ROUND(AVG(balance), 2) avgBal
FROM CustomerDetails
GROUP BY agebracket
ORDER BY avgBal DESC;

-- 5) Balance of different professionals.
SELECT job, ROUND(AVG(balance), 2) avgBal
FROM CustomerDetails
WHERE job NOT LIKE '%unk%'
GROUP BY job
ORDER BY avgBal DESC;

-- 6) What could be the most likely balance of a person with respect to education?
SELECT education, ROUND(AVG(balance), 2) avgBal
FROM CustomerDetails
WHERE education NOT LIKE '%un%'
GROUP BY education
ORDER BY avgBal DESC;

-- 7) The interval which has the most last contact duration?
SELECT MAX(duration)
FROM CustomerDetails;

-- 8) How many married people have a job?
SELECT COUNT(*)
FROM CustomerDetails
WHERE maritalstatus = 'married'
    AND job != 'unemployed';

-- 9) How many married people don't have a job?
SELECT COUNT(*)
FROM CustomerDetails
WHERE maritalstatus = 'married'
    AND job = 'unemployed';

-- 10) What is the job market many people are choosing?
SELECT job, COUNT(*)
FROM CustomerDetails
WHERE job != 'unknown'
GROUP BY job
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 11) Who have taken a loan comment on their bank balance?
SELECT customer_id, loan
FROM CustomerDetails
WHERE loan = 'yes';

-- 12) In which month the campaign is having a good response and comment on it using graphs?
SELECT month, COUNT(*)
FROM CustomerDetails
WHERE loan = 'yes'
GROUP BY month
ORDER BY COUNT(*) DESC;

-- 13) What is the most likely education qualification that is needed to get a job and married?
SELECT education, COUNT(*)
FROM CustomerDetails
WHERE education != 'unknown' AND job != 'unemployed'
    AND maritalstatus = 'married'
GROUP BY education;