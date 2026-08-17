/*==============================================================================
 File: 09_Database_Validation.sql
 Purpose: Answer "Is my data correct?" with PASS/FAIL checks.
==============================================================================*/
USE hospital_analytics_db;

/* 1. Table inventory */
SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE' ORDER BY TABLE_NAME;

/* 2. Expected table count: 26 = 11 dimensions + 15 facts */
SELECT CASE WHEN COUNT(*)=26 THEN 'PASS' ELSE 'FAIL' END validation_status,COUNT(*) actual_table_count,26 expected_table_count FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE';

/* 3. Required dimension row counts */
SELECT 'dim_department' table_name,COUNT(*) row_count,CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END status FROM dim_department
UNION ALL SELECT 'dim_insurance',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_insurance
UNION ALL SELECT 'dim_payment_mode',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_payment_mode
UNION ALL SELECT 'dim_ward',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_ward
UNION ALL SELECT 'dim_bed',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_bed
UNION ALL SELECT 'dim_doctor',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_doctor
UNION ALL SELECT 'dim_patient',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_patient
UNION ALL SELECT 'dim_diagnosis',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_diagnosis
UNION ALL SELECT 'dim_medicine',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_medicine
UNION ALL SELECT 'dim_lab_test',COUNT(*),CASE WHEN COUNT(*)>0 THEN 'PASS' ELSE 'FAIL' END FROM dim_lab_test
UNION ALL SELECT 'dim_date',COUNT(*),CASE WHEN COUNT(*)=366 THEN 'PASS' ELSE 'FAIL' END FROM dim_date;

/* 4. Duplicate business keys */
SELECT 'patient_code' check_name,COUNT(*) duplicate_groups FROM (SELECT patient_code FROM dim_patient GROUP BY patient_code HAVING COUNT(*)>1) x
UNION ALL SELECT 'doctor_code',COUNT(*) FROM (SELECT doctor_code FROM dim_doctor GROUP BY doctor_code HAVING COUNT(*)>1) x
UNION ALL SELECT 'department_code',COUNT(*) FROM (SELECT department_code FROM dim_department GROUP BY department_code HAVING COUNT(*)>1) x
UNION ALL SELECT 'insurance_code',COUNT(*) FROM (SELECT insurance_code FROM dim_insurance GROUP BY insurance_code HAVING COUNT(*)>1) x
UNION ALL SELECT 'bed_code',COUNT(*) FROM (SELECT bed_code FROM dim_bed GROUP BY bed_code HAVING COUNT(*)>1) x;

/* 5. Orphan FK checks */
SELECT 'appointments.patient_id' check_name,COUNT(*) orphan_rows FROM fact_appointments a LEFT JOIN dim_patient p ON p.patient_id=a.patient_id WHERE p.patient_id IS NULL
UNION ALL SELECT 'appointments.doctor_id',COUNT(*) FROM fact_appointments a LEFT JOIN dim_doctor d ON d.doctor_id=a.doctor_id WHERE d.doctor_id IS NULL
UNION ALL SELECT 'appointments.department_id',COUNT(*) FROM fact_appointments a LEFT JOIN dim_department d ON d.department_id=a.department_id WHERE d.department_id IS NULL
UNION ALL SELECT 'appointments.date_key',COUNT(*) FROM fact_appointments a LEFT JOIN dim_date d ON d.date_key=a.date_key WHERE d.date_key IS NULL
UNION ALL SELECT 'opd.diagnosis_id',COUNT(*) FROM fact_opd_visits o LEFT JOIN dim_diagnosis d ON d.diagnosis_id=o.diagnosis_id WHERE d.diagnosis_id IS NULL
UNION ALL SELECT 'billing.payment_mode_id',COUNT(*) FROM fact_billing b LEFT JOIN dim_payment_mode p ON p.payment_mode_id=b.payment_mode_id WHERE p.payment_mode_id IS NULL
UNION ALL SELECT 'pharmacy.medicine_id',COUNT(*) FROM fact_pharmacy f LEFT JOIN dim_medicine m ON m.medicine_id=f.medicine_id WHERE m.medicine_id IS NULL
UNION ALL SELECT 'lab.test_id',COUNT(*) FROM fact_lab_orders l LEFT JOIN dim_lab_test t ON t.test_id=l.test_id WHERE t.test_id IS NULL;

/* 6. Business rule checks */
SELECT 'negative billing amounts' check_name,COUNT(*) invalid_rows FROM fact_billing WHERE total_amount<0 OR discount_amount<0 OR tax_amount<0 OR payable_amount<0
UNION ALL SELECT 'negative consultation fees',COUNT(*) FROM dim_doctor WHERE consultation_fee<0
UNION ALL SELECT 'invalid patient dates',COUNT(*) FROM dim_patient WHERE date_of_birth>registration_date
UNION ALL SELECT 'invalid doctor dates',COUNT(*) FROM dim_doctor WHERE date_of_birth>=joining_date
UNION ALL SELECT 'invalid ratings',COUNT(*) FROM fact_patient_feedback WHERE rating_overall NOT BETWEEN 1 AND 5 OR rating_cleanliness NOT BETWEEN 1 AND 5 OR rating_staff_behavior NOT BETWEEN 1 AND 5 OR rating_doctor_consultation NOT BETWEEN 1 AND 5
UNION ALL SELECT 'invalid waiting time',COUNT(*) FROM fact_waiting_time WHERE waiting_duration_minutes<0
UNION ALL SELECT 'invalid pharmacy totals',COUNT(*) FROM fact_pharmacy WHERE ABS(total_price-(quantity*unit_price))>0.01;

/* 7. Billing calculation check */
SELECT billing_id,total_amount,discount_amount,tax_amount,payable_amount,ROUND(total_amount-discount_amount+tax_amount,2) expected_payable FROM fact_billing WHERE ABS(payable_amount-(total_amount-discount_amount+tax_amount))>0.01;

/* 8. Bed occupancy consistency */
SELECT occupancy_id FROM fact_bed_occupancy WHERE (is_occupied=TRUE AND patient_id IS NULL) OR (is_occupied=FALSE AND patient_id IS NOT NULL);

/* 9. Date dimension */
SELECT CASE WHEN COUNT(*)=366 AND MIN(full_date)='2024-01-01' AND MAX(full_date)='2024-12-31' THEN 'PASS' ELSE 'FAIL' END validation_status,COUNT(*) rows_loaded,MIN(full_date) min_date,MAX(full_date) max_date FROM dim_date;

/* 10. Overall validation summary */
SELECT CASE WHEN
 (SELECT COUNT(*) FROM dim_department)>0 AND (SELECT COUNT(*) FROM dim_patient)>0 AND (SELECT COUNT(*) FROM dim_doctor)>0 AND
 (SELECT COUNT(*) FROM dim_date)=366 AND
 (SELECT COUNT(*) FROM (SELECT patient_code FROM dim_patient GROUP BY patient_code HAVING COUNT(*)>1) d)=0 AND
 (SELECT COUNT(*) FROM (SELECT doctor_code FROM dim_doctor GROUP BY doctor_code HAVING COUNT(*)>1) d)=0 AND
 (SELECT COUNT(*) FROM fact_billing WHERE total_amount<0 OR discount_amount<0 OR tax_amount<0 OR payable_amount<0)=0 AND
 (SELECT COUNT(*) FROM fact_pharmacy WHERE ABS(total_price-(quantity*unit_price))>0.01)=0
 THEN 'PASS' ELSE 'FAIL' END overall_validation_status;
