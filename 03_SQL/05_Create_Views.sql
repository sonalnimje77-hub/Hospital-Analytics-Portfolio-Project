/*==============================================================================
 File: 05_Create_Views.sql - reporting views
==============================================================================*/
USE hospital_analytics_db;
DROP VIEW IF EXISTS vw_appointment_summary,vw_opd_visit_summary,vw_ipd_admission_summary,vw_billing_summary,vw_insurance_claim_summary,vw_pharmacy_sales_summary,vw_lab_order_summary,vw_waiting_time_summary,vw_patient_feedback_summary,vw_complaint_summary,vw_emergency_summary,vw_surgery_summary,vw_radiology_summary,vw_discharge_summary,vw_bed_occupancy_summary;

CREATE VIEW vw_appointment_summary AS
SELECT a.appointment_id,a.date_key,d.full_date,p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,doc.doctor_code,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,dep.department_name,a.appointment_time,a.status,a.appointment_fee,a.waiting_time_minutes
FROM fact_appointments a JOIN dim_patient p ON p.patient_id=a.patient_id JOIN dim_doctor doc ON doc.doctor_id=a.doctor_id JOIN dim_department dep ON dep.department_id=a.department_id JOIN dim_date d ON d.date_key=a.date_key;

CREATE VIEW vw_opd_visit_summary AS
SELECT o.opd_visit_id,d.full_date,p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,dep.department_name,diag.diagnosis_name,o.symptoms,o.vitals_bp,o.vitals_temperature,o.vitals_pulse,o.consultation_charge
FROM fact_opd_visits o JOIN dim_patient p ON p.patient_id=o.patient_id JOIN dim_doctor doc ON doc.doctor_id=o.doctor_id JOIN dim_department dep ON dep.department_id=o.department_id JOIN dim_diagnosis diag ON diag.diagnosis_id=o.diagnosis_id JOIN dim_date d ON d.date_key=o.date_key;

CREATE VIEW vw_ipd_admission_summary AS
SELECT i.admission_id,ad.full_date admission_date,dd.full_date discharge_date,p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,w.ward_name,b.bed_code,i.admission_time,i.reason_for_admission,i.discharge_status
FROM fact_ipd_admissions i JOIN dim_patient p ON p.patient_id=i.patient_id JOIN dim_doctor doc ON doc.doctor_id=i.doctor_id JOIN dim_ward w ON w.ward_id=i.ward_id JOIN dim_bed b ON b.bed_id=i.bed_id JOIN dim_date ad ON ad.date_key=i.admission_date_key LEFT JOIN dim_date dd ON dd.date_key=i.discharge_date_key;

CREATE VIEW vw_billing_summary AS
SELECT b.billing_id,d.full_date,p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,b.total_amount,b.discount_amount,b.tax_amount,b.payable_amount,pm.payment_mode_name,b.payment_status
FROM fact_billing b JOIN dim_patient p ON p.patient_id=b.patient_id JOIN dim_date d ON d.date_key=b.date_key JOIN dim_payment_mode pm ON pm.payment_mode_id=b.payment_mode_id;

CREATE VIEW vw_insurance_claim_summary AS
SELECT c.claim_id,d.full_date,c.billing_id,i.insurance_code,i.company_name,c.claim_amount,c.approved_amount,c.claim_status
FROM fact_insurance_claims c JOIN dim_insurance i ON i.insurance_id=c.insurance_id JOIN dim_date d ON d.date_key=c.claim_date_key;

CREATE VIEW vw_pharmacy_sales_summary AS
SELECT f.pharmacy_sale_id,d.full_date,p.patient_code,m.medicine_name,f.quantity,f.unit_price,f.total_price
FROM fact_pharmacy f JOIN dim_patient p ON p.patient_id=f.patient_id JOIN dim_medicine m ON m.medicine_id=f.medicine_id JOIN dim_date d ON d.date_key=f.date_key;

