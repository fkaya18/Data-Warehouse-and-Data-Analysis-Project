# Data-Warehouse-and-Data-Analysis-Project

This project presents a comprehensive demonstration of modern data warehouse and analytics solutions. It includes end-to-end data processes featuring API-based data extraction, ETL procedures, data warehouse design, and visualization with Power BI.

## 🏗️  Data Architecture

This project adopts the Medallion Architecture approach (Bronze, Silver Preparation, Silver, Gold layers):

* **Bronze Layer:** Stores raw data extracted from APIs as-is

* **Silver Preparation Layer:** Flattens nested JSON structures and arrays from the Bronze layer into normalized columns

* **Silver Layer:** Contains data cleansing, standardization, and normalization processes

* **Gold Layer:** Business-ready data structured in star schema model for reporting and analytics

## 🎯 Project Scope

This project includes:

* **API-Based Data Extraction:** Data collection from DummyJSON API using Python

* **ETL Pipeline:** Extract, Transform, and Load processes using user defined functions with python

* **Data Modeling:** Development of fact and dimension tables optimized for analytical queries

* **SQL Server Data Warehouse:** Modern data warehouse architecture setup

* **Power BI Analytics:** Business intelligence and visualization solutions

## 🛠️ Technology Stack

* **Python:** For data extraction and ETL processes

  * **requests:** API calls
  * **pandas:** Data manipulation
  * **sqlalchemy:** Database connections

* **SQL Server:** Data warehouse platform
* **Power BI:** Business intelligence and visualization

## 🔄 ETL Process

The ETL process is implemented using Python. You can access the detailed ETL process in the etl_process.ipynb file.

### Extract - Python API Integration

Data is extracted from DummyJSON API endpoints including products, users, and carts using the requests library.


### Transform - Data Processing with Python

Raw extracted data is processed using Python to flatten nested JSON structures and arrays into normalized table format.

### Load - SQL Server Integration
   
Processed data is loaded into appropriate layers in SQL Server.

## 🗂️ Entity Relationship Diagram




