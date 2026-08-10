-- Disable foreign key checks for clean execution
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables and database to ensure a clean slate if re-run
DROP DATABASE IF EXISTS hospital_analytics_db;

-- Create Database
CREATE DATABASE hospital_analytics_db;
USE hospital_analytics_db;

-- ============================================================================
-- DIMENSION TABLES
-- ============================================================================

-- 1. Department Dimension
CREATE TABLE dim_department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL UNIQUE DEFAULT 'DEPT-000',
    department_name VARCHAR(100) NOT NULL DEFAULT 'General',
    department_type VARCHAR(50) NOT NULL DEFAULT 'Outpatient',
    building_name VARCHAR(50) NOT NULL DEFAULT 'Main Building',
    head_of_department VARCHAR(100) NOT NULL DEFAULT 'Dr. TBD',
    consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_beds INT NOT NULL DEFAULT 0,
    department_status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

-- 2. Patient Dimension
CREATE TABLE dim_patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(20) NOT NULL UNIQUE DEFAULT 'PAT-000',
    first_name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    last_name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    gender VARCHAR(10) NOT NULL DEFAULT 'Other',
    age INT NOT NULL DEFAULT 0,
    blood_group VARCHAR(10) NOT NULL DEFAULT 'Unknown',
    marital_status VARCHAR(20) NOT NULL DEFAULT 'Unknown',
    city VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    state VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    registration_date DATE NOT NULL DEFAULT '1970-01-01',
    patient_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    insurance_provider VARCHAR(100) NOT NULL DEFAULT 'Self-Pay',
    policy_number VARCHAR(50) NOT NULL DEFAULT 'N/A'
);

-- 3. Doctor Dimension
CREATE TABLE dim_doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_code VARCHAR(20) NOT NULL UNIQUE DEFAULT 'DOC-000',
    first_name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    last_name VARCHAR(50) NOT NULL DEFAULT 'Unknown',
    specialization VARCHAR(100) NOT NULL DEFAULT 'General Practice',
    qualification VARCHAR(100) NOT NULL DEFAULT 'MBBS',
    experience_years INT NOT NULL DEFAULT 0,
    department_id INT NOT NULL DEFAULT 1,
    consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    employment_type VARCHAR(50) NOT NULL DEFAULT 'Full-Time',
    doctor_status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_dim_doctor_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id)
);

-- 4. Ward Dimension
CREATE TABLE dim_ward (
    ward_id INT AUTO_INCREMENT PRIMARY KEY,
    ward_name VARCHAR(50) NOT NULL DEFAULT 'General Ward',
    ward_type VARCHAR(50) NOT NULL DEFAULT 'General',
    department_id INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_dim_ward_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id)
);

-- 5. Bed Dimension
CREATE TABLE dim_bed (
    bed_id INT AUTO_INCREMENT PRIMARY KEY,
    bed_number VARCHAR(20) NOT NULL DEFAULT 'BED-000',
    ward_id INT NOT NULL DEFAULT 1,
    bed_status VARCHAR(20) NOT NULL DEFAULT 'Available',
    CONSTRAINT fk_dim_bed_ward FOREIGN KEY (ward_id) REFERENCES dim_ward(ward_id)
);

-- 6. Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE DEFAULT '1970-01-01',
    day_of_week INT NOT NULL DEFAULT 1,
    day_name VARCHAR(15) NOT NULL DEFAULT 'Monday',
    day_of_month INT NOT NULL DEFAULT 1,
    month_number INT NOT NULL DEFAULT 1,
    month_name VARCHAR(15) NOT NULL DEFAULT 'January',
    quarter INT NOT NULL DEFAULT 1,
    calendar_year INT NOT NULL DEFAULT 1970,
    is_weekend BOOLEAN NOT NULL DEFAULT FALSE
);

-- ============================================================================
-- FACT TABLES
-- ============================================================================

