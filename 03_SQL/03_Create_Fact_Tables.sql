/*==============================================================================
 Hospital Analytics Portfolio Project
 File: 03_Create_Fact_Tables.sql
 MySQL 8.0 - 15 fact tables
==============================================================================*/
USE hospital_analytics_db;
SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS fact_bed_occupancy;
DROP TABLE IF EXISTS fact_discharge;
DROP TABLE IF EXISTS fact_radiology;
DROP TABLE IF EXISTS fact_surgeries;
DROP TABLE IF EXISTS fact_emergency;
DROP TABLE IF EXISTS fact_complaints;
DROP TABLE IF EXISTS fact_patient_feedback;
DROP TABLE IF EXISTS fact_waiting_time;
DROP TABLE IF EXISTS fact_lab_orders;
DROP TABLE IF EXISTS fact_pharmacy;
DROP TABLE IF EXISTS fact_insurance_claims;
DROP TABLE IF EXISTS fact_billing;
DROP TABLE IF EXISTS fact_ipd_admissions;
DROP TABLE IF EXISTS fact_opd_visits;
DROP TABLE IF EXISTS fact_appointments;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE fact_appointments (
 appointment_id INT AUTO_INCREMENT PRIMARY KEY,
 patient_id INT NOT NULL, doctor_id INT NOT NULL, department_id INT NOT NULL, date_key INT NOT NULL,
 appointment_time TIME NOT NULL, status ENUM('Scheduled','Completed','No-Show','Cancelled') NOT NULL DEFAULT 'Scheduled',
 appointment_fee DECIMAL(10,2) NOT NULL DEFAULT 0, waiting_time_minutes INT NOT NULL DEFAULT 0,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK (appointment_fee>=0), CHECK (waiting_time_minutes>=0),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id),
 FOREIGN KEY(department_id) REFERENCES dim_department(department_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_opd_visits (
 opd_visit_id INT AUTO_INCREMENT PRIMARY KEY,
 patient_id INT NOT NULL, doctor_id INT NOT NULL, department_id INT NOT NULL, date_key INT NOT NULL,
 symptoms VARCHAR(255) NOT NULL, vitals_bp VARCHAR(20) NOT NULL, vitals_temperature DECIMAL(5,2) NOT NULL,
 vitals_pulse INT NOT NULL, consultation_charge DECIMAL(10,2) NOT NULL DEFAULT 0, diagnosis_id INT NOT NULL,
 CHECK(vitals_temperature>0), CHECK(vitals_pulse>0), CHECK(consultation_charge>=0),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id),
 FOREIGN KEY(department_id) REFERENCES dim_department(department_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key),
 FOREIGN KEY(diagnosis_id) REFERENCES dim_diagnosis(diagnosis_id)
) ENGINE=InnoDB;

CREATE TABLE fact_ipd_admissions (
 admission_id INT AUTO_INCREMENT PRIMARY KEY,
 patient_id INT NOT NULL, doctor_id INT NOT NULL, ward_id INT NOT NULL, bed_id INT NOT NULL,
 admission_date_key INT NOT NULL, admission_time TIME NOT NULL, discharge_date_key INT NULL,
 reason_for_admission VARCHAR(255) NOT NULL,
 discharge_status ENUM('Admitted','Discharged','Transferred','Deceased') NOT NULL DEFAULT 'Admitted',
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id),
 FOREIGN KEY(ward_id) REFERENCES dim_ward(ward_id), FOREIGN KEY(bed_id) REFERENCES dim_bed(bed_id),
 FOREIGN KEY(admission_date_key) REFERENCES dim_date(date_key), FOREIGN KEY(discharge_date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_billing (
 billing_id INT AUTO_INCREMENT PRIMARY KEY,
 patient_id INT NOT NULL, date_key INT NOT NULL, admission_id INT NULL, opd_visit_id INT NULL,
 room_charges DECIMAL(12,2) NOT NULL DEFAULT 0, treatment_charges DECIMAL(12,2) NOT NULL DEFAULT 0,
 pharmacy_charges DECIMAL(12,2) NOT NULL DEFAULT 0, lab_charges DECIMAL(12,2) NOT NULL DEFAULT 0,
 total_amount DECIMAL(12,2) NOT NULL DEFAULT 0, discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0, payable_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 payment_mode_id INT NOT NULL, payment_status ENUM('Paid','Unpaid','Partially Paid') NOT NULL DEFAULT 'Paid',
 CHECK(total_amount>=0), CHECK(discount_amount>=0), CHECK(tax_amount>=0), CHECK(payable_amount>=0),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key),
 FOREIGN KEY(admission_id) REFERENCES fact_ipd_admissions(admission_id), FOREIGN KEY(opd_visit_id) REFERENCES fact_opd_visits(opd_visit_id),
 FOREIGN KEY(payment_mode_id) REFERENCES dim_payment_mode(payment_mode_id)
) ENGINE=InnoDB;

