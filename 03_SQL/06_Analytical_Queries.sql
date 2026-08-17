/*==============================================================================
 File: 06_Analytical_Queries.sql - reusable analyst queries
==============================================================================*/
USE hospital_analytics_db;

/* Patient and doctor master analysis */
SELECT gender,COUNT(*) patient_count FROM dim_patient GROUP BY gender ORDER BY patient_count DESC;
SELECT blood_group,COUNT(*) patient_count FROM dim_patient GROUP BY blood_group ORDER BY patient_count DESC;
SELECT d.department_name,COUNT(doc.doctor_id) doctor_count,ROUND(AVG(doc.consultation_fee),2) avg_fee FROM dim_department d LEFT JOIN dim_doctor doc ON doc.department_id=d.department_id GROUP BY d.department_id,d.department_name ORDER BY doctor_count DESC;

/* Appointment KPIs */
SELECT status,COUNT(*) appointment_count,ROUND(AVG(appointment_fee),2) avg_fee FROM fact_appointments GROUP BY status ORDER BY appointment_count DESC;
SELECT dep.department_name,COUNT(*) appointments,ROUND(AVG(a.waiting_time_minutes),2) avg_wait FROM fact_appointments a JOIN dim_department dep ON dep.department_id=a.department_id GROUP BY dep.department_id,dep.department_name ORDER BY appointments DESC;
SELECT d.full_date,COUNT(*) appointments FROM fact_appointments a JOIN dim_date d ON d.date_key=a.date_key GROUP BY d.full_date ORDER BY d.full_date;

/* OPD */
SELECT dep.department_name,COUNT(*) visits,ROUND(SUM(o.consultation_charge),2) revenue,ROUND(AVG(o.consultation_charge),2) avg_charge FROM fact_opd_visits o JOIN dim_department dep ON dep.department_id=o.department_id GROUP BY dep.department_id,dep.department_name ORDER BY revenue DESC;
SELECT diag.diagnosis_name,COUNT(*) cases FROM fact_opd_visits o JOIN dim_diagnosis diag ON diag.diagnosis_id=o.diagnosis_id GROUP BY diag.diagnosis_id,diag.diagnosis_name ORDER BY cases DESC;

/* IPD and occupancy */
SELECT w.ward_name,COUNT(*) admissions FROM fact_ipd_admissions i JOIN dim_ward w ON w.ward_id=i.ward_id GROUP BY w.ward_id,w.ward_name ORDER BY admissions DESC;
SELECT d.full_date,ROUND(100*AVG(o.is_occupied),2) occupancy_percentage FROM fact_bed_occupancy o JOIN dim_date d ON d.date_key=o.date_key GROUP BY d.full_date ORDER BY d.full_date;

/* Revenue */
SELECT d.year_number,d.month_number,d.month_name,ROUND(SUM(b.payable_amount),2) revenue FROM fact_billing b JOIN dim_date d ON d.date_key=b.date_key GROUP BY d.year_number,d.month_number,d.month_name ORDER BY d.year_number,d.month_number;
SELECT pm.payment_mode_name,COUNT(*) bills,ROUND(SUM(b.payable_amount),2) revenue FROM fact_billing b JOIN dim_payment_mode pm ON pm.payment_mode_id=b.payment_mode_id GROUP BY pm.payment_mode_id,pm.payment_mode_name ORDER BY revenue DESC;

/* Claims */
SELECT i.company_name,COUNT(*) claims,ROUND(SUM(c.claim_amount),2) claimed,ROUND(SUM(c.approved_amount),2) approved FROM fact_insurance_claims c JOIN dim_insurance i ON i.insurance_id=c.insurance_id GROUP BY i.insurance_id,i.company_name ORDER BY approved DESC;

/* Pharmacy and lab */
SELECT m.medicine_name,SUM(f.quantity) units_sold,ROUND(SUM(f.total_price),2) sales FROM fact_pharmacy f JOIN dim_medicine m ON m.medicine_id=f.medicine_id GROUP BY m.medicine_id,m.medicine_name ORDER BY sales DESC;
SELECT t.test_name,COUNT(*) orders FROM fact_lab_orders l JOIN dim_lab_test t ON t.test_id=l.test_id GROUP BY t.test_id,t.test_name ORDER BY orders DESC;

/* Patient experience */
SELECT ROUND(AVG(rating_overall),2) overall_rating,ROUND(AVG(rating_staff_behavior),2) staff_rating,ROUND(AVG(rating_doctor_consultation),2) doctor_rating FROM fact_patient_feedback;
SELECT dep.department_name,ROUND(AVG(f.rating_overall),2) avg_rating,COUNT(*) feedback_count FROM fact_patient_feedback f JOIN dim_department dep ON dep.department_id=f.department_id GROUP BY dep.department_id,dep.department_name ORDER BY avg_rating DESC;
SELECT dep.department_name,ROUND(AVG(w.waiting_duration_minutes),2) avg_wait FROM fact_waiting_time w JOIN dim_department dep ON dep.department_id=w.department_id GROUP BY dep.department_id,dep.department_name ORDER BY avg_wait DESC;

/* Emergency, surgery, complaints */
SELECT emergency_severity,COUNT(*) cases FROM fact_emergency GROUP BY emergency_severity ORDER BY cases DESC;
SELECT outcome,COUNT(*) surgeries FROM fact_surgeries GROUP BY outcome ORDER BY surgeries DESC;
SELECT status,COUNT(*) complaints FROM fact_complaints GROUP BY status ORDER BY complaints DESC;
