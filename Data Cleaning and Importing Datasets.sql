-- Drop the database if it exists to start with a clean slate
DROP DATABASE IF EXISTS SQLCLEANINGDATA;

-- Create a new database
CREATE DATABASE SQLCLEANINGDATA;

-- Drop the table if it exists to refresh the schema
DROP TABLE IF EXISTS NYCRestaurantInspection;

-- Create a table for NYC Restaurant Inspections
CREATE TABLE NYCRestaurantInspection (
    CAMIS text,
    DBA varchar,
    BORO varchar,
    BUILDING varchar,
    STREET varchar,
    ZIPCODE text,
    PHONE text,
    CUISINE_DESCRIPTION varchar,
    INSPECTION_DATE date,
    ACTION varchar,
    VIOLATION_CODE varchar,
    VIOLATION_DESCRIPTION varchar,
    CRITICAL_FLAG varchar,
    SCORE real,
    GRADE varchar,
    GRADE_DATE date,
    RECORD_DATE date,
    INSPECTION_TYPE varchar,
    Latitude real,
    Longitude real,
    Community_Board real,
    Council_District real,
    Census_Tract real,
    BIN real,
    BBL real,
    NTA varchar
);

-- Copy data from CSV file to the NYCRestaurantInspection table
COPY NYCRestaurantInspection (
    CAMIS,
    DBA,
    BORO,
    BUILDING,
    STREET,
    ZIPCODE,
    PHONE,
    CUISINE_DESCRIPTION,
    INSPECTION_DATE,
    ACTION,
    VIOLATION_CODE,
    VIOLATION_DESCRIPTION,
    CRITICAL_FLAG,
    SCORE,
    GRADE,
    GRADE_DATE,
    RECORD_DATE,
    INSPECTION_TYPE,
    Latitude,
    Longitude,
    Community_Board,
    Council_District,
    Census_Tract,
    BIN,
    BBL,
    NTA
)
FROM 'D:\SQL\Data Sets\Data Cleaning Datasets\NYC_Restaurant_Inspection\NYC_Restaurant_Inspection_Results.csv'
DELIMITER ','
CSV HEADER;

-- Drop the table if it exists to refresh the schema
DROP TABLE IF EXISTS NYCParkingViolations;

-- Create a table for NYC Parking Violations
CREATE TABLE NYCParkingViolations(
    Summons_Number real,
    Plate_ID varchar (100),
    Registration_State varchar (100),
    Plate_Type varchar (100),
    Issue_Date date,
    Violation_Code varchar (100),
    Vehicle_Body_Type varchar (100),
    Vehicle_Make varchar (100),
    Issuing_Agency varchar (100),
    Street_Code1 varchar (100),
    Street_Code2 varchar (100),
    Street_Code3 varchar (100),
    Vehicle_Expiration_Date real,
    Violation_Location real,
    Violation_Precinct real,
    Issuer_Precinct real,
    Issuer_Code real,
    Issuer_Command varchar (100),
    Issuer_Squad real,
    Violation_Time varchar (100),
    Time_First_Observed varchar (100),
    Violation_County varchar (100),
    Violation_In_Front_of_or_Opposite varchar (100),
    House_Number varchar (100),
    Street_Name varchar (100),
    Intersecting_Street varchar (100),
    Date_First_Observed real,
    Law_Section varchar (100),
    Sub_Division varchar (100),
    Violation_Legal_Code varchar (100),
    Days_Parking_In_Effect varchar (100),
    From_Hours_In_Effect varchar (100),
    To_Hours_In_Effect varchar (100),
    Vehicle_Color varchar (100),
    Unregistered_Vehicle real,
    Vehicle_Year real,
    Meter_Number varchar (100),
    Feet_From_Curb real,
    Violation_Post_Code varchar (100),
    Violation_Description varchar (100),
    Num_Standing_or_Stopping_Violation varchar (100),
    Hydrant_Violation varchar (100),
    Double_Parking_Violation varchar (100)
);

