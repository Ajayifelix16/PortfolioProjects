select *
from CovidDeaths
where continent is not null
order by 3,4

--select *
--from CovidVaccinations
--order by 3,4

---select the data we need

select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

---Looking into total cases vs total deaths in percentages
---Shows the liklihood of dieing if contacted in your state


Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
from CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2 desc

---Looking at total cases vs population
---shows what percent of population got covid

Select Location, date, population, total_cases, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0))*100 as PopulationInfected
from CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location, population, max(total_cases) as HighestInfect, (CONVERT(float, max(total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PecentagePopulationInfected
from CovidDeaths
--where location like '%states%'
where population is not null
group by location,population
order by 1,2 desc

Select Location, population, max(total_cases) as HighestInfect, (CONVERT(float, max(total_cases)) / NULLIF(CONVERT(float, population), 0))*100 as PecentagePopulationInfected
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location,population
order by 1,2 desc


---showing countries with the highest death count per populataion

Select Location, population, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null
group by location,population
order by TotalDeathCount desc

---showing countries with the percentage of highest death count per populataion

Select Location, population, max(cast(total_deaths as int)) as TotalDeathCount, (max(cast(total_deaths as int)) / (population))*100 as PecentageHighestDeath
from CovidDeaths
--where location like '%states%'
--where continent is not null
where population is not null
group by location,population
order by PecentageHighestDeath desc

---Breaking down by continent

Select continent, max(cast(total_deaths as int)) as MaxDeathCount
from CovidDeaths
where continent is not null
Group by continent
order by MaxDeathCount desc

Select continent,location, max(cast(total_deaths as int)) as MaxDeathCount
from CovidDeaths
where continent is not null
Group by continent,location
order by MaxDeathCount desc

Select continent, sum(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

Select continent,location, sum(cast(total_deaths as int)) as MaxDeathCount
from CovidDeaths
where continent is not null
Group by continent,location
order by MaxDeathCount desc

---showing the continent with the highest death count

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

---Global numbers

--sum of new cases to new deaths

Select date, sum(new_cases) as SumNewCases, sum(new_deaths) as SumNewDeaths, total_deaths
from CovidDeaths
--where location like '%states%'
where continent is not null
group by date, total_deaths
order by 1,2 desc

--percentage sum of new cases to new deaths

--Select date, sum(new_cases), sum(new_deaths), (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
--from CovidDeaths
--where location like '%states%'
--where continent is not null
--group by date, new_cases
--order by DeathPercentage

---showing the world population of total new cases,new death and the percentages

Select sum(new_cases) as TotalNewCases, sum(new_deaths) as TotalNewDeath, sum(new_deaths)/(sum(new_cases))*100 as NewDeathPercentage
from CovidDeaths
--where location like '%states%'
where continent is not null
--group by date, total_cases
order by 1,2


---Exploring the covidvacination table

select *
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date

---Looking at total population vs Vaccination

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations 
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3

---Looking at sum of new vaccinaton per location

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
SUM(convert(float,CovidVaccinations.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccination
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3

---Percentage of the sum of people newly vaccinated over thir location,date to the population

select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
SUM(convert(float,CovidVaccinations.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3


--Using a CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccination)
as
(
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
SUM(convert(float,CovidVaccinations.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccination/population)*100
from PopvsVac

---Using a TempTable

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccination numeric
)



insert into #PercentPopulationVaccinated
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
SUM(convert(float,CovidVaccinations.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
--where CovidDeaths.continent is not null
--order by 2,3

select *, (RollingPeopleVaccination/population)*100
from #PercentPopulationVaccinated


---Creating view to store data for later visualiation

create view PercentPopulationVaccinated as
select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations, 
SUM(convert(float,CovidVaccinations.new_vaccinations)) over (partition by CovidDeaths.location order by CovidDeaths.location, CovidDeaths.date) as RollingPeopleVaccination
--, (RollingPeopleVaccination/population)*100
from CovidDeaths
join CovidVaccinations
	on CovidDeaths.location=CovidVaccinations.location
	and CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
---order by 2,3


select *
from PercentPopulationVaccinated

---many other tables can be created so as to create the view

---Next we Visualize

