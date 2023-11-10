-- SECTION ONE

-- Creating 'cities' table with columns: name, country_code, city_proper_pop, metroarea_pop, urbanarea_pop
CREATE TABLE cities (
  name                    VARCHAR   PRIMARY KEY,
  country_code            VARCHAR,
  city_proper_pop         REAL,
  metroarea_pop           REAL,
  urbanarea_pop           REAL
);

-- Creating 'countries' table with columns: code, name, continent, region, surface_area, indep_year, local_name, gov_form, capital, cap_long, cap_lat
CREATE TABLE countries (
  code                  VARCHAR     PRIMARY KEY,
  name                  VARCHAR,
  continent             VARCHAR,
  region                VARCHAR,
  surface_area          REAL,
  indep_year            INTEGER,
  local_name            VARCHAR,
  gov_form              VARCHAR,
  capital               VARCHAR,
  cap_long              REAL,
  cap_lat               REAL
);

-- Creating 'languages' table with columns: lang_id, code, name, percent, official
CREATE TABLE languages (
  lang_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR,
  name                  VARCHAR,
  percent               REAL,
  official              BOOLEAN
);

-- Creating 'economies' table with columns: econ_id, code, year, income_group, gdp_percapita, gross_savings, inflation_rate, total_investment, unemployment_rate, exports, imports
CREATE TABLE economies (
  econ_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR,
  year                  INTEGER,
  income_group          VARCHAR,
  gdp_percapita         REAL,
  gross_savings         REAL,
  inflation_rate        REAL,
  total_investment      REAL,
  unemployment_rate     REAL,
  exports               REAL,
  imports               REAL
);

-- Creating 'currencies' table with columns: curr_id, code, basic_unit, curr_code, frac_unit, frac_perbasic
CREATE TABLE currencies (
  curr_id               INTEGER     PRIMARY KEY,
  code                  VARCHAR,
  basic_unit            VARCHAR,
  curr_code             VARCHAR,
  frac_unit             VARCHAR,
  frac_perbasic         REAL
);

-- Creating 'populations' table with columns: pop_id, country_code, year, fertility_rate, life_expectancy, size
CREATE TABLE populations (
  pop_id                INTEGER     PRIMARY KEY,
  country_code          VARCHAR,
  year                  INTEGER,
  fertility_rate        REAL,
  life_expectancy       REAL,
  size                  REAL
);

-- Creating 'economies2015' table with columns: code, year, income_group, gross_savings
CREATE TABLE economies2015 (
  code                  VARCHAR     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR,
  gross_savings         REAL
);

-- Creating 'economies2019' table with columns: code, year, income_group, gross_savings
CREATE TABLE economies2019 (
  code                  VARCHAR     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR,
  gross_savings         REAL
);

-- Creating 'eu_countries' table with columns: code, name
CREATE TABLE eu_countries (
  code                  VARCHAR     PRIMARY KEY,
  name                  VARCHAR
);

-- Copying over data from CSVs
COPY cities FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/cddfccbc63c3f4174cb05983e1d702f950e0dfa7/cities.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY economies FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/ec5372f648d672e3ef15ae863ed8a5bb9debf727/economies.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY currencies FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/bfc4b7c18b703d6b51f48effaec10e59e874a3f8/currencies.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY countries FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/a466156a6b08d11a1ef12acdb30fb499d2149672/countries.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY languages FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/acb77dbca3b267ef18329621c6d5a9f4d426c210/languages.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY populations FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/437c3551604412096e5d655368c33eb161d7ec8c/populations.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY eu_countries FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/5cc5739b7d2e5079e86d1fe75be0de8a927f9041/eu_countries.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY economies2015 FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/ce0bb6334965e7c1ab5416a70a64ea27012167b2/economies2015.csv"' (DELIMITER ',', FORMAT CSV, HEADER);
COPY economies2019 FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/6053/datasets/7430c0d1f620c524530a9a15640a436e771fbd6d/economies2019.csv"' (DELIMITER ',', FORMAT CSV, HEADER);

-- Creating 'monarchs' table with columns: country, continent, monarch
DROP Table if Exists monarchs;

CREATE TABLE monarchs (
	country		VARCHAR		PRIMARY KEY,
	continent	VARCHAR,
	monarch		VARCHAR
);

