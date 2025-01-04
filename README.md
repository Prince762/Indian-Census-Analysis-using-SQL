--India Census Data Analysis

--About

This project aims to analyze the India Census data using SQL to uncover insights about population distribution, literacy rates, and other demographic indicators. The goal is to support data-driven decision-making for policy development and resource allocation.

--Dataset Details

Dataset1.xlsx and Dataset2.xlsx provide comprehensive data on various demographic factors of the Indian population across states and districts.
SQLQuery1.sql contains SQL queries used for data wrangling and analysis.



--Analysis Objectives

Population Distribution
Analyze population density by state and district.0
Compare rural vs. urban population proportions.
Literacy Analysis
Identify states with the highest and lowest literacy rates.
Explore gender disparities in literacy.
Gender Demographics
Analyze the male-to-female ratio across states.

--Approach Used

1. Data Wrangling

Imported Dataset1.xlsx and Dataset2.xlsx into SQL tables.
Checked and handled NULL values using appropriate filtering or imputation methods.

2. Feature Engineering

Added a computed column Prev_census to calculate population from previous census using 
current population and growth rate.
Created a column gender_ratio to calculate the ratio of males to females.

3. Exploratory Data Analysis (EDA)
Used SQL queries to perform statistical analysis, aggregations, and filtering.

--Key Business Questions

*Population and Demographics

What is the total population of each state?

Which state has the highest and lowest urban population?

What is the ratio of male to female populations by state and district?

*Literacy

Which states have the highest and lowest literacy rates?
What is the gap between male and female literacy rates?

Additional Metrics

Calculate population density by state usind population and area per square kilometer
Top 3 districts from each state in terms of literacy


Conclusion

This analysis of India's census data provides insights into demographic trends, literacy levels, and urban-rural distributions. These findings can help inform government policies, educational initiatives, and resource planning strategies.

