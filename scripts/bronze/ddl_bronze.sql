/*
======================
Creating Bronze Tables
======================
*/

IF OBJECT_ID ('bronze.data_healthcare_dataset_stroke_data' , 'U') IS NOT NULL
	DROP TABLE bronze.data_healthcare_dataset_stroke_data;
GO
  
CREATE TABLE bronze.data_healthcare_dataset_stroke_data (
id INT,
gender NVARCHAR(50),
age NVARCHAR(50),
hypertension INT,
heart_disease INT,
ever_married NVARCHAR(50),
work_type NVARCHAR(50),
Residence_type NVARCHAR(50),
avg_glucose_level FLOAT,
bmi NVARCHAR(50),
smoking_status NVARCHAR(50),
stroke INT
);
GO

IF OBJECT_ID ('bronze.data_heart' , 'U') IS NOT NULL
	DROP TABLE bronze.data_heart;
GO
  
CREATE TABLE bronze.data_heart (
Age INT,
Sex NVARCHAR(50),
ChestPainType NVARCHAR(50),
RestingBP INT,
Cholesterol INT,
FastingBS INT,
RestingECG NVARCHAR(50),
MaxHR INT,
ExerciseAngina NVARCHAR(50),
Oldpeak FLOAT,
ST_Slope NVARCHAR(50),
HeartDisease INT
);
GO
  
IF OBJECT_ID ('bronze.data_cardio_train' , 'U') IS NOT NULL
	DROP TABLE bronze.data_cardio_train;
GO
  
CREATE TABLE bronze.data_cardio_train (
id INT,
age INT,
gender INT,
height INT,
weight FLOAT,
ap_hi INT,
ap_lo INT,
cholesterol INT,
gluc INT,
smoke INT,
alco INT,
active INT,
cardio INT
);
GO

TRUNCATE TABLE bronze.data_healthcare_dataset_stroke_data;
BULK INSERT bronze.data_healthcare_dataset_stroke_data
FROM 'C:\Users\MOHAMED\Desktop\data\healthcare_dataset_stroke_data.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	FIELDQUOTE = '"',
  ROWTERMINATOR = '0x0a',
  CODEPAGE = '65001',
	TABLOCK
);

SELECT * FROM bronze.data_healthcare_dataset_stroke_data
SELECT COUNT(*) FROM bronze.data_healthcare_dataset_stroke_data

TRUNCATE TABLE bronze.data_heart;
BULK INSERT bronze.data_heart
FROM 'C:\Users\MOHAMED\Desktop\data\heart.csv'
WITH (
	FORMAT = 'CSV',
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	FIELDQUOTE = '"',
  ROWTERMINATOR = '0x0a',
  CODEPAGE = '65001',
	TABLOCK
);

SELECT * FROM bronze.data_heart
SELECT COUNT(*) FROM bronze.data_heart

TRUNCATE TABLE bronze.data_cardio_train;
BULK INSERT bronze.data_cardio_train
FROM 'C:\Users\MOHAMED\Desktop\data\cardio_train.csv'
WITH (
	FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

SELECT * FROM bronze.data_cardio_train
SELECT COUNT(*) FROM bronze.data_cardio_train


