-- RENAMING THE DATABASE
-- Switch to the master database
USE master;
GO

-- Set PortfolioProjectCovidDVCopy to single-user mode and roll back any active transactions
ALTER DATABASE PortfolioProjectCovidDVCopy SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Modify the name of PortfolioProjectCovidDVCopy to PortfolioProjectCovidDV
ALTER DATABASE PortfolioProjectCovidDVCopy MODIFY NAME = PortfolioProjectCovidDV;
GO

-- Set PortfolioProjectCovidDV back to multi-user mode
ALTER DATABASE PortfolioProjectCovidDV SET MULTI_USER;
GO

-- SELECTING DATA FROM TABLES
-- Select all records from the CovidDeaths table where the continent is not null, and order by columns 3 and 4
SELECT *
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 3, 4;

-- Select all records from the CovidVaccinations table and order by columns 3 and 4
SELECT *
FROM [PortfolioProjectCovidDV].[dbo].[CovidVaccinations]
ORDER BY 3, 4;

-- Select specific columns from the CovidDeaths table, cast data types, and filter by continent not null, and order by columns 1 and 2
SELECT 
	location, 
	date, 
	CAST(population AS int) population, 
	CAST(total_cases AS int) total_cases, 
	CAST(new_cases AS int) new_cases, 
	CAST(total_deaths AS int) total_deaths
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- CALCULATING DEATH PERCENTAGES
-- Calculate the percentage of deaths compared to total cases, rounding to three decimal places, for locations containing 'states'
SELECT 
	location, 
	date, 
	CAST(total_cases AS int) total_cases, 
	CAST(total_deaths AS int) total_deaths,
	ROUND((total_deaths/total_cases) * 100, 3) AS DeathPercent
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL AND location LIKE '%states%'
ORDER BY 1, 2;

-- Calculate the percentage of total cases compared to the population for locations containing 'states'
SELECT 
	location, 
	date, 
	CAST(population AS int) population, 
	CAST(total_cases AS int) total_cases,
	ROUND((total_cases/population) * 100, 3) PercentPopulationInfected
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL AND location LIKE '%states%'
ORDER BY 1, 2;

-- COMPARING COUNTRIES
-- Compare countries with the highest infection rate to the population and order by the highest percentage population infected
SELECT 
	location, 
	CAST(population AS int) population, 
	MAX(CAST(total_cases AS int)) AS TotalInfectionCount,
	ROUND(MAX((total_cases/population) * 100), 5) AS HighestPercentPopulationInfected
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL AND population IS NOT NULL
GROUP BY location, population 
ORDER BY HighestPercentPopulationInfected;

-- EXAMINING DATA WITH NULL CONTINENTS
-- Examine locations where reported continent is NULL, showing the total death count for each location
SELECT 
	location, 
	MAX(CAST(total_deaths AS integer)) AS TotalDeathCount
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Compare continents by the highest total death count
SELECT 
	continent, 
	MAX(CAST(total_deaths AS integer)) AS TotalDeathCount
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- GLOBAL STATISTICS
-- Calculate global statistics: total cases, total deaths, and percentage of deaths by date
SELECT 
	date, 
	SUM(CAST(new_cases AS int)) total_cases,
	SUM(CAST(new_deaths AS int)) total_deaths,
	(SUM(CAST(new_deaths AS int))/SUM(new_cases)) * 100 Percentage_deaths
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;

-- Calculate overall global statistics: total cases, total deaths, and percentage of deaths
SELECT  
	SUM(CAST(new_cases AS int)) total_cases,
	SUM(CAST(new_deaths AS int)) total_deaths,
	(SUM(CAST(new_deaths AS int))/SUM(new_cases)) * 100 Percentage_deaths
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths]
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- EXPLORING VACCINATIONS TABLE
-- Join data from the CovidDeaths and CovidVaccinations tables based on location and date
SELECT *
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths] dea
JOIN [PortfolioProjectCovidDV].[dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date;

-- Calculate total world population vs vaccination, adding daily vaccinations to the total vaccinations, and order the results
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date) AS RollingTotalVaccinations
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths] dea
JOIN [PortfolioProjectCovidDV].[dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

-- CALCULATING VACCINATION TO POPULATION RATIO
-- Calculate the ratio of total vaccinations to total population with a CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingTotalVaccinations)
AS (
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date) AS RollingTotalVaccinations
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths] dea
JOIN [PortfolioProjectCovidDV].[dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)

-- Calculate the vaccination to population ratio as a percentage
SELECT *, (RollingTotalVaccinations/population) * 100 AS VacsPopRatio
FROM PopvsVac;

-- CREATING A VIEW FOR DATA STORAGE
-- Create a view named VacsPopRatio to store data for visualization later
CREATE VIEW VacsPopRatio AS
SELECT 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location 
		ORDER BY dea.location, dea.date) AS RollingTotalVaccinations
FROM [PortfolioProjectCovidDV].[dbo].[CovidDeaths] dea
JOIN [PortfolioProjectCovidDV].[dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;