-- 1. Appointments Fact Table
CREATE TABLE fact_appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_code VARCHAR(50) NOT NULL UNIQUE DEFAULT 'APT-000',
    patient_id INT NOT NULL DEFAULT 1,
    doctor_id INT NOT NULL DEFAULT 1,
    department_id INT NOT NULL DEFAULT 1,
    date_key INT NOT NULL DEFAULT 19700101,
    appointment_type VARCHAR(50) NOT NULL DEFAULT 'Scheduled',
    appointment_channel VARCHAR(50) NOT NULL DEFAULT 'In-Person',
    status VARCHAR(50) NOT NULL DEFAULT 'Scheduled',
    consultation_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_fact_appts_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_appts_doctor FOREIGN KEY (doctor_id) REFERENCES dim_doctor(doctor_id),
    CONSTRAINT fk_fact_appts_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
    CONSTRAINT fk_fact_appts_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- 2. Billing Fact Table
CREATE TABLE fact_billing (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL DEFAULT 1,
    department_id INT NOT NULL DEFAULT 1,
    billing_date_key INT NOT NULL DEFAULT 19700101,
    gross_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    net_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Unpaid',
    CONSTRAINT fk_fact_billing_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_billing_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
    CONSTRAINT fk_fact_billing_date FOREIGN KEY (billing_date_key) REFERENCES dim_date(date_key)
);

-- 3. Waiting Time Fact Table
CREATE TABLE fact_waiting_time (
    waiting_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL DEFAULT 1,
    patient_id INT NOT NULL DEFAULT 1,
    doctor_id INT NOT NULL DEFAULT 1,
    department_id INT NOT NULL DEFAULT 1,
    date_key INT NOT NULL DEFAULT 19700101,
    queue_number INT NOT NULL DEFAULT 0,
    check_in_time DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    consultation_start_time DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    consultation_end_time DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    waiting_duration_minutes INT NOT NULL DEFAULT 0,
    consultation_duration_minutes INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_fact_wait_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_wait_doctor FOREIGN KEY (doctor_id) REFERENCES dim_doctor(doctor_id),
    CONSTRAINT fk_fact_wait_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
    CONSTRAINT fk_fact_wait_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- 4. Admissions Fact Table
CREATE TABLE fact_admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_code VARCHAR(50) NOT NULL UNIQUE DEFAULT 'ADM-000',
    patient_id INT NOT NULL DEFAULT 1,
    department_id INT NOT NULL DEFAULT 1,
    ward_id INT NOT NULL DEFAULT 1,
    bed_id INT NOT NULL DEFAULT 1,
    admission_date_key INT NOT NULL DEFAULT 19700101,
    admission_type VARCHAR(50) NOT NULL DEFAULT 'Elective',
    admission_status VARCHAR(50) NOT NULL DEFAULT 'Admitted',
    CONSTRAINT fk_fact_admissions_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_admissions_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
    CONSTRAINT fk_fact_admissions_ward FOREIGN KEY (ward_id) REFERENCES dim_ward(ward_id),
    CONSTRAINT fk_fact_admissions_bed FOREIGN KEY (bed_id) REFERENCES dim_bed(bed_id),
    CONSTRAINT fk_fact_admissions_date FOREIGN KEY (admission_date_key) REFERENCES dim_date(date_key)
);

-- 5. Discharge Fact Table
CREATE TABLE fact_discharge (
    discharge_id INT AUTO_INCREMENT PRIMARY KEY,
    admission_id INT NOT NULL DEFAULT 1,
    doctor_id INT NOT NULL DEFAULT 1,
    discharge_date_key INT NOT NULL DEFAULT 19700101,
    discharge_disposition VARCHAR(100) NOT NULL DEFAULT 'Routine',
    total_discharge_cost DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_fact_discharge_admission FOREIGN KEY (admission_id) REFERENCES fact_admissions(admission_id),
    CONSTRAINT fk_fact_discharge_doctor FOREIGN KEY (doctor_id) REFERENCES dim_doctor(doctor_id),
    CONSTRAINT fk_fact_discharge_date FOREIGN KEY (discharge_date_key) REFERENCES dim_date(date_key)
);

