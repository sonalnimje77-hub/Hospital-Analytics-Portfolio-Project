/*==============================================================================
 File: 07_Stored_Procedures.sql - management KPI procedures
==============================================================================*/
USE hospital_analytics_db;
DROP PROCEDURE IF EXISTS sp_hospital_kpi_summary;
DROP PROCEDURE IF EXISTS sp_patient_summary;
DROP PROCEDURE IF EXISTS sp_doctor_performance;
DROP PROCEDURE IF EXISTS sp_department_performance;
DROP PROCEDURE IF EXISTS sp_daily_revenue;
DROP PROCEDURE IF EXISTS sp_monthly_revenue;
DROP PROCEDURE IF EXISTS sp_appointment_summary;
DROP PROCEDURE IF EXISTS sp_opd_summary;
DROP PROCEDURE IF EXISTS sp_ipd_summary;
DROP PROCEDURE IF EXISTS sp_waiting_time_summary;
DROP PROCEDURE IF EXISTS sp_patient_satisfaction;
DROP PROCEDURE IF EXISTS sp_insurance_claim_summary;
DROP PROCEDURE IF EXISTS sp_pharmacy_summary;
DROP PROCEDURE IF EXISTS sp_lab_summary;
DROP PROCEDURE IF EXISTS sp_bed_occupancy_summary;
DROP PROCEDURE IF EXISTS sp_date_range_revenue;
DELIMITER $$
CREATE PROCEDURE sp_hospital_kpi_summary()
BEGIN
 SELECT (SELECT COUNT(*) FROM dim_patient) total_patients,(SELECT COUNT(*) FROM dim_doctor WHERE doctor_status='Active') active_doctors,(SELECT COUNT(*) FROM fact_appointments) total_appointments,(SELECT ROUND(SUM(payable_amount),2) FROM fact_billing) total_revenue,(SELECT ROUND(AVG(rating_overall),2) FROM fact_patient_feedback) avg_patient_rating,(SELECT ROUND(AVG(waiting_duration_minutes),2) FROM fact_waiting_time) avg_waiting_minutes;
