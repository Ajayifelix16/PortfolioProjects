---1
---showing the world population of total new cases,new death and the Deathpercentages


Select sum(new_cases) as TotalNewCases, sum(new_deaths) as TotalNewDeath, sum(new_deaths)/(sum(new_cases))*100 as DeathPercentage
from CovidDeaths
--where location like '%states%'
where continent is not null
--group by date, total_cases
order by 1,2


---2
--Looking at the Location and their New total death count

Select Location, sum(cast(new_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is null
and location not in ('world', 'european union', 'international', 'High income', 'upper middle income', 'Lower middle income', 'Low income')
group by location
order by TotalDeathCount desc

---3
----Looking at countries with highest infection rate compared to population

Select Location, population, max(total_cases) as HighestInfect, (CONVERT(float, max(total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PecentagePopulationInfected
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location,population
order by PecentagePopulationInfected desc


--4

--Looking at countries with highest infection rate compared to population

Select Location, population, date, max(total_cases) as HighestInfect, (CONVERT(float, max(total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PecentagePopulationInfected
from CovidDeaths
--where location like '%states%'
--where population is not null
group by location,population, date
order by PecentagePopulationInfected desc