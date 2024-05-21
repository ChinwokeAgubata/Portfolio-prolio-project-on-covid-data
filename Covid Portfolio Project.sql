

select *
from [Portfolio project]..Coviddeaths
order by 3,4

select *
from [Portfolio project].. Covidvaccinations
order by 3,4

--select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population_density
from [Portfolio project]..Coviddeaths
order by 1,2


 --Select *
 --from dbo.Coviddeaths

 --exec sp_help 'dbo.Coviddeaths'

 --Alter table Coviddeaths
 --alter column total_cases, total_deaths int 

 ----looking at total cases vs total deaths
 --shows the likelihood of dying if you contact covid in your country
select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [Portfolio project]..Coviddeaths
Where location like '%states%'
order by 1,2

--looking at total_cases vs Population_density

select location, date, total_cases, population_density, (total_cases/population_density)*100 as Deathpercentage
from [Portfolio project]..Coviddeaths
--Where location like '%states%'
order by 1,2 

--looking at countries with highest infection rate compared to population

select location, population_density, max(total_cases) as HighestInfectioncount, Max(total_cases/population_density)*100 as Percentpopulationinfected
From [Portfolio project]..Coviddeaths
--Where location like '%states%'
GROUP by location,population_density
order by Percentpopulationinfected desc

--showing countries with highest death count per population

select location, max(total_deaths) as TotaldeathCount
From [Portfolio project]..Coviddeaths
--Where location like '%states%'
where continent is not null
GROUP by location
order by TotaldeathCount desc

--Lets break things down by continent

select continent, max(total_deaths) as TotaldeathCount
From [Portfolio project]..Coviddeaths
--Where location like '%states%'
GROUP by continent
order by TotaldeathCount desc 

--Global Numbers 
select date, sum(cast(new_cases as int)) as total_cases, Sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(cast(nullif(new_cases,0) as int))*100 as Deathpercentage
From [Portfolio project]..Coviddeaths
--Where location like '%states%'
GROUP by date
order by 1,2


 Select *
 from dbo.Coviddeaths

 exec sp_help 'dbo.Coviddeaths'

 Alter table Coviddeaths
 alter column new_deaths, new_cases int 

 
 select *
 from [Portfolio project]..Covidvaccinations
 from [Portfolio project]..Covidvaccinations

select *
from [Portfolio project]..Coviddeaths dea
join [Portfolio project]..Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date

--Looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea. population_density, vac. new_vaccinations
from [Portfolio project]..Coviddeaths dea
join [Portfolio project]..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3

--to concert new_vaccinations nvarchar column  to int 

Select *
 from dbo.Covidvaccinations

 exec sp_help 'dbo.Covidvaccinations'

 Alter table Covidvaccinations
 alter column new_vaccinations int

--To calculate the sum of new_vaccinations by their location

--USE CTE
With popvsvac (location, date, population_density, new_vaccinations, vaccinationsum)
as
(
select dea.location, dea.date, dea.population_density, vac.new_vaccinations, 
sum(coalesce(vac. new_vaccinations,0)) as vaccinationsum
from [Portfolio project]..Coviddeaths dea
join [Portfolio project]..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
group by dea.location, dea.date, dea.population_density, vac.new_vaccinations
 )

 --TEMP TABLE 
 DROP TABLE if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 location varchar(50),
 date datetime,
 population_density int,
 new_vaccinations int,
 vaccinationsum int
 )
 insert into #PercentPopulationVaccinated
 select dea.location, dea.date, dea.population_density, vac.new_vaccinations, 
sum(coalesce(vac. new_vaccinations,0)) as vaccinationsum
from [Portfolio project]..Coviddeaths dea
join [Portfolio project]..Covidvaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
group by dea.location, dea.date, dea.population_density, vac.new_vaccinations

select*
from #PercentPopulationVaccinated
 
 select *, sum(vaccinationsum) over (partition by location order by date) as  rolling peoplevaccinated
 from #PercentPopulationVaccinated

 
  

















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































