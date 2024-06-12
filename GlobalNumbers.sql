--GROUP BY CONTINENT
SELECT continent
FROM PortfolioProject..Covid_Deaths
WHERE continent is not null
GROUP BY continent

--Showing continent with Highest Death count
SELECT continent,
	   MAX(cast(total_deaths as int)) AS HighestDeathCount
FROM PortfolioProject..Covid_Deaths
GROUP BY continent
ORDER BY  HighestDeathCount DESC

--GLOBAL NUMBERS
Select location,
	   SUM(cast(new_cases as int)) AS total_cases,
	   SUM(cast(new_deaths as int)) AS total_deaths,
	   SUM(cast(new_deaths as int))/ SUM(cast(new_cases as int))*100 AS DeathPercentage
FROM PortfolioProject.dbo.Covid_Deaths
WHERE location is not null
GROUP BY location
ORDER BY DeathPercentage

select location, date, total_cases, total_deaths, (CONVERT(DECIMAL(18,2), total_deaths) / CONVERT(DECIMAL(18,2), total_cases) )*100 as DeathPercent
from PortfolioProject..Covid_Deaths
order by 1,2