-- 6. Insurance Claims Fact Table
CREATE TABLE fact_insurance_claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    claim_number VARCHAR(50) NOT NULL UNIQUE DEFAULT 'CLM-000',
    patient_id INT NOT NULL DEFAULT 1,
    claim_date_key INT NOT NULL DEFAULT 19700101,
    claim_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    approved_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    deductible_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    claim_status VARCHAR(50) NOT NULL DEFAULT 'Submitted',
    rejection_reason VARCHAR(255) NOT NULL DEFAULT 'None',
    CONSTRAINT fk_fact_insurance_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_insurance_date FOREIGN KEY (claim_date_key) REFERENCES dim_date(date_key)
);

-- 7. Patient Feedback Fact Table
CREATE TABLE fact_patient_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL DEFAULT 1,
    doctor_id INT NOT NULL DEFAULT 1,
    department_id INT NOT NULL DEFAULT 1,
    date_key INT NOT NULL DEFAULT 19700101,
    doctor_rating INT NOT NULL DEFAULT 0,
    nursing_rating INT NOT NULL DEFAULT 0,
    facility_rating INT NOT NULL DEFAULT 0,
    overall_satisfaction_score INT NOT NULL DEFAULT 0,
    patient_comments TEXT NOT NULL,
    CONSTRAINT fk_fact_feedback_patient FOREIGN KEY (patient_id) REFERENCES dim_patient(patient_id),
    CONSTRAINT fk_fact_feedback_doctor FOREIGN KEY (doctor_id) REFERENCES dim_doctor(doctor_id),
    CONSTRAINT fk_fact_feedback_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id),
    CONSTRAINT fk_fact_feedback_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);

-- Re-enable foreign key checks for operational safety
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- REPORTING VIEWS
-- ============================================================================

-- 1. Patient Summary View
CREATE OR REPLACE VIEW vw_patient_summary AS
WITH appt_stats AS (
    SELECT 
        patient_id,
        COUNT(DISTINCT appointment_id) AS total_appointments,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_appointments,
        SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_appointments,
        SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS noshow_appointments
    FROM fact_appointments
    GROUP BY patient_id
),
billing_stats AS (
    SELECT 
        patient_id,
        SUM(net_amount) AS total_amount_billed,
        SUM(CASE WHEN payment_status = 'Paid' THEN net_amount ELSE 0.00 END) AS total_amount_paid,
        SUM(CASE WHEN payment_status = 'Unpaid' THEN net_amount ELSE 0.00 END) AS total_outstanding_balance
    FROM fact_billing
    GROUP BY patient_id
),
last_visit AS (
    SELECT 
        fa.patient_id,
        MAX(fd.full_date) AS last_visit_date
    FROM fact_appointments fa
    JOIN dim_date fd ON fa.date_key = fd.date_key
    GROUP BY fa.patient_id
)
SELECT 
    p.patient_id,
    p.patient_code,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    p.gender,
    p.age,
    p.blood_group,
    p.marital_status,
    p.city,
    p.state,
    p.registration_date,
    p.patient_status,
    COALESCE(ast.total_appointments, 0) AS total_appointments,
    COALESCE(ast.completed_appointments, 0) AS completed_appointments,
    COALESCE(ast.cancelled_appointments, 0) AS cancelled_appointments,
    COALESCE(ast.noshow_appointments, 0) AS noshow_appointments,
    COALESCE(bst.total_amount_billed, 0.00) AS total_amount_billed,
    COALESCE(bst.total_amount_paid, 0.00) AS total_amount_paid,
    COALESCE(bst.total_outstanding_balance, 0.00) AS total_outstanding_balance,
    COALESCE(lv.last_visit_date, p.registration_date) AS last_visit_date
