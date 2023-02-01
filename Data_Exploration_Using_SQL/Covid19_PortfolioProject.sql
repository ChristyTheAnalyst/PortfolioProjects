/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--Exploring COVID DEATH data/excel sheet

select *
from SQL_Portfolio_Projects..CovidDeaths
order by 3,4
-- 3,4 are the row indexes, arranges the data accordingly

--select *
--from SQL_Portfolio_Projects..CovidVaccinations
--order by 3,4

--Slecting only the rows required:

select location, date, total_cases, new_cases, total_deaths, population
from SQL_Portfolio_Projects..CovidDeaths
order by 1,2

--Total cases vs Total deaths:
--Displays likelihood of dying in each country on a particular date

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'DeathPercent %'
from SQL_Portfolio_Projects..CovidDeaths
order by 1,2

--Total cases vs Total deaths BY location:
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'DeathPercent %'
from SQL_Portfolio_Projects..CovidDeaths
where location like '%king%'
order by 1,2
--Death percentage was at its peak between the months April and July 2020 in United Kingdom

--Total cases vs population
--Shows what percentage of population got Covid
select location, date, total_cases, population, (total_cases/population)*100 as 'PopInfected %'
from SQL_Portfolio_Projects..CovidDeaths
where location like '%king%'
order by 1,2
--Around 6.5% of UK's population was tested positive with COVID-19 by the end of April 2021

--Finding the country with Highest infection rate compared to population
select location, population, max(total_cases) as Total_cases, max(total_cases/population)*100 as 'PopInfected %'
from SQL_Portfolio_Projects..CovidDeaths
group by location, population
order by 'PopInfected %' desc

--Sorting countries with highest death count
select location, max(cast(total_deaths as int)) as TotalDeathCount
from SQL_Portfolio_Projects..CovidDeaths
group by location
order by TotalDeathCount desc

--It is observed that the data contains few rows where the results  or observations
--of whole continent is grouped

--Getting rid of the data that belongs to the whole continent
select *
from SQL_Portfolio_Projects..CovidDeaths
where continent is not null
order by 3,4

--Sorting countries with highest death count AFTER removing the continent data
select location, max(cast(total_deaths as int)) as TotalDeathCount
from SQL_Portfolio_Projects..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Fetching highest death count by continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from SQL_Portfolio_Projects..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from SQL_Portfolio_Projects..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

--GLOBAL NUMBERS
select date, sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as 'Death %'
from SQL_Portfolio_Projects..CovidDeaths
where continent is not null
group by date
order by 1

select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as 'Death %'
from SQL_Portfolio_Projects..CovidDeaths
where continent is not null
order by 1

--Exploring COVID Vaccination data/excel sheet

select *
from SQL_Portfolio_Projects..CovidVaccinations

--Combining both the tables together based on location and date
select *
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date

--Displaying Total population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null
order by 2,3

--Displaying Rolling count of people vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null --and dea.location like '%states%'
order by 2,3

--Using CTE Common Table Expression to find Percentage of PeopleVaccinated vs population

with PopVac (Continent, Location, Date, Population, NewVaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null -- CTE cannot contain ORDER clause
)
select *, (RollingPeopleVaccinated/Population)*100 as '% PeopleVaccinated'
from PopVac
--where Location like '%states%'
order by 2,3

--Using Temp table to find RollingPeopleVaccinated vs population

Drop table if exists #PopulationVaccinatedPercent

create table #PopulationVaccinatedPercent(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population int,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into #PopulationVaccinatedPercent
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/Population)*100 as '% PeopleVaccinated'
from #PopulationVaccinatedPercent

--Creating VIEW to store data for later visualizations

-- DROP VIEW [PopulationVaccinated]

GO
Create View PopulationVaccinated as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from SQL_Portfolio_Projects..CovidDeaths dea
join SQL_Portfolio_Projects..CovidVaccinations vac
	on dea.location = vac.location and
	dea.date = vac.date
where dea.continent is not null
)