CREATE TABLE fact_insurance_claims (
 claim_id INT AUTO_INCREMENT PRIMARY KEY, billing_id INT NOT NULL, insurance_id INT NOT NULL,
 claim_amount DECIMAL(12,2) NOT NULL DEFAULT 0, approved_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
 claim_status ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending', claim_date_key INT NOT NULL,
 CHECK(claim_amount>=0), CHECK(approved_amount>=0), CHECK(approved_amount<=claim_amount),
 FOREIGN KEY(billing_id) REFERENCES fact_billing(billing_id), FOREIGN KEY(insurance_id) REFERENCES dim_insurance(insurance_id),
 FOREIGN KEY(claim_date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_pharmacy (
 pharmacy_sale_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, medicine_id INT NOT NULL, date_key INT NOT NULL,
 quantity INT NOT NULL, unit_price DECIMAL(10,2) NOT NULL, total_price DECIMAL(12,2) NOT NULL, prescription_id INT NULL,
 CHECK(quantity>0), CHECK(unit_price>=0), CHECK(total_price>=0),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(medicine_id) REFERENCES dim_medicine(medicine_id),
 FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_lab_orders (
 lab_order_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, doctor_id INT NOT NULL, test_id INT NOT NULL, date_key INT NOT NULL,
 test_result VARCHAR(100) NOT NULL, result_status ENUM('Normal','Abnormal','High','Low') NOT NULL DEFAULT 'Normal',
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id),
 FOREIGN KEY(test_id) REFERENCES dim_lab_test(test_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_waiting_time (
 waiting_time_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, department_id INT NOT NULL, doctor_id INT NOT NULL, date_key INT NOT NULL,
 check_in_time TIME NOT NULL, consultation_start_time TIME NOT NULL, waiting_duration_minutes INT NOT NULL,
 CHECK(waiting_duration_minutes>=0),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(department_id) REFERENCES dim_department(department_id),
 FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_patient_feedback (
 feedback_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, doctor_id INT NOT NULL, department_id INT NOT NULL, date_key INT NOT NULL,
 rating_cleanliness INT NOT NULL, rating_staff_behavior INT NOT NULL, rating_doctor_consultation INT NOT NULL, rating_overall INT NOT NULL, comments VARCHAR(500) NOT NULL,
 CHECK(rating_cleanliness BETWEEN 1 AND 5), CHECK(rating_staff_behavior BETWEEN 1 AND 5), CHECK(rating_doctor_consultation BETWEEN 1 AND 5), CHECK(rating_overall BETWEEN 1 AND 5),
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id), FOREIGN KEY(department_id) REFERENCES dim_department(department_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_complaints (
 complaint_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, date_key INT NOT NULL, department_id INT NOT NULL,
 complaint_type VARCHAR(100) NOT NULL, description VARCHAR(500) NOT NULL, status ENUM('Open','Resolved','Escalated') NOT NULL DEFAULT 'Open',
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key), FOREIGN KEY(department_id) REFERENCES dim_department(department_id)
) ENGINE=InnoDB;

CREATE TABLE fact_emergency (
 emergency_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, date_key INT NOT NULL,
 emergency_severity ENUM('Red','Yellow','Green') NOT NULL, arrival_mode ENUM('Ambulance','Walk-in','Police','Other') NOT NULL,
 triage_nurse VARCHAR(100) NOT NULL, admission_required BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_surgeries (
 surgery_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, doctor_id INT NOT NULL, date_key INT NOT NULL,
 surgery_type VARCHAR(150) NOT NULL, surgery_duration_minutes INT NOT NULL, outcome ENUM('Success','Complications','Death') NOT NULL,
 CHECK(surgery_duration_minutes>0), FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_radiology (
 radiology_id INT AUTO_INCREMENT PRIMARY KEY, patient_id INT NOT NULL, doctor_id INT NOT NULL, date_key INT NOT NULL,
 modality ENUM('X-Ray','MRI','CT-Scan','Ultrasound') NOT NULL, scan_area VARCHAR(100) NOT NULL, report_summary VARCHAR(500) NOT NULL,
 FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(doctor_id) REFERENCES dim_doctor(doctor_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_discharge (
 discharge_id INT AUTO_INCREMENT PRIMARY KEY, admission_id INT NOT NULL, patient_id INT NOT NULL, date_key INT NOT NULL,
 discharge_condition VARCHAR(100) NOT NULL, follow_up_required BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY(admission_id) REFERENCES fact_ipd_admissions(admission_id), FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key)
) ENGINE=InnoDB;

CREATE TABLE fact_bed_occupancy (
 occupancy_id INT AUTO_INCREMENT PRIMARY KEY, ward_id INT NOT NULL, bed_id INT NOT NULL, date_key INT NOT NULL,
 is_occupied BOOLEAN NOT NULL DEFAULT FALSE, patient_id INT NULL,
 FOREIGN KEY(ward_id) REFERENCES dim_ward(ward_id), FOREIGN KEY(bed_id) REFERENCES dim_bed(bed_id), FOREIGN KEY(date_key) REFERENCES dim_date(date_key), FOREIGN KEY(patient_id) REFERENCES dim_patient(patient_id)
) ENGINE=InnoDB;

SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME LIKE 'fact_%' ORDER BY TABLE_NAME;