FROM dim_patient p
LEFT JOIN appt_stats ast ON p.patient_id = ast.patient_id
LEFT JOIN billing_stats bst ON p.patient_id = bst.patient_id
LEFT JOIN last_visit lv ON p.patient_id = lv.patient_id;

-- 2. Doctor Summary View
CREATE OR REPLACE VIEW vw_doctor_summary AS
WITH doc_appts AS (
    SELECT 
        doctor_id,
        COUNT(DISTINCT appointment_id) AS total_consultations,
        SUM(consultation_fee) AS total_consultation_revenue
    FROM fact_appointments
    WHERE status = 'Completed'
    GROUP BY doctor_id
),
doc_discharges AS (
    SELECT doctor_id, COUNT(DISTINCT discharge_id) AS total_discharges_handled
    FROM fact_discharge
    GROUP BY doctor_id
),
doc_feedback AS (
    SELECT doctor_id, AVG(doctor_rating) AS avg_doctor_rating
    FROM fact_patient_feedback
    GROUP BY doctor_id
),
doc_waits AS (
    SELECT doctor_id, AVG(waiting_duration_minutes) AS avg_patient_wait_time_mins
    FROM fact_waiting_time
    GROUP BY doctor_id
)
SELECT 
    d.doctor_id,
    d.doctor_code,
    CONCAT('Dr. ', d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialization,
    d.qualification,
    d.experience_years,
    dept.department_name,
    d.consultation_fee,
    d.employment_type,
    d.doctor_status,
    COALESCE(da.total_consultations, 0) AS total_consultations,
    COALESCE(dd.total_discharges_handled, 0) AS total_discharges_handled,
    COALESCE(ROUND(df.avg_doctor_rating, 2), 0.00) AS avg_doctor_rating,
    COALESCE(ROUND(dw.avg_patient_wait_time_mins, 1), 0.0) AS avg_patient_wait_time_mins,
    COALESCE(da.total_consultation_revenue, 0.00) AS total_consultation_revenue
FROM dim_doctor d
INNER JOIN dim_department dept ON d.department_id = dept.department_id
LEFT JOIN doc_appts da ON d.doctor_id = da.doctor_id
LEFT JOIN doc_discharges dd ON d.doctor_id = dd.doctor_id
LEFT JOIN doc_feedback df ON d.doctor_id = df.doctor_id
LEFT JOIN doc_waits dw ON d.doctor_id = dw.doctor_id;

-- 3. Department Summary View
CREATE OR REPLACE VIEW vw_department_summary AS
WITH dept_docs AS (
    SELECT department_id, COUNT(DISTINCT doctor_id) AS active_doctors_count
    FROM dim_doctor
    WHERE doctor_status = 'Active'
    GROUP BY department_id
),
dept_wards AS (
    SELECT department_id, COUNT(DISTINCT ward_id) AS total_wards
    FROM dim_ward
    GROUP BY department_id
),
dept_appts AS (
    SELECT department_id, COUNT(DISTINCT appointment_id) AS total_appointments
    FROM fact_appointments
    GROUP BY department_id
),
dept_waits AS (
    SELECT department_id, AVG(waiting_duration_minutes) AS avg_dept_wait_time_mins
    FROM fact_waiting_time
    GROUP BY department_id
),
dept_feedback AS (
    SELECT department_id, AVG(facility_rating) AS avg_facility_rating
    FROM fact_patient_feedback
    GROUP BY department_id
)
SELECT 
    dept.department_id,
    dept.department_code,
    dept.department_name,
    dept.department_type,
    dept.building_name,
    dept.head_of_department,
    dept.consultation_fee,
    dept.department_status,
    COALESCE(dd.active_doctors_count, 0) AS active_doctors_count,
    COALESCE(dw.total_wards, 0) AS total_wards,
    COALESCE(dept.total_beds, 0) AS total_department_beds,
    COALESCE(da.total_appointments, 0) AS total_appointments,
    COALESCE(ROUND(dwt.avg_dept_wait_time_mins, 1), 0.0) AS avg_dept_wait_time_mins,
    COALESCE(ROUND(df.avg_facility_rating, 2), 0.00) AS avg_facility_rating
FROM dim_department dept
LEFT JOIN dept_docs dd ON dept.department_id = dd.department_id
LEFT JOIN dept_wards dw ON dept.department_id = dw.department_id
LEFT JOIN dept_appts da ON dept.department_id = da.department_id
LEFT JOIN dept_waits dwt ON dept.department_id = dwt.department_id
LEFT JOIN dept_feedback df ON dept.department_id = df.department_id;

-- 4. Appointment Summary View
CREATE OR REPLACE VIEW vw_appointment_summary AS
SELECT 
    fa.appointment_id,
    fa.appointment_code,
    fd.full_date AS appointment_date,
    fd.day_name,
    fd.month_name,
    fd.calendar_year,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.gender AS patient_gender,
    p.age AS patient_age,
    CONCAT('Dr. ', d.first_name, ' ', d.last_name) AS doctor_name,
    dept.department_name,
    fa.appointment_type,
    fa.appointment_channel,
    fa.status AS appointment_status,
    COALESCE(fa.consultation_fee, 0.00) AS consultation_fee
FROM fact_appointments fa
INNER JOIN dim_date fd ON fa.date_key = fd.date_key
INNER JOIN dim_patient p ON fa.patient_id = p.patient_id
INNER JOIN dim_doctor d ON fa.doctor_id = d.doctor_id
INNER JOIN dim_department dept ON fa.department_id = dept.department_id;

-- 5. OPD Summary View
CREATE OR REPLACE VIEW vw_opd_summary AS
SELECT 
    fd.full_date AS opd_date,
    dept.department_name,
    COALESCE(COUNT(DISTINCT fa.appointment_id), 0) AS total_opd_visits,
    COALESCE(SUM(CASE WHEN fa.appointment_type = 'Walk-In' THEN 1 ELSE 0 END), 0) AS walkin_visits,
    COALESCE(SUM(CASE WHEN fa.appointment_type = 'Scheduled' THEN 1 ELSE 0 END), 0) AS scheduled_visits,
    COALESCE(SUM(CASE WHEN fa.status = 'Completed' THEN 1 ELSE 0 END), 0) AS completed_visits,
    COALESCE(SUM(CASE WHEN fa.status = 'Cancelled' THEN 1 ELSE 0 END), 0) AS cancelled_visits,
    COALESCE(ROUND(AVG(fwt.waiting_duration_minutes), 1), 0.0) AS avg_opd_wait_time_mins,
    COALESCE(SUM(fa.consultation_fee), 0.00) AS total_opd_revenue
FROM fact_appointments fa
INNER JOIN dim_date fd ON fa.date_key = fd.date_key
INNER JOIN dim_department dept ON fa.department_id = dept.department_id
LEFT JOIN fact_waiting_time fwt ON fa.appointment_id = fwt.appointment_id
WHERE dept.department_type = 'Outpatient' OR fa.appointment_type IN ('Walk-In', 'OPD')
GROUP BY fd.full_date, dept.department_name;

-- 6. IPD Summary View
CREATE OR REPLACE VIEW vw_ipd_summary AS
SELECT 
    fa.admission_id,
    fa.admission_code,
    p.patient_code,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    dept.department_name,
    w.ward_name,
    w.ward_type,
    b.bed_number,
    fd_adm.full_date AS admission_date,
    fd_dis.full_date AS discharge_date,
    COALESCE(DATEDIFF(fd_dis.full_date, fd_adm.full_date), 0) AS length_of_stay_days,
    fa.admission_type,
    fa.admission_status,
    fds.discharge_disposition,
    COALESCE(fds.total_discharge_cost, 0.00) AS total_discharge_cost
FROM fact_admissions fa
INNER JOIN dim_patient p ON fa.patient_id = p.patient_id
INNER JOIN dim_department dept ON fa.department_id = dept.department_id
INNER JOIN dim_ward w ON fa.ward_id = w.ward_id
INNER JOIN dim_bed b ON fa.bed_id = b.bed_id
INNER JOIN dim_date fd_adm ON fa.admission_date_key = fd_adm.date_key
LEFT JOIN fact_discharge fds ON fa.admission_id = fds.admission_id
LEFT JOIN dim_date fd_dis ON fds.discharge_date_key = fd_dis.date_key;

-- 7. Waiting Time Performance View
CREATE OR REPLACE VIEW vw_waiting_time AS
SELECT 
    fwt.waiting_id,
    fd.full_date AS visit_date,
    dept.department_name,
    CONCAT('Dr. ', d.first_name, ' ', d.last_name) AS doctor_name,
    fwt.queue_number,
    fwt.check_in_time,
    fwt.consultation_start_time,
    fwt.consultation_end_time,
    COALESCE(fwt.waiting_duration_minutes, 0) AS queue_wait_time_mins,
    COALESCE(fwt.consultation_duration_minutes, 0) AS consultation_time_mins,
    CASE 
        WHEN fwt.waiting_duration_minutes <= 15 THEN 'Target (<15m)'
        WHEN fwt.waiting_duration_minutes <= 30 THEN 'Acceptable (15-30m)'
        ELSE 'Delayed (>30m)'
    END AS wait_time_category
FROM fact_waiting_time fwt
INNER JOIN dim_date fd ON fwt.date_key = fd.date_key
INNER JOIN dim_department dept ON fwt.department_id = dept.department_id
INNER JOIN dim_doctor d ON fwt.doctor_id = d.doctor_id;

-- 8. Monthly Revenue Summary View
CREATE OR REPLACE VIEW vw_revenue_summary AS
SELECT 
    fd.calendar_year,
    fd.month_name,
    fd.month_number,
    dept.department_name,
    COALESCE(SUM(fb.gross_amount), 0.00) AS total_gross_revenue,
    COALESCE(SUM(fb.discount_amount), 0.00) AS total_discounts_given,
    COALESCE(SUM(fb.tax_amount), 0.00) AS total_tax_collected,
    COALESCE(SUM(fb.net_amount), 0.00) AS total_net_revenue,
    COALESCE(SUM(CASE WHEN fb.payment_status = 'Paid' THEN fb.net_amount ELSE 0.00 END), 0.00) AS total_cash_collected,
    COALESCE(SUM(CASE WHEN fb.payment_status = 'Unpaid' THEN fb.net_amount ELSE 0.00 END), 0.00) AS total_accounts_receivable
FROM fact_billing fb
INNER JOIN dim_date fd ON fb.billing_date_key = fd.date_key
INNER JOIN dim_department dept ON fb.department_id = dept.department_id
GROUP BY fd.calendar_year, fd.month_name, fd.month_number, dept.department_name;

-- 9. Insurance Claims View
CREATE OR REPLACE VIEW vw_insurance_claims AS
SELECT 
    fic.claim_id,
    fic.claim_number,
    p.patient_code,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    p.insurance_provider,
    p.policy_number,
    fd.full_date AS claim_date,
    COALESCE(fic.claim_amount, 0.00) AS claim_amount,
    COALESCE(fic.approved_amount, 0.00) AS approved_amount,
    COALESCE(fic.deductible_amount, 0.00) AS deductible_amount,
    COALESCE((fic.claim_amount - fic.approved_amount), 0.00) AS shortfall_amount,
    fic.claim_status,
    fic.rejection_reason
FROM fact_insurance_claims fic
INNER JOIN dim_patient p ON fic.patient_id = p.patient_id
INNER JOIN dim_date fd ON fic.claim_date_key = fd.date_key;

-- 10. Patient Feedback View
CREATE OR REPLACE VIEW vw_patient_feedback AS
SELECT 
    fpf.feedback_id,
    fd.full_date AS feedback_date,
    p.patient_code,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    dept.department_name,
    CONCAT('Dr. ', d.first_name, ' ', d.last_name) AS doctor_name,
    COALESCE(fpf.doctor_rating, 0) AS doctor_rating,
    COALESCE(fpf.nursing_rating, 0) AS nursing_rating,
    COALESCE(fpf.facility_rating, 0) AS facility_rating,
    COALESCE(fpf.overall_satisfaction_score, 0) AS overall_satisfaction_score,
    CASE 
        WHEN fpf.overall_satisfaction_score >= 9 THEN 'Promoter'
        WHEN fpf.overall_satisfaction_score >= 7 THEN 'Passive'
        ELSE 'Detractor'
    END AS nps_category,
    fpf.patient_comments
FROM fact_patient_feedback fpf
INNER JOIN dim_date fd ON fpf.date_key = fd.date_key
INNER JOIN dim_patient p ON fpf.patient_id = p.patient_id
INNER JOIN dim_department dept ON fpf.department_id = dept.department_id
INNER JOIN dim_doctor d ON fpf.doctor_id = d.doctor_id;

-- 11. Bed Occupancy View
CREATE OR REPLACE VIEW vw_bed_occupancy AS
SELECT 
    dept.department_name,
    w.ward_name,
    w.ward_type,
    COALESCE(COUNT(b.bed_id), 0) AS total_capacity,
    COALESCE(SUM(CASE WHEN b.bed_status = 'Occupied' THEN 1 ELSE 0 END), 0) AS occupied_beds,
    COALESCE(SUM(CASE WHEN b.bed_status = 'Available' THEN 1 ELSE 0 END), 0) AS available_beds,
    COALESCE(SUM(CASE WHEN b.bed_status = 'Maintenance' THEN 1 ELSE 0 END), 0) AS maintenance_beds,
    COALESCE(ROUND((SUM(CASE WHEN b.bed_status = 'Occupied' THEN 1 ELSE 0 END) / NULLIF(COUNT(b.bed_id), 0)) * 100, 2), 0.00) AS occupancy_rate_pct
FROM dim_ward w
INNER JOIN dim_department dept ON w.department_id = dept.department_id
LEFT JOIN dim_bed b ON w.ward_id = b.ward_id
GROUP BY dept.department_name, w.ward_name, w.ward_type;

-- 12. Final Verification Query
SELECT 'vw_patient_summary' AS view_name, COUNT(*) AS total_rows FROM vw_patient_summary
UNION ALL SELECT 'vw_doctor_summary', COUNT(*) FROM vw_doctor_summary
UNION ALL SELECT 'vw_department_summary', COUNT(*) FROM vw_department_summary
UNION ALL SELECT 'vw_appointment_summary', COUNT(*) FROM vw_appointment_summary
UNION ALL SELECT 'vw_opd_summary', COUNT(*) FROM vw_opd_summary
UNION ALL SELECT 'vw_ipd_summary', COUNT(*) FROM vw_ipd_summary
UNION ALL SELECT 'vw_waiting_time', COUNT(*) FROM vw_waiting_time
UNION ALL SELECT 'vw_revenue_summary', COUNT(*) FROM vw_revenue_summary
UNION ALL SELECT 'vw_insurance_claims', COUNT(*) FROM vw_insurance_claims
UNION ALL SELECT 'vw_patient_feedback', COUNT(*) FROM vw_patient_feedback
UNION ALL SELECT 'vw_bed_occupancy', COUNT(*) FROM vw_bed_occupancy;