# Solar-Energy-Analytics-Pipeline
An end-to-end cloud analytics pipeline using Google Cloud Platform (BigQuery), SQL, and Power BI to automate solar farm performance reporting.
# Solar Energy Analytics Pipeline

[View the Final Dashboard PDF](Solar_Analytics_Dashboard.pdf)

## The Challenge: From Manual Mess to Automated Insights

In many organizations, critical data analysis is stuck in a slow, manual loop. For this project, the scenario was a solar energy company where an analyst spent over 3 hours every week just preparing data. The process involved manually downloading dozens of CSV files, painstakingly cleaning and merging them in Excel, and wrestling with pivot tables. This workflow was not only tedious but also introduced a significant risk of human error, and the final report was always a week out of date.

I knew this entire process could be automated to be faster, more accurate, and deliver more timely insights.

## The Solution: A Cloud-Powered Pipeline

I designed and built a modern, end-to-end data pipeline using Google Cloud Platform and Power BI. This solution automates the entire workflow, creating a seamless flow from raw data to actionable intelligence.

Here's how it works:
1.  Raw hourly data from solar plants is ingested and stored in Google Cloud Storage.
2.  A powerful SQL script in Google BigQuery automatically cleans, aggregates, and transforms the messy data into a clean, structured, daily summary table.
3.  This analysis-ready table is then connected to an interactive Power BI dashboard where stakeholders can explore the data and monitor performance daily.

What once took hours of manual work now happens automatically, providing reliable data every single day.

## Tech Stack
* **Cloud Platform:** Google Cloud Platform (GCP)
* **Data Lake:** Google Cloud Storage
* **Data Warehouse:** Google BigQuery
* **Data Transformation:** SQL
* **Data Visualization:** Power BI

## The Core Logic: SQL Transformation
The heart of this automation is the following SQL query I wrote for BigQuery. It efficiently processes thousands of raw hourly records into the clean, daily summary table that feeds the final dashboard.

```sql
-- Create a new table with daily aggregated data
CREATE OR REPLACE TABLE solar_project.daily_generation AS
SELECT
    -- Extract date from the timestamp
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
    -- Including data where inverters were active
    Inverter_Efficiency_pct > 0
GROUP BY
    -- Group the calculations for each day and each plant
    generation_date,
    Plant_ID
ORDER BY
    -- Sorting the final table
    generation_date,
    Plant_ID;
