SELECT location,date, total_deaths, new_cases total_cases, population
FROM covid_deaths
order by 1,2;

-- Looking at Total Cases vs Total Deaths --

SELECT location, date, total_cases, total_deaths, 
(total_deaths/total_cases)* 100 AS death_percentage
FROM covid_deaths
-- WHERE Location like '%states%'
ORDER BY 1, 2;

-- Looking at Total Cases vs Popultation--

SELECT location, date, total_cases, population, 
(total_cases/population)* 100 AS contraction_percentage
FROM covid_deaths
-- WHERE Location like '%states%'
ORDER BY 1, 2;

-- Countries by highest infection rate compared to population--

SELECT location,population, MAX(total_cases) as highest_infection_count,MAX((total_cases/population))*100 as percent_infected
FROM covid_deaths
-- WHERE Location like '%states%'
GROUP BY location, population
ORDER BY percent_infected DESC;

-- Countries with the most deaths--

SELECT location, MAX(total_deaths) as total_death_Count
FROM covid_deaths
WHERE continent is not null
GROUP BY location
order by total_death_Count DESC;

-- Continents with the most deaths--

SELECT location, MAX(total_deaths) as total_death_Count
FROM covid_deaths
WHERE continent is null
GROUP BY location
order by total_death_Count DESC;

-- Countries with the highest death rate --

SELECT location,population, MAX(total_deaths) as highest_death_count,MAX((total_deaths/population))*100 as death_rate
FROM covid_deaths
-- WHERE Location like '%states%'
GROUP BY location, population
ORDER BY death_rate DESC;

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM covid_deaths
WHERE continent is not null
group by date
order by 1,2;


-- looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccination_count
FROM covid_deaths dea
JOIN covid_vax vax
	on dea.location = vax.location
    AND dea.date = vax.date
WHERE dea.continent is not null
order by 2,3;

-- People vaccinated per country--

WITH PopvsVax (continent, location, date, population, new_vaccinations, rolling_vaccination_count)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccination_count
FROM covid_deaths dea
JOIN covid_vax vax
	on dea.location = vax.location
    AND dea.date = vax.date
WHERE dea.continent is not null
-- order by 2,3
)
SELECT * , (rolling_vaccination_count/population)*100 as vax_percentage
FROM PopvsVax;

CREATE VIEW TdeathsvsTcases as
SELECT location, date, total_cases, total_deaths, 
(total_deaths/total_cases)* 100 AS death_percentage
FROM covid_deaths
-- WHERE Location like '%states%'
ORDER BY 1, 2;

CREATE VIEW CasesvsPop as
SELECT location, date, total_cases, population, 
(total_cases/population)* 100 AS contraction_percentage
FROM covid_deaths
-- WHERE Location like '%states%'
ORDER BY 1, 2;

CREATE VIEW MaxinfectionvsPop as
SELECT location,population, MAX(total_cases) as highest_infection_count,MAX((total_cases/population))*100 as percent_infected
FROM covid_deaths
-- WHERE Location like '%states%'
GROUP BY location, population
ORDER BY percent_infected DESC;

CREATE VIEW deathbycountries as 
SELECT location, MAX(total_deaths) as total_death_Count
FROM covid_deaths
WHERE continent is not null
GROUP BY location
order by total_death_Count DESC;

CREATE VIEW deathbycountriesrate as
SELECT location,population, MAX(total_deaths) as highest_death_count,MAX((total_deaths/population))*100 as death_rate
FROM covid_deaths
-- WHERE Location like '%states%'
GROUP BY location, population
ORDER BY death_rate DESC;

 -- GLOBAL NUMBERS
CREATE VIEW globalnumbers as
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_percentage
FROM covid_deaths
WHERE continent is not null
group by date
order by 1,2;


-- looking at total population vs vaccinations

CREATE VIEW popvsvax as
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccination_count
FROM covid_deaths dea
JOIN covid_vax vax
	on dea.location = vax.location
    AND dea.date = vax.date
WHERE dea.continent is not null
order by 2,3;

-- People vaccinated per country--
CREATE VIEW vaxpercountry as
WITH PopvsVax (continent, location, date, population, new_vaccinations, rolling_vaccination_count)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(vax.new_vaccinations) OVER (partition by dea.location order by dea.location, dea.date) as rolling_vaccination_count
FROM covid_deaths dea
JOIN covid_vax vax
	on dea.location = vax.location
    AND dea.date = vax.date
WHERE dea.continent is not null
-- order by 2,3
)
SELECT * , (rolling_vaccination_count/population)*100 as vax_percentage
FROM PopvsVax;


