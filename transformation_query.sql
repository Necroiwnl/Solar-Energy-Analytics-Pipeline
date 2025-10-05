-- This query creates a new table with daily aggregated data
CREATE OR REPLACE TABLE solar_project.daily_generation AS
SELECT
  -- Extract just the date from the timestamp
  DATE(Timestamp) AS generation_date,
  Plant_ID,
  -- Sum the energy and downtime for the entire day
  SUM(Energy_Generated_kWh) AS total_daily_energy_kwh,
  SUM(Downtime_mins) AS total_daily_downtime_mins,
  -- Calculate the average efficiency, rounded to two decimal places
  ROUND(AVG(Inverter_Efficiency_pct), 2) AS avg_daily_efficiency_pct
FROM
  `solar-analytics-pipeline.solar_project.raw_solar_data`
WHERE
    -- Only include data where inverters were active
    Inverter_Efficiency_pct > 0
GROUP BY
  -- Group the calculations for each day and each plant
  generation_date,
  Plant_ID
ORDER BY
  -- Sort the final table
  generation_date,
  Plant_ID;