CREATE VIEW vw_lab_order_summary AS
SELECT l.lab_order_id,d.full_date,p.patient_code,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,t.test_name,l.test_result,l.result_status
FROM fact_lab_orders l JOIN dim_patient p ON p.patient_id=l.patient_id JOIN dim_doctor doc ON doc.doctor_id=l.doctor_id JOIN dim_lab_test t ON t.test_id=l.test_id JOIN dim_date d ON d.date_key=l.date_key;

CREATE VIEW vw_waiting_time_summary AS
SELECT w.waiting_time_id,d.full_date,p.patient_code,dep.department_name,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,w.check_in_time,w.consultation_start_time,w.waiting_duration_minutes
FROM fact_waiting_time w JOIN dim_patient p ON p.patient_id=w.patient_id JOIN dim_department dep ON dep.department_id=w.department_id JOIN dim_doctor doc ON doc.doctor_id=w.doctor_id JOIN dim_date d ON d.date_key=w.date_key;

CREATE VIEW vw_patient_feedback_summary AS
SELECT f.feedback_id,d.full_date,p.patient_code,dep.department_name,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,f.rating_cleanliness,f.rating_staff_behavior,f.rating_doctor_consultation,f.rating_overall,f.comments
FROM fact_patient_feedback f JOIN dim_patient p ON p.patient_id=f.patient_id JOIN dim_doctor doc ON doc.doctor_id=f.doctor_id JOIN dim_department dep ON dep.department_id=f.department_id JOIN dim_date d ON d.date_key=f.date_key;

CREATE VIEW vw_complaint_summary AS
SELECT c.complaint_id,d.full_date,p.patient_code,dep.department_name,c.complaint_type,c.description,c.status
FROM fact_complaints c JOIN dim_patient p ON p.patient_id=c.patient_id JOIN dim_department dep ON dep.department_id=c.department_id JOIN dim_date d ON d.date_key=c.date_key;

CREATE VIEW vw_emergency_summary AS
SELECT e.emergency_id,d.full_date,p.patient_code,e.emergency_severity,e.arrival_mode,e.triage_nurse,e.admission_required
FROM fact_emergency e JOIN dim_patient p ON p.patient_id=e.patient_id JOIN dim_date d ON d.date_key=e.date_key;

CREATE VIEW vw_surgery_summary AS
SELECT s.surgery_id,d.full_date,p.patient_code,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,s.surgery_type,s.surgery_duration_minutes,s.outcome
FROM fact_surgeries s JOIN dim_patient p ON p.patient_id=s.patient_id JOIN dim_doctor doc ON doc.doctor_id=s.doctor_id JOIN dim_date d ON d.date_key=s.date_key;

CREATE VIEW vw_radiology_summary AS
SELECT r.radiology_id,d.full_date,p.patient_code,CONCAT(doc.first_name,' ',doc.last_name) doctor_name,r.modality,r.scan_area,r.report_summary
FROM fact_radiology r JOIN dim_patient p ON p.patient_id=r.patient_id JOIN dim_doctor doc ON doc.doctor_id=r.doctor_id JOIN dim_date d ON d.date_key=r.date_key;

CREATE VIEW vw_discharge_summary AS
SELECT x.discharge_id,d.full_date,x.admission_id,p.patient_code,CONCAT(p.first_name,' ',p.last_name) patient_name,x.discharge_condition,x.follow_up_required
FROM fact_discharge x JOIN dim_patient p ON p.patient_id=x.patient_id JOIN dim_date d ON d.date_key=x.date_key;

CREATE VIEW vw_bed_occupancy_summary AS
SELECT o.occupancy_id,d.full_date,w.ward_name,b.bed_code,b.room_number,b.bed_number,o.is_occupied,p.patient_code
FROM fact_bed_occupancy o JOIN dim_ward w ON w.ward_id=o.ward_id JOIN dim_bed b ON b.bed_id=o.bed_id JOIN dim_date d ON d.date_key=o.date_key LEFT JOIN dim_patient p ON p.patient_id=o.patient_id;

SHOW FULL TABLES WHERE Table_type='VIEW';