-- Copying data from CSV into 'monarchs' table
COPY monarchs(country, continent, monarch)
FROM 'D:\SQL\Data Sets\Joining Data Datasets\leaders\monarchs.csv'
DELIMITER ','
CSV HEADER;

-- Creating 'presidents' table with columns: country, continent, president
DROP Table if Exists presidents;

CREATE TABLE presidents (
	country		VARCHAR		PRIMARY KEY,
  	continent	VARCHAR,
	president	VARCHAR
);

-- Copying data from CSV into 'presidents' table
COPY presidents(country, continent, president)
FROM 'D:\SQL\Data Sets\Joining Data Datasets\leaders\presidents.csv'
DELIMITER ','
CSV HEADER;

-- Creating 'prime_minister_terms' table with columns: prime_minister, pm_start
DROP Table if Exists prime_minister_terms;

CREATE TABLE prime_minister_terms (
	prime_minister	VARCHAR		PRIMARY KEY,
 	pm_start		REAL
);

-- Copying data from CSV into 'prime_minister_terms' table
COPY prime_minister_terms(prime_minister, pm_start)
FROM 'D:\SQL\Data Sets\Joining Data Datasets\leaders\prime_minister_terms.csv'
DELIMITER ','
CSV HEADER;

-- Creating 'prime_ministers' table with columns: country, continent, prime_minister
DROP Table if Exists prime_ministers;

CREATE TABLE prime_ministers (
	country			VARCHAR     PRIMARY KEY,
	continent		VARCHAR,
	prime_minister	VARCHAR
);

-- Copying data from CSV into 'prime_ministers' table
COPY prime_ministers(country, continent, prime_minister)
FROM 'D:\SQL\Data Sets\Joining Data Datasets\leaders\prime_ministers.csv'
DELIMITER ','
CSV HEADER;

-- Creating 'states' table with columns: country, continent, indep_year
DROP Table if Exists states;

CREATE TABLE states (
	country			VARCHAR		PRIMARY KEY,
	continent		VARCHAR,
	indep_year		REAL
);

-- Copying data from CSV into 'states' table
COPY states(country, continent, indep_year)
FROM 'D:\SQL\Data Sets\Joining Data Datasets\leaders\states.csv'
DELIMITER ','
CSV HEADER;

-- SECTION TWO

-- Retrieving data from 'prime_ministers' and 'presidents' tables using INNER JOIN on country
SELECT pm.country, pm.continent, pm.prime_minister, p.president
FROM prime_ministers AS pm
INNER JOIN presidents AS p
	ON pm.country = p.country;

-- Another way to retrieve data using INNER JOIN, this time using USING keyword
SELECT pm.country, pm.continent, pm.prime_minister, p.president
FROM prime_ministers AS pm
INNER JOIN presidents AS p
	USING(country);

-- Retrieving data from 'cities' and 'countries' tables using INNER JOIN on country_code
SELECT ci.name City, ct.name Country, ct.region Region
FROM cities ci
INNER JOIN countries ct
	ON ci.country_code = ct.code;
	
-- Retrieving specific columns from 'countries' and 'economies' tables using INNER JOIN with USING keyword
SELECT ct.code AS CountryCode, ct.name AS CountryName, e.year AS Year, 
	e.inflation_rate AS InflationRate
FROM countries ct
INNER JOIN economies e
	USING(code);

-- Retrieving specific columns from 'countries' and 'languages' tables using INNER JOIN with USING keyword
SELECT ct.code AS CountryCode, ct.name AS CountryName, l.name AS language, l.official
FROM countries ct
INNER JOIN languages l
	USING(code);

-- Retrieving data from multiple tables ('prime_ministers', 'presidents', and 'prime_minister_terms') using INNER JOIN on common columns
SELECT pm.country, pm.continent, pm.prime_minister, p.president, pmt.pm_start
FROM prime_ministers AS pm
INNER JOIN presidents AS p
	USING(country)
INNER JOIN prime_minister_terms AS pmt
	USING(prime_minister);

-- Retrieving specific columns from 'countries', 'populations', and 'economies' tables using INNER JOIN on common columns
SELECT ct.name AS CountryName, pop.year AS Year, 
		pop.fertility_rate, e.unemployment_rate
FROM countries ct
INNER JOIN populations pop
	ON ct.code = pop.country_code
INNER JOIN economies e
	ON ct.code = e.code
	AND pop.year = e.year;

