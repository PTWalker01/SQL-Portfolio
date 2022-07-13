/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/



-- Starting Data for the Project

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_deaths
Where continent is not null 
order by 1,2



-- Total Cases Vs Total Deaths by location (United States)

SELECT location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Covid_deaths
where continent is not null
and location like '%states%'
order by 1,2



--Total cases vs Population

SELECT location, date, population, total_cases,  (total_cases/population)*100 as Infection_percentage
from Covid_deaths
where continent is not null
order by 1,2



--Countries with highest infection rate by Population

SELECT location, population, max(total_cases) as Highest_Infection_count,  max((total_cases/population))*100 as Population_Infection_percentage
from Covid_deaths
where continent is not null
group by population, location
order by Population_Infection_percentage desc



-- Countries with highest death count per Population

SELECT location, max(cast(total_deaths as int)) as Total_Deaths
from Covid_deaths
where continent is not null
group by location
order by Total_Deaths desc



-- Highest death count by continent

SELECT location, max(cast(total_deaths as int)) as Total_Deaths
from Covid_deaths
where continent is null
and location not in ('Upper middle income', 'High income', 'low income', 'lower middle income')
group by location
order by Total_Deaths desc



-- Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
From Covid_deaths
where continent is not null 
order by 1,2



-- Total Population compared to vaccinations 
 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(Convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccination_Count
from Covid_deaths as dea 
join Covid_Vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3



-- Using CTE to preform calculations
-- Rolling vaccination based on single doses of the vaccine 

with Pop_Vs_Vac (continent, Location, date, population,new_vaccinations, Rolling_Vaccination_Count)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(Convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccination_Count
from Covid_deaths as dea
join Covid_Vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (Rolling_Vaccination_Count/population)*100 as Rolling_vacination_by_population
from pop_vs_vac
--order by Rolling_vacination_by_population desc



-- Using Temp Table to preform calculations

drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_Vaccination_Count numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccination_Count
from Covid_deaths as dea
join Covid_Vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
select *, (Rolling_Vaccination_Count/population)*100 as Rolling_Vac_by_population
from #PercentPopulationVaccinated



-- Views for data visualizations

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccination_Count
from Covid_deaths as dea
join Covid_Vaccinations as vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null



create view Highest_infection_rates_by_country as
Select location, population, max(total_cases) as Highest_Infection_count,  max((total_cases/population))*100 as Population_Infection_percentage
from Covid_deaths
where continent is not null
group by population, location