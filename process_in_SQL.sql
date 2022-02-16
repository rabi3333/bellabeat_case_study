------------PROCESS: Using SQL
--While importing hourly recorded datasets BigQuery didn't recognize AM/PM datetime format, so I included it as a string then convert it to a proper datetime format. (applied this to the three hourly recorded tables.)--

SELECT  Id, PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS activityhour, Calories
FROM `my-project-01-325118.fitbit.calories_hour`
ORDER BY Id, activityhour

SELECT  Id, PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS activityhour, TotalIntensity, AverageIntensity
FROM `my-project-01-325118.fitbit.intensities_hour`
ORDER BY Id, activityhour

SELECT  Id, PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS activityhour, StepTotal
FROM `my-project-01-325118.fitbit.steps_hour`
ORDER BY Id, activityhour

--We do the same to sleepDay table except that this time we extract only the date from the format in the table

SELECT  Id, PARSE_DATE('%m/%d/%Y', SUBSTR(SleepDay, 0, 9)) AS sleepday, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
FROM `my-project-01-325118.fitbit.sleepday`
ORDER BY Id, sleepday
-------------
--Now we check the number of users in dailyactivity dataset:

SELECT COUNT(DISTINCT Id) as Id_number
FROM `my-project-01-325118.fitbit.dailyactivity` 

-- 33

SELECT COUNT(DISTINCT Id) as Id_number
FROM `my-project-01-325118.fitbit.sleepday`

--24

--Then the number of records for each user with the following queries:

SELECT DISTINCT Id, COUNT(Id) as number_of_records
FROM `my-project-01-325118.fitbit.dailyactivity` 
group by Id

SELECT DISTINCT Id, COUNT(Id) as number_of_records
FROM `my-project-01-325118.fitbit.sleepday`
group by Id

--as we can see for dailyactivity dataset we have 33 users and 24 in sleepday dataset but some users didn't record their activity for an entire month, we have missing records.--

--Next we search for null values: 

SELECT *
FROM `my-project-01-325118.fitbit.dailyactivity`
WHERE NULL

--We have no null values in the dailyactivity dataset.

--We do the same steps for the three hourly recorded datasets

SELECT  COUNT(DISTINCT Id) as Id_number
FROM `my-project-01-325118.fitbit.hourly_calories`

--33

SELECT  COUNT(DISTINCT Id) as Id_number
FROM `my-project-01-325118.fitbit.hourly_steps`

--33

SELECT  COUNT(DISTINCT Id) as Id_number
FROM `my-project-01-325118.fitbit.hourly_intensities`

--33

SELECT *
FROM `my-project-01-325118.fitbit.hourly_calories`
WHERE NULL

SELECT *
FROM `my-project-01-325118.fitbit.hourly_intensities`
WHERE NULL

SELECT *
FROM `my-project-01-325118.fitbit.hourly_steps`
WHERE NULL 

--Now we merge the three tables together because they have the same two first columns(Id and activityhour) so we deal with only one table which we call "hourlyactivity":--

SELECT hourly_calories.Id, hourly_calories.activityhour, Calories, TotalIntensity, AverageIntensity, StepTotal
FROM `my-project-01-325118.fitbit.hourly_calories` as hourly_calories
JOIN `my-project-01-325118.fitbit.hourly_intensities` as hourly_intensities
ON hourly_calories.Id = hourly_intensities.Id and hourly_calories.activityhour = hourly_intensities.activityhour
JOIN `my-project-01-325118.fitbit.hourly_steps` as hourly_steps
ON hourly_intensities.Id = hourly_steps.Id and hourly_intensities.activityhour = hourly_steps.activityhour
ORDER BY hourly_calories.Id