-- Copy data from CSV file to the NYCParkingViolations table
COPY NYCParkingViolations (
    Summons_Number,
    Plate_ID,
    Registration_State,
    Plate_Type,
    Issue_Date,
    Violation_Code,
    Vehicle_Body_Type,
    Vehicle_Make,
    Issuing_Agency,
    Street_Code1,
    Street_Code2,
    Street_Code3,
    Vehicle_Expiration_Date,
    Violation_Location,
    Violation_Precinct,
    Issuer_Precinct,
    Issuer_Code,
    Issuer_Command,
    Issuer_Squad,
    Violation_Time,
    Time_First_Observed,
    Violation_County,
    Violation_In_Front_of_or_Opposite,
    House_Number,
    Street_Name,
    Intersecting_Street,
    Date_First_Observed,
    Law_Section,
    Sub_Division,
    Violation_Legal_Code,
    Days_Parking_In_Effect,
    From_Hours_In_Effect,
    To_Hours_In_Effect,
    Vehicle_Color,
    Unregistered_Vehicle,
    Vehicle_Year,
    Meter_Number,
    Feet_From_Curb,
    Violation_Post_Code,
    Violation_Description,
    Num_Standing_or_Stopping_Violation,
    Hydrant_Violation,
    Double_Parking_Violation
)
FROM 'D:\SQL\Data Sets\Data Cleaning Datasets\NYC_Parking_Violations\NYC_Parking_Violations_2020.csv'
DELIMITER ','
CSV HEADER;

-- Drop the table if it exists to refresh the schema
DROP TABLE IF EXISTS NYCFilmPermits;

-- Create a table for NYC Film Permits
CREATE TABLE NYCFilmPermits (
    EventID varchar (100),
    EventType varchar (100),
    StartDateTime timestamp,
    EndDateTime timestamp,
    EnteredOn timestamp,
    EventAgency varchar (100),
    ParkingHeld text,
    Borough varchar (100),
    CommunityBoardS varchar (100),
    PolicePrecincts varchar (100),
    Category varchar (100),
    SubCategoryName varchar (100),
    Country varchar (100),
    ZipCodes varchar (100)
);

-- Copy data from CSV file to the NYCFilmPermits table
COPY NYCFilmPermits (
    EventID,
    EventType,
    StartDateTime,
    EndDateTime,
    EnteredOn,
    EventAgency,
    ParkingHeld,
    Borough,
    CommunityBoards,
    PolicePrecincts,
    Category,
    SubCategoryName,
    Country,
    ZipCodes
)
FROM 'D:\SQL\Data Sets\Data Cleaning Datasets\NYC_Film_Permits\NYC_Film_Permits.csv'
DELIMITER ','
CSV HEADER;

-- Explore Parking Violations

-- Select all columns from the NYCParkingViolations table
SELECT *
FROM NYCParkingViolations;

-- Select the house_number column padded with zeros to the left
SELECT LPAD(house_number, 6, '0')
FROM NYCParkingViolations;

-- Select the house_number column padded with dashes to the right
SELECT RPAD(house_number, 6, '-')
FROM NYCParkingViolations;

-- Select counts of different values and handle nulls using COALESCE
SELECT COALESCE(vehicle_body_type, 'Unknown') AS Null_Fixed,
    COUNT(*) AS Null_Fixed_Count
FROM NYCParkingViolations
GROUP BY Null_Fixed
ORDER BY Null_Fixed_Count DESC;

-- Identify and display duplicate records based on certain columns
SELECT *
FROM (
    SELECT 
        summons_number,
        ROW_NUMBER() OVER (PARTITION BY plate_id, vehicle_body_type, vehicle_make, issue_date, violation_time) -1 AS duplicates,
        plate_id,
        vehicle_body_type,
        vehicle_make,
        issue_date,
        violation_time 
    FROM NYCParkingViolations
) AS sub
WHERE duplicates > 1;

-- Retrieve column information for the NYCParkingViolations table
SELECT column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'NYCParkingViolations'
    AND column_name = 'summons_number';

-- Convert a string to a date format
SELECT TO_DATE('09/07/2023', 'MM/DD/YYYY')
FROM NYCParkingViolations;

-- Count the occurrences of each vehicle make
SELECT vehicle_make,
    count(*)
FROM NYCParkingViolations
GROUP BY vehicle_make;

-- Count the occurrences of different plate types by registration state
SELECT 
    registration_state,
    COUNT(plate_type) FILTER (WHERE plate_type = '999') AS "plate_type 999",
    COUNT(plate_type) FILTER (WHERE plate_type = 'PAS') AS "plate_type PAS", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'PSD') AS "plate_type PSD",
    COUNT(plate_type) FILTER (WHERE plate_type = 'COM') AS "plate_type COM", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'NYS') AS "plate_type NYS", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'OMT') AS "plate_type OMT", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'SRF') AS "plate_type SRF", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'ORG') AS "plate_type ORG", 
    COUNT(plate_type) FILTER (WHERE plate_type = 'OMS') AS "plate_type OMS"
FROM NYCParkingViolations
GROUP BY registration_state;

-- Count the occurrences of violation codes by issuing agency
SELECT 
    violation_code, 
    issuing_agency, 
    COUNT(*) 
FROM NYCParkingViolations 
WHERE issuing_agency IN ('P', 'S', 'K', 'V') 
GROUP BY violation_code, issuing_agency
ORDER BY violation_code, issuing_agency;