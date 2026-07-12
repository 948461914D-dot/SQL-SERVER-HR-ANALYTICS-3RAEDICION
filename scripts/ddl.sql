CREATE DATABASE FINANCIAL_ANALYSTIC_PROYECT
USE FINANCIAL_ANALYSTIC_PROYECT

CREATE TABLE dbo.Customers (
    customer_id              nvarchar(20)  NOT NULL PRIMARY KEY,
    customer_name            nvarchar(150) NOT NULL,
    customer_type            nvarchar(20)  NOT NULL,
    credit_terms_days        int           NULL,
    primary_freight_type     nvarchar(50)  NULL,
    account_status           nvarchar(20)  NULL,
    contract_start_date      date          NULL,
    annual_revenue_potential bigint        NULL
);
--- IMPORTACION DE MI DATA CSV
BULK INSERT dbo.Customers
FROM 'C:\Users\David\Documents\123git\SQL-SERVER-HR-ANALYTICS-3RAEDICION\DATABASE\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);

SELECT * 
FROM customers ;


-- Crear tabla loads
CREATE TABLE dbo.Loads (
load_id nvarchar(30) NOT NULL PRIMARY KEY,
customer_id nvarchar(20) NOT NULL,
route_id nvarchar(20) NULL,
load_date date NULL,
load_type nvarchar(50) NULL,
weight_lbs int NULL,
pieces int NULL,
revenue decimal(18,2) NULL,
fuel_surcharge decimal(18,2) NULL,
accessorial_charges decimal(18,2) NULL,
load_status nvarchar(30) NULL,
booking_type nvarchar(30) NULL
);
GO

-- Import CSV usando BULK INSERT (ajusta la ruta al archivo en el servidor)
BULK INSERT dbo.Loads
FROM 'C:\Users\David\Documents\123git\SQL-SERVER-HR-ANALYTICS-3RAEDICION\DATABASE\loads.csv'
WITH (
FORMAT = 'CSV',
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '0x0a',
CODEPAGE = '65001',
TABLOCK
);
GO

SELECT *
FROM dbo.Loads