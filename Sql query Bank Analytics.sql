create database bank_loan;
use bank_loan;


CREATE TABLE Finance_1 (
  id varchar(20) primary key ,
  member_id varchar(20),
  loan_amnt float,
  funded_amnt float,
  funded_amnt_inv float,
  term varchar(20),
  int_rate varchar(50),
  installment float,
  grade varchar(5),
  sub_grade varchar(2),
  emp_title varchar(255),
  emp_length varchar(20),
  home_ownership varchar(20),
  annual_inc float,
  verification_status varchar(20),
  issue_d varchar(50),
  loan_status varchar(20),
  pymnt_plan varchar(5),
  description text,
  purpose varchar(50),
  title varchar(100),
  zip_code varchar(10),
  addr_state varchar(10),
  dti float
);

select * from finance_1;

show variables like "secure_file_priv"; 
 set session sql_mode='';
 
 LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Finance_1.csv'
INTO TABLE finance_1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

#############################################################################


CREATE TABLE finance_2 (
  id varchar(20),
  delinq_2yrs float,
  earliest_cr_line varchar(20),
  inq_last_6mths int,
  mths_since_last_delinq varchar(20),
  mths_since_last_record varchar(20),
  open_acc int,
  pub_rec int,
  revol_bal float,
  revol_util varchar(20),
  total_acc int,
  initial_list_status VARCHAR(5),
  out_prncp float,
  out_prncp_inv float,
  total_pymnt float,
  total_pymnt_inv float,
  total_rec_prncp float,
  total_rec_int float,
  total_rec_late_fee float,
  recoveries float,
  collection_recovery_fee float,
  last_pymnt_d varchar(10),
  last_pymnt_amnt float,
  next_pymnt_d varchar(20),
  last_credit_pull_d varchar(20)
);

select * from finance_2;
describe finance_2;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

#############################################################################################################
# Upadated issue_d column in finance_1 table in corrct date format
select issue_d from finance_1 where issue_d = '';   #-- Select the issue_d values from finance_1 where issue_d is an empty string

alter table  finance_1 add  column temp_col date null ;  #-- Add a new column named temp_col of type DATE allowing null values to finance_1 table

SET SQL_SAFE_UPDATES = 0;

update finance_1 set `issue_d` = null where `issue_d`= ''; #-- Update the issue_d column with NULL values where issue_d is an empty string


update finance_1
set `temp_col` = str_to_date(concat("01-", `issue_d` ), '%d-%b-%y')
where `issue_d`  is not null;                                            #-- Update the temp_col column by converting issue_d values to dates with a format of 'dd-Mon-yy'

select 	`temp_col` from finance_1;    #-- Retrieve the temp_col values from finance_1

select 	 year(`temp_col`) from finance_1;  #-- Extract the year from the temp_col column in finance_1

select 	 year(`issue_d`) from finance_1;     #-- Attempt to extract the year from the non-existing issue_d column (Note: This will likely result in an error)

alter table finance_1 drop column `issue_d`;  #-- Remove the issue_d column from finance_1 table

alter table finance_1 change column `temp_col`  `issue_d` date;   #-- Rename the temp_col column to issue_d and change its data type to DATE

describe finance_1;  #-- Display the structure of the finance_1 table

# Upadated last_pymnt_d column in finance_2 table in corrct date format

select * from finance_2;

select last_pymnt_d from finance_2 where last_pymnt_d = '';

alter table  finance_2 add  column temp_col date null ;
update finance_2 set `last_pymnt_d` = null where last_pymnt_d = '';

update finance_2
set `temp_col` = str_to_date(concat("01-", `last_pymnt_d` ), '%d-%b-%y')
where `last_pymnt_d`  is not null;

select  year (str_to_date(concat("01-", `next_pymnt_d`), '%d-%b-%y')) from finance_2 where `next_pymnt_d` <> '';

select 	`temp_col` from finance_2;

select 	 year(`temp_col`) from finance_2;

select 	 year(`last_pymnt_d`) from finance_2;

alter table finance_2 drop column `last_pymnt_d`; 

alter table finance_2 change column `temp_col`  `last_pymnt_d` date;

describe finance_2;

# Upadated Last_Credit_Pull_Date column in finance_2 table in corrct date format

select last_credit_pull_d from finance_2 where last_credit_pull_d = char(13);

alter table  finance_2 add  column temp_col date null ;
update finance_2 set `last_credit_pull_d` = null where last_credit_pull_d =char(13) ;

update finance_2
set `temp_col` = str_to_date(concat("01-", `last_credit_pull_d` ), '%d-%b-%y')
where `last_credit_pull_d`  is not null;

select 	`temp_col` from finance_2;

select 	 year(`temp_col`) from finance_2;

select 	 year(`last_credit_pull_d`) from finance_2;

alter table finance_2 drop column `last_credit_pull_d`; 

alter table finance_2 change column `temp_col`  `last_credit_pull_d` date;

describe finance_2;

