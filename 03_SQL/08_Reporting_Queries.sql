/*==============================================================================
 File: 08_Reporting_Queries.sql - Power BI / management report datasets
==============================================================================*/
USE hospital_analytics_db;

/* Executive KPI */
SELECT (SELECT COUNT(*) FROM dim_patient) total_patients,(SELECT COUNT(*) FROM dim_doctor WHERE doctor_status='Active') active_doctors,(SELECT COUNT(*) FROM dim_department WHERE department_status='Active') active_departments,(SELECT COUNT(*) FROM fact_appointments) appointments,(SELECT COUNT(*) FROM fact_ipd_admissions) admissions,(SELECT ROUND(COALESCE(SUM(payable_amount),0),2) FROM fact_billing) revenue,(SELECT ROUND(COALESCE(AVG(rating_overall),0),2) FROM fact_patient_feedback) avg_rating;

/* Monthly management report */
SELECT d.year_number,d.month_number,d.month_name,COUNT(DISTINCT a.appointment_id) appointments,COUNT(DISTINCT o.opd_visit_id) opd_visits,COUNT(DISTINCT i.admission_id) admissions,ROUND(COALESCE(SUM(b.payable_amount),0),2) revenue FROM dim_date d LEFT JOIN fact_appointments a ON a.date_key=d.date_key LEFT JOIN fact_opd_visits o ON o.date_key=d.date_key LEFT JOIN fact_ipd_admissions i ON i.admission_date_key=d.date_key LEFT JOIN fact_billing b ON b.date_key=d.date_key GROUP BY d.year_number,d.month_number,d.month_name ORDER BY d.year_number,d.month_number;

/* Department performance */
SELECT dep.department_name,COUNT(DISTINCT a.appointment_id) appointments,COUNT(DISTINCT o.opd_visit_id) opd_visits,ROUND(COALESCE(SUM(o.consultation_charge),0),2) opd_revenue,ROUND(AVG(f.rating_overall),2) avg_rating,ROUND(AVG(w.waiting_duration_minutes),2) avg_wait FROM dim_department dep LEFT JOIN fact_appointments a ON a.department_id=dep.department_id LEFT JOIN fact_opd_visits o ON o.department_id=dep.department_id LEFT JOIN fact_patient_feedback f ON f.department_id=dep.department_id LEFT JOIN fact_waiting_time w ON w.department_id=dep.department_id GROUP BY dep.department_id ORDER BY opd_revenue DESC;

/* Doctor performance */
SELECT doc.doctor_code,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,dep.department_name,COUNT(a.appointment_id) appointments,ROUND(AVG(a.waiting_time_minutes),2) avg_wait,ROUND(AVG(f.rating_doctor_consultation),2) doctor_rating FROM dim_doctor doc JOIN dim_department dep ON dep.department_id=doc.department_id LEFT JOIN fact_appointments a ON a.doctor_id=doc.doctor_id LEFT JOIN fact_patient_feedback f ON f.doctor_id=doc.doctor_id GROUP BY doc.doctor_id ORDER BY appointments DESC;

/* Revenue by payment mode */
SELECT pm.payment_mode_name,COUNT(b.billing_id) bills,ROUND(COALESCE(SUM(b.payable_amount),0),2) revenue FROM dim_payment_mode pm LEFT JOIN fact_billing b ON b.payment_mode_id=pm.payment_mode_id GROUP BY pm.payment_mode_id ORDER BY revenue DESC;

/* Insurance report */
SELECT i.company_name,COUNT(c.claim_id) claims,ROUND(COALESCE(SUM(c.claim_amount),0),2) claimed,ROUND(COALESCE(SUM(c.approved_amount),0),2) approved,ROUND(100*COALESCE(SUM(c.approved_amount),0)/NULLIF(SUM(c.claim_amount),0),2) approval_rate FROM dim_insurance i LEFT JOIN fact_insurance_claims c ON c.insurance_id=i.insurance_id GROUP BY i.insurance_id ORDER BY approved DESC;

/* Bed report */
SELECT w.ward_name,COUNT(b.bed_id) total_beds,SUM(b.bed_status='Occupied') occupied_beds,SUM(b.bed_status='Available') available_beds,ROUND(100*SUM(b.bed_status='Occupied')/NULLIF(COUNT(b.bed_id),0),2) occupancy_rate FROM dim_ward w LEFT JOIN dim_bed b ON b.ward_id=w.ward_id GROUP BY w.ward_id ORDER BY occupancy_rate DESC;

/* Patient experience */
SELECT d.full_date,ROUND(AVG(f.rating_overall),2) avg_rating,ROUND(AVG(f.rating_staff_behavior),2) staff_rating,ROUND(AVG(f.rating_doctor_consultation),2) doctor_rating,COUNT(*) responses FROM fact_patient_feedback f JOIN dim_date d ON d.date_key=f.date_key GROUP BY d.full_date ORDER BY d.full_date;

/* Complaint report */
SELECT d.department_name,c.complaint_type,c.status,COUNT(*) complaint_count FROM fact_complaints c JOIN dim_department d ON d.department_id=c.department_id GROUP BY d.department_id,c.complaint_type,c.status ORDER BY complaint_count DESC;
