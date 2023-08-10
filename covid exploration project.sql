--SELECT*
--FROM dbo.CovidDeaths;

--SELECT*
--FROM dbo.CovidVaccinations;

----Data To Be Used

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM dbo.CovidDeaths
--ORDER BY 1,2;

     --1.
--Total Cases Vs Total Death
--Possibility Of Dieing If You Contact Covid In Nigeria

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM dbo.CovidDeaths
--WHERE location like '%Nigeria%'
--ORDER BY 1,2;


     --2.
--Total Cases Vs Population
--Percent Of Population That Contacted Covid In Nigeria

--SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfecteed
--FROM dbo.CovidDeaths
--WHERE location like '%Nigeria%'
--ORDER BY 1,2


       --3.
--Countries With Highest Infection Rate Compared To Population
 
--SELECT location, population,MAX (total_cases) AS HighestInfectionCount,MAX ((total_cases/population))*100 AS PercentPopulationInfecteed
--FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location,population
--ORDER BY PercentPopulationInfecteed DESC


     
	 --4.
--Countries With The Highest Death Count Per Population

--SELECT location, population,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
--FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location,population
--ORDER BY TotalDeathCount DESC


       --5.
--Continent With The Highest Death Count 

--SELECT continent,MAX(CAST(total_deaths AS INT)) AS TotalDeathCount
--FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC



       --6.
	--GLOBAL NUMBERS

--SELECT date, SUM (new_cases) AS Total_Cases,SUM(CAST( new_deaths AS int)) AS Total_Death,SUM(CAST (new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
--FROM dbo.CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY date
--ORDER BY 1,2;




       --7.
--Total Population Vs Vaccination

--USE CTE

WITH popVSvac (continent,location,date,population, new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100	
FROM  CovidDeaths DEA
JOIN CovidVaccinations VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER  BY 2,3;
)

SELECT*,(RollingPeopleVaccinated/population)*100
FROM popVSvac
 


 --TEMP TABLE
 DROP TABLE IF EXISTS #PercentPopulationVaccinated
 CREATE TABLE #PercentPopulationVaccinated
 (
 Continent nvarchar (255),
 Location nvarchar (255),
 Date datetime,
 Population numeric,
 New_vaccination numeric,
 RollingPeopleVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100	
FROM  CovidDeaths DEA
JOIN CovidVaccinations VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
--WHERE DEA.continent IS NOT NULL
--ORDER  BY 2,3;
 
SELECT*,(RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--CREATING VIEW TO STORE DATA FOR LATER VISUALZATIONS 
Create View PercentPopulationVaccinated AS 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast (vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100	
FROM  CovidDeaths DEA
JOIN CovidVaccinations VAC
    ON DEA.location = VAC.location
    AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER  BY 2,3;
 

