SELECT *
FROM PortfolioProject.dbo.Covid_Vaccines
ORDER BY 3,4

--JOIN THE TWO TABLES
SELECT *
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date

--TOTAL POPULATION VS VACCINATIONS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--SUM,PARTITION BY
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--CTE
With VacvsPop (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (RollingPeopleVaccinated/ Population)*100
FROM VacvsPop

--TEMP TABLE
DROP TABLE IF exists #temp_rolling
CREATE TABLE #temp_rolling
(Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations nvarchar(255),
RollingPeopleVaccinated numeric
)

INSERT INTO #temp_rolling
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/ Population)*100
FROM #temp_rolling


--Creating views to store data for later visualizations

Create View RollingPeopleVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.dbo.Covid_Deaths dea
JOIN PortfolioProject.dbo.Covid_Vaccines vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent is not null