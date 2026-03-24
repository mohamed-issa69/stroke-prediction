INSERT INTO silver.data_healthcare_dataset_stroke_data (
    id,
    gender,
    age,
    hypertension,
    heart_disease,
    ever_married,
    work_type,
    Residence_type,
    avg_glucose_level,
    bmi,
    smoking_status,
    stroke
)
SELECT
    CASE 
        WHEN id = '' THEN 0
        ELSE TRY_CAST(id AS INT)
    END,

    LTRIM(RTRIM(gender)),

    CASE 
        WHEN TRY_CAST(age AS INT) IS NULL THEN 0
        ELSE TRY_CAST(age AS INT)
    END,

    CASE 
        WHEN TRY_CAST(hypertension AS INT) IS NULL THEN 0
        ELSE TRY_CAST(hypertension AS INT)
    END,

    CASE 
        WHEN TRY_CAST(heart_disease AS INT) IS NULL THEN 0
        ELSE TRY_CAST(heart_disease AS INT)
    END,

    LTRIM(RTRIM(ever_married)),

    LTRIM(RTRIM(work_type)),

    LTRIM(RTRIM(Residence_type)),

    CASE 
        WHEN TRY_CAST(avg_glucose_level AS FLOAT) IS NULL THEN 0
        ELSE TRY_CAST(avg_glucose_level AS FLOAT)
    END,

    CASE 
        WHEN bmi = 'N/A' OR bmi = '' THEN 0
        ELSE TRY_CAST(bmi AS FLOAT)
    END,

    CASE 
        WHEN smoking_status = 'Unknown' THEN 'unknown'
        ELSE LTRIM(RTRIM(smoking_status))
    END,

    CASE 
        WHEN TRY_CAST(stroke AS INT) IS NULL THEN 0
        ELSE TRY_CAST(stroke AS INT)
    END

FROM bronze.data_healthcare_dataset_stroke_data;
SELECT * FROM silver.data_healthcare_dataset_stroke_data


INSERT INTO silver.data_cardio_train (
    id,
    age,
    gender,
    height,
    weight,
    ap_hi,
    ap_lo,
    cholesterol,
    gluc,
    smoke,
    alco,
    active,
    cardio
)
SELECT
    CASE WHEN id = '' THEN 0 ELSE TRY_CAST(id AS INT) END,
    CASE WHEN TRY_CAST(age AS INT) IS NULL THEN 0 ELSE TRY_CAST(age AS INT) END,
    CASE WHEN TRY_CAST(gender AS INT) IS NULL THEN 0 ELSE TRY_CAST(gender AS INT) END,
    CASE WHEN TRY_CAST(height AS INT) IS NULL THEN 0 ELSE TRY_CAST(height AS INT) END,
    CASE WHEN TRY_CAST(weight AS FLOAT) IS NULL THEN 0 ELSE TRY_CAST(weight AS FLOAT) END,
    CASE WHEN TRY_CAST(ap_hi AS INT) IS NULL THEN 0 ELSE TRY_CAST(ap_hi AS INT) END,
    CASE WHEN TRY_CAST(ap_lo AS INT) IS NULL THEN 0 ELSE TRY_CAST(ap_lo AS INT) END,
    CASE WHEN TRY_CAST(cholesterol AS INT) IS NULL THEN 0 ELSE TRY_CAST(cholesterol AS INT) END,
    CASE WHEN TRY_CAST(gluc AS INT) IS NULL THEN 0 ELSE TRY_CAST(gluc AS INT) END,
    CASE WHEN TRY_CAST(smoke AS INT) IS NULL THEN 0 ELSE TRY_CAST(smoke AS INT) END,
    CASE WHEN TRY_CAST(alco AS INT) IS NULL THEN 0 ELSE TRY_CAST(alco AS INT) END,
    CASE WHEN TRY_CAST(active AS INT) IS NULL THEN 0 ELSE TRY_CAST(active AS INT) END,
    CASE WHEN TRY_CAST(cardio AS INT) IS NULL THEN 0 ELSE TRY_CAST(cardio AS INT) END
FROM bronze.data_cardio_train;

SELECT * FROM silver.data_cardio_train

INSERT INTO silver.data_heart (
    Age,
    Sex,
    ChestPainType,
    RestingBP,
    Cholesterol,
    FastingBS,
    RestingECG,
    MaxHR,
    ExerciseAngina,
    Oldpeak,
    ST_Slope,
    HeartDisease
)
SELECT
    CASE WHEN TRY_CAST(Age AS INT) IS NULL THEN 0 ELSE TRY_CAST(Age AS INT) END,
    LTRIM(RTRIM(Sex)),
    LTRIM(RTRIM(ChestPainType)),
    CASE WHEN TRY_CAST(RestingBP AS INT) IS NULL THEN 0 ELSE TRY_CAST(RestingBP AS INT) END,
    CASE WHEN TRY_CAST(Cholesterol AS INT) IS NULL THEN 0 ELSE TRY_CAST(Cholesterol AS INT) END,
    CASE WHEN TRY_CAST(FastingBS AS INT) IS NULL THEN 0 ELSE TRY_CAST(FastingBS AS INT) END,
    LTRIM(RTRIM(RestingECG)),
    CASE WHEN TRY_CAST(MaxHR AS INT) IS NULL THEN 0 ELSE TRY_CAST(MaxHR AS INT) END,
    LTRIM(RTRIM(ExerciseAngina)),
    CASE WHEN TRY_CAST(Oldpeak AS FLOAT) IS NULL THEN 0 ELSE TRY_CAST(Oldpeak AS FLOAT) END,
    LTRIM(RTRIM(ST_Slope)),
    CASE WHEN TRY_CAST(HeartDisease AS INT) IS NULL THEN 0 ELSE TRY_CAST(HeartDisease AS INT) END
FROM bronze.data_heart;

SELECT * FROM silver.data_heart
