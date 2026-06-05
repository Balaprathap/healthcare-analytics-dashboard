-- ==========================
-- 1. ROW COUNTS CHECK
-- ==========================

SELECT 'stg_healthcare' AS table_name, COUNT(*) AS row_count FROM stg_healthcare
UNION ALL
SELECT 'dim_patient', COUNT(*) FROM dim_patient
UNION ALL
SELECT 'dim_doctor', COUNT(*) FROM dim_doctor
UNION ALL
SELECT 'dim_hospital', COUNT(*) FROM dim_hospital
UNION ALL
SELECT 'dim_insurance', COUNT(*) FROM dim_insurance
UNION ALL
SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL
SELECT 'fact_admissions', COUNT(*) FROM fact_admissions;


-- ==========================
-- 2. TOTAL ADMISSIONS
-- ==========================

SELECT COUNT(*) AS total_admissions
FROM fact_admissions;


-- ==========================
-- 3. TOTAL REVENUE
-- ==========================

SELECT ROUND(SUM(billing_amount), 2) AS total_revenue
FROM fact_admissions;


-- ==========================
-- 4. AVERAGE LENGTH OF STAY
-- ==========================

SELECT ROUND(AVG(length_of_stay), 2) AS avg_length_of_stay
FROM fact_admissions;


-- ==========================
-- 5. REVENUE BY INSURANCE PROVIDER
-- ==========================

SELECT
    i.insurance_provider,
    ROUND(SUM(f.billing_amount), 2) AS total_revenue
FROM fact_admissions f
JOIN dim_insurance i
    ON f.insurance_key = i.insurance_key
GROUP BY i.insurance_provider
ORDER BY total_revenue DESC;


-- ==========================
-- 6. REVENUE BY ADMISSION TYPE
-- ==========================

SELECT
    admission_type,
    ROUND(SUM(billing_amount), 2) AS revenue
FROM fact_admissions
GROUP BY admission_type
ORDER BY revenue DESC;


-- ==========================
-- 7. MONTHLY ADMISSIONS TREND
-- ==========================

SELECT
    DATE_TRUNC('month', admission_date) AS admission_month,
    COUNT(*) AS admissions
FROM fact_admissions
GROUP BY admission_month
ORDER BY admission_month;


-- ==========================
-- 8. TOP 10 MEDICAL CONDITIONS
-- ==========================

SELECT
    p.medical_condition,
    COUNT(*) AS patient_count
FROM fact_admissions f
JOIN dim_patient p
    ON f.patient_key = p.patient_key
GROUP BY p.medical_condition
ORDER BY patient_count DESC
LIMIT 10;


-- ==========================
-- 9. REVENUE BY AGE GROUP
-- ==========================

SELECT
    CASE
        WHEN p.age < 18 THEN '0-17'
        WHEN p.age BETWEEN 18 AND 35 THEN '18-35'
        WHEN p.age BETWEEN 36 AND 50 THEN '36-50'
        WHEN p.age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '65+'
    END AS age_group,
    ROUND(SUM(f.billing_amount), 2) AS revenue
FROM fact_admissions f
JOIN dim_patient p
    ON f.patient_key = p.patient_key
GROUP BY age_group
ORDER BY revenue DESC;


-- ==========================
-- 10. TOP 10 HOSPITALS BY REVENUE
-- ==========================

SELECT
    h.hospital_name,
    ROUND(SUM(f.billing_amount), 2) AS total_revenue
FROM fact_admissions f
JOIN dim_hospital h
    ON f.hospital_key = h.hospital_key
GROUP BY h.hospital_name
ORDER BY total_revenue DESC
LIMIT 10;


-- ==========================
-- 11. TOP 10 DOCTORS BY PATIENT COUNT
-- ==========================

SELECT
    d.doctor_name,
    COUNT(*) AS patient_count
FROM fact_admissions f
JOIN dim_doctor d
    ON f.doctor_key = d.doctor_key
GROUP BY d.doctor_name
ORDER BY patient_count DESC
LIMIT 10;