-- Retrieving data from 'prime_ministers' and 'presidents' tables using LEFT JOIN on country
SELECT pm.country, prime_minister, president
FROM prime_ministers AS pm
LEFT JOIN presidents AS p
	USING(country);

-- Retrieving data from 'prime_ministers' and 'presidents' tables using RIGHT JOIN on country
SELECT p.country, prime_minister, president
FROM prime_ministers AS pm
RIGHT JOIN presidents AS p
	USING(country);

-- Retrieving data from 'cities' and 'countries' tables using LEFT JOIN on country_code, ordering by code in descending order
SELECT ci.name AS city, ct.name AS country, ct.code,
		ct.region, ci.city_proper_pop
FROM cities AS ci
LEFT JOIN countries AS ct
	ON ci.country_code = ct.code
	ORDER BY code DESC;

-- Retrieving data from 'cities' and 'countries' tables using RIGHT JOIN on country_code, ordering by code in descending order
SELECT ci.name AS city, ct.name AS country, ct.code,
		ct.region, ci.city_proper_pop
FROM cities AS ci
RIGHT JOIN countries AS ct
	ON ci.country_code = ct.code
	ORDER BY code DESC;

-- Calculating average GDP per capita for each region in 2010, limiting to top 10 regions
SELECT ct.region AS region, AVG(e.gdp_percapita) AS avg_gdp
FROM countries AS ct
LEFT JOIN economies AS e
	USING(code)
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp DESC
LIMIT 10;

-- Retrieving language information for countries 'PAK' and 'IND' from 'countries' and 'languages' tables
SELECT ct.name AS CountryName, l.name AS language
FROM countries ct
INNER JOIN languages l
	USING(code)
WHERE ct.code IN ('PAK', 'IND')
	AND L.code IN ('PAK', 'IND');

-- Retrieving language information for countries 'PAK' and 'IND' from 'countries' and 'languages' tables using CROSS JOIN
SELECT ct.name AS CountryName, l.name AS language
FROM countries ct
CROSS JOIN languages l
WHERE ct.code IN ('PAK', 'IND')
	AND L.code IN ('PAK', 'IND')
ORDER BY language;

-- Retrieving unique language names for countries in the Middle East region from 'languages' table
SELECT DISTINCT(name)
FROM languages
WHERE code IN (
	SELECT code 
	FROM countries
	WHERE region = 'Middle East')
ORDER BY name; -- This is a variant of the subquery in the 'WHERE' clause.

-- Retrieving country code and name from 'countries' table for Oceania continent, excluding countries with corresponding codes in 'currencies' table
SELECT code, name
FROM countries
WHERE continent LIKE 'Oceania'
	AND code NOT IN (
		SELECT code
		FROM currencies)
ORDER BY code;

-- Retrieving populations information for the year 2015 where life expectancy is more than 1.15 times the rounded average life expectancy for the year 2015
SELECT *
FROM populations
WHERE life_expectancy > 1.15 * (
	SELECT ROUND(AVG(life_expectancy))
	FROM populations
	WHERE year = 2015)
AND year = 2015;

-- Retrieving countries and the count of cities for each country, ordering by the count of cities in descending order and limiting to top 9
SELECT countries.name AS Country, (
		SELECT COUNT(*) 
		FROM cities
		WHERE countries.code = cities.country_code) AS cities_num
	FROM countries
	ORDER BY cities_num DESC, country
	LIMIT 9;

-- Retrieving local names of countries and the count of languages for each country, ordering by the count of languages in descending order
SELECT local_name
FROM countries, (
		SELECT code, COUNT(*) AS lang_num
		FROM languages
		GROUP BY code) AS sub
WHERE countries.code = sub.code
ORDER BY lang_num DESC;

-- Retrieving information from 'economies' table for the year 2015 excluding countries with government forms containing 'Republic' or 'Monarchy', ordered by inflation rate
SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015
	AND code NOT IN (
	SELECT code
	FROM countries
	WHERE gov_form LIKE '%Republic%' OR gov_form LIKE '%Monarchy%')
ORDER BY inflation_rate;

-- Retrieving city information from 'cities' table where the city is a capital in Europe or America, and metroarea_pop is not NULL, ordered by city percentage in descending order, and limiting to top 10
SELECT 
	name,
	country_code,
	city_proper_pop,
	metroarea_pop,
	city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities 
WHERE name IN (
	SELECT capital
	FROM countries
	WHERE continent LIKE '%Europe%' OR continent LIKE '%America%') 
		AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;