# Upadated earliest_cr_line column in finance_2 table in corrct date format

select * from finance_2;

select earliest_cr_line from finance_2 where earliest_cr_line = '';

alter table  finance_2 add  column temp_col date null ;

SET SQL_SAFE_UPDATES = 0;

update finance_2 set `earliest_cr_line` = null where earliest_cr_line = '';

update finance_2
set `temp_col` = str_to_date(concat("01-", `earliest_cr_line` ), '%d-%b-%y')
where `earliest_cr_line`  is not null;


select 	`temp_col` from finance_2;

select 	 year(`temp_col`) from finance_2;

select 	 year(`earliest_cr_line`) from finance_2;

alter table finance_2 drop column `earliest_cr_line`; 

alter table finance_2 change column `temp_col`  `earliest_cr_line` date;

describe finance_2;
####################################################################################

# (KPI-1) - Year wise loan amount Stats

SELECT YEAR(issue_d) AS year,
       CONCAT(ROUND(SUM(loan_amnt) / 1000000, 2), ' M') AS total_loan_amount
FROM Finance_1
GROUP BY YEAR(issue_d)
ORDER BY YEAR(issue_d);


###############################################################################################################

# (KPI-2) - Grade and sub grade wise revol_bal

SELECT grade, sub_grade, CONCAT(ROUND(SUM(revol_bal) / 1000000, 2), ' M') AS Total_revol_bal
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id
GROUP BY grade, sub_grade
ORDER BY grade;

##################################################################################################################

# (KPI-3) -Total Payment for Verified Status Vs Total Payment for Non Verified Status

SELECT
  verification_status,
  CONCAT(ROUND(SUM(total_pymnt) / 1000000, 2), ' M') AS Total_payment
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id
WHERE verification_status IN ('Verified', 'Not Verified')
GROUP BY verification_status;


##################################################################################################################

# (KPI-4) -State wise and last_credit_pull_d wise loan status

SELECT
  addr_state AS State,
  last_credit_pull_d AS Last_Credit_Pull_Date,
  loan_status AS Loan_Status,
  COUNT(loan_status) AS Loan_Status_Count
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id
GROUP BY State, Last_Credit_Pull_Date, Loan_Status
ORDER BY State, Last_Credit_Pull_Date;



SELECT
  State,
  Loan_Status,
  Last_Credit_Pull_Date,
  CONCAT(FORMAT(SUM(Loan_Amount) / 1000000, 2), ' M') AS Sum_of_loan_amnt
FROM (
  SELECT
    addr_state AS State,
    loan_status AS Loan_Status,
    last_credit_pull_d AS Last_Credit_Pull_Date,
    SUM(loan_amnt) AS Loan_Amount
  FROM finance_1
  INNER JOIN finance_2 ON finance_1.id = finance_2.id
  WHERE last_credit_pull_d = '2016-05-01'
  GROUP BY addr_state, loan_status, last_credit_pull_d
) AS subquery
GROUP BY State, Loan_Status, Last_Credit_Pull_Date
ORDER BY State, Loan_Status;

																																		
##################################################################################################################

# (KPI-5) -Home ownership Vs last payment date stats

SELECT
  home_ownership,
  MAX(last_pymnt_d) AS Max_Last_Payment_Date,
  COUNT(last_pymnt_d) AS Last_Payment_Count
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id
GROUP BY home_ownership, DATE_FORMAT(STR_TO_DATE(last_pymnt_d, '%b-%y'), '%Y')
ORDER BY Last_Payment_Count DESC ;


SELECT
  f1.home_ownership,
  MAX(f2.last_pymnt_d) AS Max_Last_Payment_Date,
  CONCAT(SUM(f1.loan_amnt) / 1000, ' K') AS Sum_Loan_Amount
FROM finance_1 AS f1
INNER JOIN finance_2 AS f2 ON f1.id = f2.id
GROUP BY f1.home_ownership, DATE_FORMAT(STR_TO_DATE(f2.last_pymnt_d, '%b-%y'), '%Y')
ORDER BY f1.home_ownership;

##################################################################################################################

# (KPI-6 ) - Toatl Payment,Total Loan Amount ,Total Customers and Average Intrest Rate

# Total customers

SELECT CONCAT(ROUND(COUNT(DISTINCT id) / 1000, 2), ' K') AS Total_Customers_K
FROM finance_1;

# Total Payment 

SELECT CONCAT(ROUND(SUM(total_pymnt) / 1000000, 2), ' M') AS Total_Payment
FROM finance_1
INNER JOIN finance_2 ON finance_1.id = finance_2.id;


# Total Loan Amount

SELECT CONCAT(ROUND(SUM(loan_amnt) / 1000000, 2), ' M') AS Total_Loan_Amount
FROM finance_1;



# Average Intrest Rate

SELECT FORMAT(AVG(CAST(REPLACE(int_rate, '%', '') AS DECIMAL(5, 2))) / 100, 2) AS Average_Interest_Rate
FROM Finance_1;


