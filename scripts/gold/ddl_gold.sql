
/*
=======================
DROP GOLD OBJECTS
=======================
*/

IF OBJECT_ID('gold.fact_patient_health', 'V') IS NOT NULL
    DROP VIEW gold.fact_patient_health;

IF OBJECT_ID('gold.dim_lifestyle', 'V') IS NOT NULL
    DROP VIEW gold.dim_lifestyle;

IF OBJECT_ID('gold.dim_patient_info', 'V') IS NOT NULL
    DROP VIEW gold.dim_patient_info;
GO


/*
=======================
DIM: PATIENT INFO
=======================
*/
CREATE VIEW gold.dim_patient_info AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY stroke.id) AS patient_sk,
    stroke.id AS patient_id,

    COALESCE(
        CASE WHEN stroke.gender IN ('Male','Female') THEN stroke.gender END,
        CASE 
            WHEN cardio.gender = 1 THEN 'Male'
            WHEN cardio.gender = 2 THEN 'Female'
        END
    ) AS gender,

    stroke.age,
    stroke.ever_married,
    stroke.work_type,
    stroke.Residence_type

FROM silver.data_healthcare_dataset_stroke_data AS stroke

LEFT JOIN (
    SELECT DISTINCT
        age / 365.0 AS age_years,
        gender
    FROM silver.data_cardio_train
) cardio
ON stroke.age = cardio.age_years
AND (
    (cardio.gender = 1 AND stroke.gender = 'Male') OR
    (cardio.gender = 2 AND stroke.gender = 'Female')
);
GO


/*
=======================
DIM: LIFESTYLE
=======================
*/
CREATE VIEW gold.dim_lifestyle AS
SELECT
    ROW_NUMBER() OVER (ORDER BY stroke.id) AS lifestyle_sk,
    stroke.id AS patient_id,

    COALESCE(stroke.smoking_status,'Unknown') AS smoking_status,
    COALESCE(cardio.smoke,0) AS smoke_flag,
    COALESCE(cardio.alco,0) AS alco_flag

FROM silver.data_healthcare_dataset_stroke_data AS stroke

LEFT JOIN silver.data_cardio_train AS cardio
ON stroke.age = (cardio.age / 365.0)
AND (
    (cardio.gender = 1 AND stroke.gender = 'Male') OR
    (cardio.gender = 2 AND stroke.gender = 'Female')
);
GO


/*
=======================
FACT TABLE
=======================
*/
CREATE VIEW gold.fact_patient_health AS
SELECT
    stroke.id AS patient_id,

    stroke.age,
    stroke.gender,

    stroke.hypertension,
    stroke.heart_disease,

    stroke.avg_glucose_level,

    CASE 
        WHEN stroke.bmi = 'N/A' OR stroke.bmi = '' THEN NULL
        ELSE TRY_CAST(stroke.bmi AS FLOAT)
    END AS bmi,

    /*
    =======================
    HEART AGGREGATION
    =======================
    */
    heart_agg.avg_RestingBP,
    heart_agg.avg_Cholesterol AS heart_cholesterol,
    heart_agg.avg_MaxHR,
    heart_agg.avg_Oldpeak,
    heart_agg.heart_disease_rate,

    /*
    =======================
    CARDIO AGGREGATION (FIXED SCALE)
    =======================
    */
    cardio_agg.avg_height,
    cardio_agg.avg_weight,
    cardio_agg.avg_ap_hi,
    cardio_agg.avg_ap_lo,
    cardio_agg.avg_cholesterol AS cardio_cholesterol,
    cardio_agg.avg_gluc AS cardio_gluc,
    cardio_agg.cardio_rate,

    stroke.stroke AS stroke_target

FROM silver.data_healthcare_dataset_stroke_data AS stroke


/*
=======================
HEART DATASET
=======================
*/
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
    WHEN heart_agg.Sex = 'M' THEN 'Male'
    WHEN heart_agg.Sex = 'F' THEN 'Female'
END


/*
=======================
CARDIO DATASET (FIXED SCALE)
=======================
*/
LEFT JOIN (
    SELECT
        age / 365.0 AS age_years,
        gender,

        AVG(height) AS avg_height,
        AVG(weight) AS avg_weight,
        AVG(ap_hi) AS avg_ap_hi,
        AVG(ap_lo) AS avg_ap_lo,
        AVG(cholesterol) AS avg_cholesterol,
        AVG(gluc) AS avg_gluc,
        AVG(cardio) AS cardio_rate

    FROM silver.data_cardio_train
    GROUP BY age / 365.0, gender
) AS cardio_agg
ON stroke.age = cardio_agg.age_years
AND (
    (cardio_agg.gender = 1 AND stroke.gender = 'Male') OR
    (cardio_agg.gender = 2 AND stroke.gender = 'Female')
);
GO


/*
=======================
CHECKS
=======================
*/

SELECT COUNT(*) AS fact_count
FROM gold.fact_patient_health;

SELECT TOP 500 *
FROM gold.fact_patient_health;

SELECT *
FROM gold.dim_patient_info;

SELECT *
FROM gold.dim_lifestyle;
