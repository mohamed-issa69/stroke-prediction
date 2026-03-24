/*
=======================
Creating Silver Tables
=======================
*/

IF OBJECT_ID ('silver.data_healthcare_dataset_stroke_data' , 'U') IS NOT NULL
	DROP TABLE silver.data_healthcare_dataset_stroke_data;
GO
  
CREATE TABLE silver.data_healthcare_dataset_stroke_data (
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
  
IF OBJECT_ID ('silver.data_heart' , 'U') IS NOT NULL
	DROP TABLE silver.data_heart;
GO
  
CREATE TABLE silver.data_heart (
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
  
IF OBJECT_ID ('silver.data_cardio_train' , 'U') IS NOT NULL
	DROP TABLE silver.data_cardio_train;
GO
  
CREATE TABLE silver.data_cardio_train (
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

