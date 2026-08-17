/*==============================================================================
 File: 10_Database_Maintenance.sql - monitoring and non-destructive maintenance
==============================================================================*/
USE hospital_analytics_db;
SELECT DATABASE() database_name,NOW() maintenance_started;
SELECT table_name,table_rows,ROUND((data_length+index_length)/1024/1024,2) total_size_mb FROM information_schema.tables WHERE table_schema=DATABASE() ORDER BY total_size_mb DESC;

ANALYZE TABLE dim_department,dim_insurance,dim_payment_mode,dim_ward,dim_bed,dim_doctor,dim_patient,dim_diagnosis,dim_medicine,dim_lab_test,dim_date;
ANALYZE TABLE fact_appointments,fact_opd_visits,fact_ipd_admissions,fact_billing,fact_insurance_claims,fact_pharmacy,fact_lab_orders,fact_waiting_time,fact_patient_feedback,fact_complaints,fact_emergency,fact_surgeries,fact_radiology,fact_discharge,fact_bed_occupancy;

/* Current table row counts */
SELECT table_name,table_rows FROM information_schema.tables WHERE table_schema=DATABASE() ORDER BY table_name;

/* Billing health */
SELECT COUNT(*) bills,ROUND(COALESCE(SUM(payable_amount),0),2) payable_amount,ROUND(COALESCE(AVG(payable_amount),0),2) average_bill FROM fact_billing;
/* Bed health */
SELECT COUNT(*) total_beds,SUM(bed_status='Occupied') occupied,SUM(bed_status='Available') available,SUM(bed_status='Reserved') reserved,SUM(bed_status='Maintenance') maintenance FROM dim_bed;
/* Appointment health */
SELECT status,COUNT(*) row_count FROM fact_appointments GROUP BY status;
/* Feedback health */
SELECT ROUND(COALESCE(AVG(rating_overall),0),2) average_rating,COUNT(*) feedback_count FROM fact_patient_feedback;

SELECT 'PASS - maintenance completed' maintenance_status,NOW() maintenance_completed;
