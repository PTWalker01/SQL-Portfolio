/*
Queries used for Tableau Covid Project
*/



-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_Deaths
where continent is not null 
order by 1,2


-- 2. 

-- Some items are taken out to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Covid_Deaths
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Deaths
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Deaths
Group by Location, Population, date
order by PercentPopulationInfected desc

/*

Citations

Hannah Ritchie, Edouard Mathieu, Lucas Rodés-Guirao, Cameron Appel, Charlie Giattino, Esteban Ortiz-Ospina, 
Joe Hasell, Bobbie Macdonald, Diana Beltekian and Max Roser (2020) - "Coronavirus Pandemic (COVID-19)". 
Published online at OurWorldInData.org. Retrieved Jully 2022, from: 'https://ourworldindata.org/coronavirus' [Online Resource]

Alex Freberg, https://github.com/AlexTheAnalyst

*/