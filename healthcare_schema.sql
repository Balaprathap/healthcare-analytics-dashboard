-- ==========================
-- STAGING TABLE
-- ==========================

CREATE TABLE stg_healthcare (
    "Name" TEXT,
    "Age" INT,
    "Gender" TEXT,
    "Blood Type" TEXT,
    "Medical Condition" TEXT,
    "Date of Admission" DATE,
    "Doctor" TEXT,
    "Hospital" TEXT,
    "Insurance Provider" TEXT,
    "Billing Amount" NUMERIC(12,2),
    "Room Number" INT,
    "Admission Type" TEXT,
    "Discharge Date" DATE,
    "Medication" TEXT,
    "Test Results" TEXT
);

-- ==========================
-- DIM PATIENT
-- ==========================

CREATE TABLE dim_patient (
    patient_key SERIAL PRIMARY KEY,
    patient_name TEXT,
    age INT,
    gender TEXT,
    blood_type TEXT,
    medical_condition TEXT
);

-- ==========================
-- DIM DOCTOR
-- ==========================

CREATE TABLE dim_doctor (
    doctor_key SERIAL PRIMARY KEY,
    doctor_name TEXT UNIQUE
);

-- ==========================
-- DIM HOSPITAL
-- ==========================

CREATE TABLE dim_hospital (
    hospital_key SERIAL PRIMARY KEY,
    hospital_name TEXT UNIQUE
);

-- ==========================
-- DIM INSURANCE
-- ==========================

CREATE TABLE dim_insurance (
    insurance_key SERIAL PRIMARY KEY,
    insurance_provider TEXT UNIQUE
);

-- ==========================
-- DIM DATE
-- ==========================

CREATE TABLE dim_date (
    date_key SERIAL PRIMARY KEY,
    full_date DATE UNIQUE,
    year INT,
    quarter INT,
    month INT,
    month_name TEXT
);

-- ==========================
-- FACT ADMISSIONS
-- ==========================

CREATE TABLE fact_admissions (
    admission_key SERIAL PRIMARY KEY,

    patient_key INT REFERENCES dim_patient(patient_key),
    doctor_key INT REFERENCES dim_doctor(doctor_key),
    hospital_key INT REFERENCES dim_hospital(hospital_key),
    insurance_key INT REFERENCES dim_insurance(insurance_key),

    admission_date DATE,
    discharge_date DATE,

    billing_amount NUMERIC(12,2),
    room_number INT,

    admission_type TEXT,
    medication TEXT,
    test_results TEXT,

    length_of_stay INT
);
