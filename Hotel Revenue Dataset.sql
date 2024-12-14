-- selecting our databases

SELECT *
FROM [Portfolio projects].dbo.['2018$'];

SELECT *
FROM [Portfolio projects].dbo.['2019$'];

SELECT *
FROM [Portfolio projects].dbo.['2020$'];

SELECT *
FROM [Portfolio projects].dbo.market_segment$;

SELECT *
FROM [Portfolio projects].dbo.meal_cost$;

-- unified dataset for the different years
-- use union statements to remove duplicates if any
SELECT *
FROM [Portfolio projects].dbo.['2018$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2019$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2020$'];

-- exploratory analysis
-- Is our hotel revenue growing by year? 
-- We have two hotel types, so it would be good to segment revenue by hotel type.

-- introduce a CTE
WITH hotels AS (
	SELECT *
FROM [Portfolio projects].dbo.['2018$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2019$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2020$'])
SELECT *
FROM hotels;

-- creating new columns to get the total revenue
WITH hotels AS (
	SELECT *
FROM [Portfolio projects].dbo.['2018$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2019$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2020$'])
SELECT (stays_in_week_nights + stays_in_weekend_nights) AS total_stay_nights
FROM hotels;

-- multiply by the daily rate to get the revenue
WITH hotels AS (
	SELECT *
FROM [Portfolio projects].dbo.['2018$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2019$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2020$'])
SELECT hotel,
	   arrival_date_year,
	   ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)*adr),0) AS total_revenue
FROM hotels
GROUP BY arrival_date_year, hotel;

-- we notice an increase from 2018 to 2019 then a decrease in 2020

-- joining the other two tables now
WITH hotels AS (
	SELECT *
FROM [Portfolio projects].dbo.['2018$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2019$']
UNION
SELECT *
FROM [Portfolio projects].dbo.['2020$'])
SELECT *
FROM hotels
LEFT JOIN [Portfolio projects].dbo.market_segment$
	ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN [Portfolio projects].dbo.meal_cost$
	ON meal_cost$.meal = hotels.meal;