END$$
CREATE PROCEDURE sp_patient_summary()
BEGIN SELECT p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,p.gender,p.city,p.patient_status,COUNT(DISTINCT a.appointment_id) appointments,COUNT(DISTINCT o.opd_visit_id) opd_visits FROM dim_patient p LEFT JOIN fact_appointments a ON a.patient_id=p.patient_id LEFT JOIN fact_opd_visits o ON o.patient_id=p.patient_id GROUP BY p.patient_id ORDER BY appointments DESC; END$$
CREATE PROCEDURE sp_doctor_performance()
BEGIN SELECT d.doctor_id,d.doctor_code,CONCAT(d.first_name,' ',d.last_name) doctor_name,dep.department_name,COUNT(a.appointment_id) appointments,ROUND(AVG(a.waiting_time_minutes),2) avg_wait,ROUND(AVG(f.rating_doctor_consultation),2) avg_rating FROM dim_doctor d JOIN dim_department dep ON dep.department_id=d.department_id LEFT JOIN fact_appointments a ON a.doctor_id=d.doctor_id LEFT JOIN fact_patient_feedback f ON f.doctor_id=d.doctor_id GROUP BY d.doctor_id ORDER BY appointments DESC; END$$
CREATE PROCEDURE sp_department_performance()
BEGIN SELECT dep.department_id,dep.department_name,COUNT(DISTINCT a.appointment_id) appointments,COUNT(DISTINCT o.opd_visit_id) opd_visits,ROUND(SUM(o.consultation_charge),2) opd_revenue,ROUND(AVG(f.rating_overall),2) avg_rating FROM dim_department dep LEFT JOIN fact_appointments a ON a.department_id=dep.department_id LEFT JOIN fact_opd_visits o ON o.department_id=dep.department_id LEFT JOIN fact_patient_feedback f ON f.department_id=dep.department_id GROUP BY dep.department_id ORDER BY opd_revenue DESC; END$$
CREATE PROCEDURE sp_daily_revenue()
BEGIN SELECT d.full_date,ROUND(SUM(b.payable_amount),2) revenue FROM fact_billing b JOIN dim_date d ON d.date_key=b.date_key GROUP BY d.full_date ORDER BY d.full_date; END$$
CREATE PROCEDURE sp_monthly_revenue()
BEGIN SELECT d.year_number,d.month_number,d.month_name,ROUND(SUM(b.payable_amount),2) revenue FROM fact_billing b JOIN dim_date d ON d.date_key=b.date_key GROUP BY d.year_number,d.month_number,d.month_name ORDER BY d.year_number,d.month_number; END$$
CREATE PROCEDURE sp_appointment_summary()
BEGIN SELECT status,COUNT(*) appointment_count,ROUND(AVG(waiting_time_minutes),2) avg_wait FROM fact_appointments GROUP BY status; END$$
CREATE PROCEDURE sp_opd_summary()
BEGIN SELECT dep.department_name,COUNT(*) visits,ROUND(SUM(o.consultation_charge),2) revenue FROM fact_opd_visits o JOIN dim_department dep ON dep.department_id=o.department_id GROUP BY dep.department_id ORDER BY revenue DESC; END$$
CREATE PROCEDURE sp_ipd_summary()
BEGIN SELECT w.ward_name,COUNT(*) admissions,SUM(i.discharge_status='Discharged') discharged FROM fact_ipd_admissions i JOIN dim_ward w ON w.ward_id=i.ward_id GROUP BY w.ward_id ORDER BY admissions DESC; END$$
CREATE PROCEDURE sp_waiting_time_summary()
BEGIN SELECT dep.department_name,ROUND(AVG(w.waiting_duration_minutes),2) avg_wait,MAX(w.waiting_duration_minutes) max_wait FROM fact_waiting_time w JOIN dim_department dep ON dep.department_id=w.department_id GROUP BY dep.department_id ORDER BY avg_wait DESC; END$$
CREATE PROCEDURE sp_patient_satisfaction()
BEGIN SELECT dep.department_name,ROUND(AVG(f.rating_overall),2) avg_rating,COUNT(*) responses FROM fact_patient_feedback f JOIN dim_department dep ON dep.department_id=f.department_id GROUP BY dep.department_id ORDER BY avg_rating DESC; END$$
CREATE PROCEDURE sp_insurance_claim_summary()
BEGIN SELECT i.company_name,c.claim_status,COUNT(*) claims,ROUND(SUM(c.claim_amount),2) claimed,ROUND(SUM(c.approved_amount),2) approved FROM fact_insurance_claims c JOIN dim_insurance i ON i.insurance_id=c.insurance_id GROUP BY i.insurance_id,c.claim_status ORDER BY approved DESC; END$$
CREATE PROCEDURE sp_pharmacy_summary()
BEGIN SELECT m.medicine_name,SUM(f.quantity) units_sold,ROUND(SUM(f.total_price),2) sales FROM fact_pharmacy f JOIN dim_medicine m ON m.medicine_id=f.medicine_id GROUP BY m.medicine_id ORDER BY sales DESC; END$$
CREATE PROCEDURE sp_lab_summary()
BEGIN SELECT t.test_name,COUNT(*) orders,SUM(l.result_status<>'Normal') abnormal_count FROM fact_lab_orders l JOIN dim_lab_test t ON t.test_id=l.test_id GROUP BY t.test_id ORDER BY orders DESC; END$$
CREATE PROCEDURE sp_bed_occupancy_summary()
BEGIN SELECT d.full_date,ROUND(100*AVG(o.is_occupied),2) occupancy_percentage FROM fact_bed_occupancy o JOIN dim_date d ON d.date_key=o.date_key GROUP BY d.full_date ORDER BY d.full_date; END$$
CREATE PROCEDURE sp_date_range_revenue(IN p_start_date DATE, IN p_end_date DATE)
BEGIN SELECT ROUND(SUM(b.payable_amount),2) revenue,COUNT(*) bills FROM fact_billing b JOIN dim_date d ON d.date_key=b.date_key WHERE d.full_date BETWEEN p_start_date AND p_end_date; END$$
DELIMITER ;

SHOW PROCEDURE STATUS WHERE Db=DATABASE();
