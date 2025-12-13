# SQL Data Analysis & Reporting (Assignment 4.1)

## Overview
This collection contains the SQL scripts and execution results for the **Catchem Data Warehouse** analysis (Assignment 4.1). These queries are designed to aggregate and report on treasure hunting data populated in the previous ETL steps, specifically focusing on temporal trends in the year 2024.

## File Descriptions

### 1. Seasonal Analysis (Task 4.1.1)
* **`4_1_1_SQL.txt`**: A SQL query that calculates the total number of treasures found during a specific season and year.
    * **Logic**: It joins `Fact_Treasure_Found` with `Dim_Date` and `Dim_Season`. It filters for records where the season is 'Summer' and the year is 2024.
* **`4_1_1_SQL_result.txt`**: The output of the seasonal query.
    * **Result**: It reports a total of **1,319** treasures found during Summer 2024.

### 2. Monthly Distribution Analysis (Task 4.1.2)
* **`4_1_2_SQL.txt`**: A SQL query that provides a monthly breakdown of found treasures for a specific year.
    * **Logic**: It joins `Fact_Treasure_Found` with `Dim_Date`, filtering for the year 2024. The results are grouped by `MonthName` and ordered chronologically by the month number (`dd.Month`).
* **`4_1_2_SQL_result.txt`**: The output table showing the count of found treasures for every month of 2024.
    * **Key Data Points**:
        * **Lowest Activity**: January (153 treasures) and November (154 treasures).
        * **Highest Activity**: August (185 treasures).

## Summary of Results

| Query | Description | Key Result |
| :--- | :--- | :--- |
| **4.1.1** | Total treasures in Summer 2024 | **1,319** |
| **4.1.2** | Monthly Totals 2024 | Ranges from **153** (Jan) to **185** (Aug) |
