--Select the data we are going to be using
Select location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject.dbo.Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total cases vs Total Deaths
Select location,
       date,
	   total_cases,
	   total_deaths,
	   (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS DeathPercentage
FROM PortfolioProject.dbo.Covid_Deaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid
Select location,
       date,
	   population,
	   total_cases,
	   (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, population), 0))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.Covid_Deaths
WHERE location like '%states%'
ORDER BY 1,2

--Looking at countries with Highest infection rate compared to population
Select location,
	   population,
	   MAX(total_cases) AS HighestInfectionCount,
	   MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.Covid_Deaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC

--Showing Countries with Highest Death Count
SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..Covid_Deaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount