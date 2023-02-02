
--Queries used for Tableau Project

--Data for Tableau Sheet 1 (table)

with totalCount
as(
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From SQL_Portfolio_Projects..CovidDeaths
where continent is not null
)
select *
from totalCount

--Data for Tableau Sheet 2 (Bar graph)
--'World', 'European Union', 'International' as these are not included in Query 1

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From SQL_Portfolio_Projects..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--Data for Tableau Sheet 3 (World map)

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From SQL_Portfolio_Projects..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

--Data for Tableau Sheet 4 (Forecasting)

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From SQL_Portfolio_Projects..CovidDeaths
--Where location like '%king%'
Group by Location, Population, date
order by PercentPopulationInfected desc