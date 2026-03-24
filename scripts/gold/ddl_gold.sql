IF OBJECT_ID('gold.fact_patient_health', 'V') IS NOT NULL
    DROP VIEW gold.fact_patient_health;

IF OBJECT_ID('gold.dim_lifestyle', 'V') IS NOT NULL
    DROP VIEW gold.dim_lifestyle;

IF OBJECT_ID('gold.dim_patient_info', 'V') IS NOT NULL
    DROP VIEW gold.dim_patient_info;
GO



CREATE VIEW gold.dim_patient_info AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY stroke.id) AS patient_sk,
    stroke.id AS patient_id,

    COALESCE(
        CASE WHEN stroke.gender='Male' THEN 'Male' WHEN stroke.gender='Female' THEN 'Female' END,
        CASE WHEN cardio.gender=1 THEN 'Male' WHEN cardio.gender=2 THEN 'Female' END
    ) AS gender,

    stroke.ever_married,
    stroke.Residence_type,
    stroke.work_type,
    stroke.age

FROM silver.data_healthcare_dataset_stroke_data AS stroke
LEFT JOIN silver.data_cardio_train AS cardio
    ON stroke.id = cardio.id;
GO



CREATE VIEW gold.dim_lifestyle AS
SELECT
    ROW_NUMBER() OVER (ORDER BY stroke.id) AS lifestyle_sk,
    stroke.id AS patient_id,

    COALESCE(stroke.smoking_status,'Unknown') AS smoking_status,
    COALESCE(cardio.smoke,0) AS smoke_flag,
    COALESCE(cardio.alco,0) AS alco_flag

FROM silver.data_healthcare_dataset_stroke_data AS stroke
LEFT JOIN silver.data_cardio_train AS cardio
    ON stroke.id = cardio.id;
GO





CREATE VIEW gold.fact_patient_health AS
SELECT
    stroke.id AS patient_id,

    stroke.age,
    stroke.hypertension,
    stroke.heart_disease,

    cardio.height,
    cardio.weight,
    cardio.ap_hi,
    cardio.ap_lo,
    cardio.cholesterol AS cardio_cholesterol,
    cardio.gluc AS cardio_gluc,

    stroke.avg_glucose_level,
    CASE 
        WHEN stroke.bmi='N/A' OR stroke.bmi='' THEN NULL 
        ELSE TRY_CAST(stroke.bmi AS FLOAT) 
    END AS bmi,

    heart_agg.avg_RestingBP,
    heart_agg.avg_Cholesterol,
    heart_agg.avg_MaxHR,
    heart_agg.avg_Oldpeak,
    heart_agg.heart_disease_rate,

    stroke.stroke,
    cardio.cardio

FROM silver.data_healthcare_dataset_stroke_data AS stroke

LEFT JOIN silver.data_cardio_train AS cardio
    ON stroke.id = cardio.id

LEFT JOIN (
    SELECT 
        Age,
        Sex,
        AVG(CAST(RestingBP AS FLOAT)) AS avg_RestingBP,
        AVG(CAST(Cholesterol AS FLOAT)) AS avg_Cholesterol,
        AVG(CAST(MaxHR AS FLOAT)) AS avg_MaxHR,
        AVG(CAST(Oldpeak AS FLOAT)) AS avg_Oldpeak,
        AVG(CAST(HeartDisease AS FLOAT)) AS heart_disease_rate
    FROM silver.data_heart
    GROUP BY Age, Sex
) AS heart_agg

ON stroke.age = heart_agg.Age
AND stroke.gender = CASE 
    WHEN heart_agg.Sex='M' THEN 'Male' 
    ELSE 'Female' 
END;
GO


SELECT patient_id, COUNT(*) 
FROM gold.fact_patient_health
GROUP BY patient_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM gold.fact_patient_health;

SELECT TOP 500 * FROM gold.fact_patient_health;

SELECT f.patient_id, p.gender, l.smoking_status
FROM gold.fact_patient_health f
LEFT JOIN gold.dim_patient_info p
    ON f.patient_id = p.patient_id
LEFT JOIN gold.dim_lifestyle l
    ON f.patient_id = l.patient_id;

