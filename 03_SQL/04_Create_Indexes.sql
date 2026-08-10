-- =========================================================================
-- HEALTHCARE DATA WAREHOUSE - DIMENSION DATA SEED & ETL SCRIPT
-- Target: MySQL 8.0+ / MariaDB
-- File: 04_Insert_Dimension_Data.sql
-- Description: Self-contained master seed script for all 11 dimension tables.
--              Creates table schemas if missing, populates reference lookup
--              tables, and executes procedural generators for large dimensions.
-- =========================================================================

CREATE DATABASE IF NOT EXISTS healthcare_dw;
USE healthcare_dw;

-- Disable constraints and safe mode for fast bulk insertions
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

-- =========================================================================
-- SECTION 1: SCHEMA CREATION (ENSURES ALL 11 TABLES EXIST BEFORE SHOW TABLES)
-- =========================================================================

CREATE TABLE IF NOT EXISTS dim_department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_head VARCHAR(100),
    location_floor VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dim_insurance (
    insurance_id INT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    plan_type VARCHAR(50),
    coverage_percentage DECIMAL(5, 2),
    contact_phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_payment_mode (
    payment_mode_id INT PRIMARY KEY,
    payment_method VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    is_electronic BOOLEAN
);

CREATE TABLE IF NOT EXISTS dim_ward (
    ward_id INT PRIMARY KEY,
    ward_name VARCHAR(100) NOT NULL,
    ward_type VARCHAR(50),
    total_beds INT,
    floor_level VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_medicine (
    medicine_id INT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    generic_name VARCHAR(100),
    category VARCHAR(50),
    unit_cost DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS dim_lab_test (
    lab_test_id INT PRIMARY KEY,
    test_name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    standard_cost DECIMAL(10, 2),
    processing_time_hours INT
);

CREATE TABLE IF NOT EXISTS dim_diagnosis (
    diagnosis_id INT PRIMARY KEY,
    icd10_code VARCHAR(10) NOT NULL,
    diagnosis_description VARCHAR(255),
    category VARCHAR(50),
    severity_level VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week INT,
    day_name VARCHAR(15),
    day_of_month INT,
    month_number INT,
    month_name VARCHAR(15),
    quarter VARCHAR(5),
    year INT,
    is_weekend BOOLEAN
);

CREATE TABLE IF NOT EXISTS dim_bed (
    bed_id INT PRIMARY KEY,
    ward_id INT,
    bed_number VARCHAR(20) NOT NULL,
    bed_type VARCHAR(50),
    is_operational BOOLEAN,
    FOREIGN KEY (ward_id) REFERENCES dim_ward(ward_id)
);

CREATE TABLE IF NOT EXISTS dim_doctor (
    doctor_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INT,
    specialization VARCHAR(100),
    experience_years INT,
    phone_number VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES dim_department(department_id)
);

CREATE TABLE IF NOT EXISTS dim_patient (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    dob DATE,
    phone_number VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(20),
    blood_group VARCHAR(5)
);

-- =========================================================================
-- SECTION 2: REFERENCE DIMENSION SEED DATA (EXPLICIT INSERTS)
-- =========================================================================

-- 1. DIM_DEPARTMENT (18 Rows)
TRUNCATE TABLE dim_department;
INSERT INTO dim_department (department_id, department_name, department_head, location_floor) VALUES
(1, 'Cardiology', 'Dr. Robert Chen', 'Floor 3 - North Wing'),
(2, 'Neurology', 'Dr. Sarah Jenkins', 'Floor 4 - East Wing'),
(3, 'Orthopedics', 'Dr. Michael Chang', 'Floor 2 - South Wing'),
(4, 'Pediatrics', 'Dr. Emily Watson', 'Floor 1 - West Wing'),
(5, 'Oncology', 'Dr. David Ross', 'Floor 5 - Central Wing'),
(6, 'Gastroenterology', 'Dr. Lisa Patel', 'Floor 3 - South Wing'),
(7, 'Pulmonology', 'Dr. James Wilson', 'Floor 4 - North Wing'),
(8, 'Dermatology', 'Dr. Anna Martinez', 'Floor 2 - East Wing'),
(9, 'Nephrology', 'Dr. Arthur Pendelton', 'Floor 5 - West Wing'),
(10, 'General Surgery', 'Dr. Marcus Brody', 'Floor 2 - North Wing'),
(11, 'Emergency Medicine', 'Dr. Rachel Vance', 'Floor 1 - Ground East'),
(12, 'Urology', 'Dr. Steven Thorne', 'Floor 3 - East Wing'),
(13, 'Endocrinology', 'Dr. Maya Lin', 'Floor 4 - West Wing'),
(14, 'Psychiatry', 'Dr. George Sterling', 'Floor 6 - Tower A'),
(15, 'Ophthalmology', 'Dr. Karen Page', 'Floor 1 - West Wing'),
(16, 'ENT (Otolaryngology)', 'Dr. Harold Finch', 'Floor 2 - East Wing'),
(17, 'Obstetrics & Gynecology', 'Dr. Evelyn Reed', 'Floor 5 - Tower B'),
(18, 'Rheumatology', 'Dr. Julian Bashir', 'Floor 4 - South Wing');

-- 2. DIM_INSURANCE (20 Rows)
TRUNCATE TABLE dim_insurance;
INSERT INTO dim_insurance (insurance_id, provider_name, plan_type, coverage_percentage, contact_phone) VALUES
(501, 'Blue Cross Blue Shield', 'Gold PPO', 80.00, '1-800-555-0101'),
(502, 'Aetna Health', 'Silver HMO', 70.00, '1-800-555-0102'),
(503, 'UnitedHealthcare', 'Platinum Choice', 90.00, '1-800-555-0103'),
(504, 'Cigna Care', 'Standard EPO', 75.00, '1-800-555-0104'),
(505, 'Kaiser Permanente', 'HMO Advantage', 85.00, '1-800-555-0105'),
(506, 'Humana Health', 'Bronze Basic', 60.00, '1-800-555-0106'),
(507, 'Molina Healthcare', 'State Select', 70.00, '1-800-555-0107'),
(508, 'Centene Care', 'Essential HMO', 65.00, '1-800-555-0108'),
(509, 'Medicare Direct', 'Part B Standard', 80.00, '1-800-MEDICARE'),
(510, 'Medicaid Premier', 'State Managed', 100.00, '1-800-555-0110'),
(511, 'Anthem Health', 'Blue Premier', 85.00, '1-800-555-0111'),
(512, 'Highmark Health', 'Flex PPO', 75.00, '1-800-555-0112'),
(513, 'Ambetter Health', 'Balanced Care', 70.00, '1-800-555-0113'),
(514, 'WellCare Plus', 'Senior Shield', 85.00, '1-800-555-0114'),
(515, 'Oscar Health', 'Tech Select PPO', 80.00, '1-800-555-0115'),
(516, 'TriCare Military', 'Prime Cover', 95.00, '1-800-555-0116'),
(517, 'Guardian Life', 'Dental & Med', 60.00, '1-800-555-0117'),
(518, 'Principal Care', 'Group Advantage', 75.00, '1-800-555-0118'),
(519, 'Independence Shield', 'Keystone HMO', 70.00, '1-800-555-0119'),
(520, 'Self-Pay / Uninsured', 'Direct Billing', 0.00, 'N/A');

-- 3. DIM_PAYMENT_MODE (8 Rows)
TRUNCATE TABLE dim_payment_mode;
INSERT INTO dim_payment_mode (payment_mode_id, payment_method, category, is_electronic) VALUES
(1, 'Cash', 'Direct', FALSE),
(2, 'Credit Card', 'Electronic', TRUE),
(3, 'Debit Card', 'Electronic', TRUE),
(4, 'Insurance Claim', 'Third-Party', TRUE),
(5, 'UPI / QR Payment', 'Digital Wallet', TRUE),
(6, 'Bank Wire Transfer', 'Direct Transfer', TRUE),
(7, 'Cheque', 'Paper Draft', FALSE),
(8, 'Government Subsidy', 'Third-Party', TRUE);

-- 4. DIM_WARD (20 Rows)
TRUNCATE TABLE dim_ward;
INSERT INTO dim_ward (ward_id, ward_name, ward_type, total_beds, floor_level) VALUES
(10, 'General Male Ward A', 'General', 30, 'Floor 1'),
(11, 'General Female Ward B', 'General', 30, 'Floor 1'),
(12, 'Intensive Care Unit (ICU)', 'Critical Care', 15, 'Floor 2'),
(13, 'Neonatal ICU (NICU)', 'Pediatric Critical', 10, 'Floor 2'),
(14, 'Cardiac Care Unit (CCU)', 'Critical Care', 12, 'Floor 3'),
(15, 'Pediatric Ward', 'General Special', 25, 'Floor 1'),
(16, 'Maternity Ward', 'Specialized', 20, 'Floor 5'),
(17, 'Oncology Care Ward', 'Specialized', 20, 'Floor 5'),
(18, 'Surgical Recovery Ward', 'Post-Op', 25, 'Floor 2'),
(19, 'Orthopedic Isolation Unit', 'Isolation', 10, 'Floor 2'),
(20, 'VIP Private Suites', 'Private', 10, 'Floor 6'),
(21, 'Semi-Private Ward C', 'Semi-Private', 20, 'Floor 3'),
(22, 'Semi-Private Ward D', 'Semi-Private', 20, 'Floor 3'),
(23, 'Emergency Holding Bay', 'Triage', 15, 'Floor 1'),
(24, 'Psychiatric Care Wing', 'Secure', 12, 'Floor 6'),
(25, 'Pulmonary Care Ward', 'Specialized', 15, 'Floor 4'),
(26, 'Nephrology Dialysis Unit', 'Outpatient/IP', 10, 'Floor 5'),
(27, 'Stroke Recovery Unit', 'Rehabilitation', 12, 'Floor 4'),
(28, 'Geriatric Specialty Ward', 'General Special', 20, 'Floor 4'),
(29, 'Day Surgery Unit', 'Short Stay', 15, 'Floor 2');

-- 5. DIM_MEDICINE (20 Rows)
TRUNCATE TABLE dim_medicine;
INSERT INTO dim_medicine (medicine_id, brand_name, generic_name, category, unit_cost) VALUES
(1001, 'Amoxil', 'Amoxicillin', 'Antibiotic', 12.50),
(1002, 'Lipitor', 'Atorvastatin', 'Statin / Cardiovascular', 45.00),
(1003, 'Glucophage', 'Metformin', 'Antidiabetic', 15.00),
(1004, 'Zestril', 'Lisinopril', 'ACE Inhibitor', 18.00),
(1005, 'Advil', 'Ibuprofen', 'NSAID / Analgesic', 8.00),
(1006, 'Tylenol', 'Acetaminophen', 'Analgesic / Antipyretic', 6.50),
(1007, 'Ventolin', 'Albuterol', 'Bronchodilator', 35.00),
(1008, 'Prilosec', 'Omeprazole', 'Proton Pump Inhibitor', 22.00),
(1009, 'Synthroid', 'Levothyroxine', 'Hormone Replacement', 28.00),
(1010, 'Norvasc', 'Amlodipine', 'Calcium Channel Blocker', 19.50),
(1011, 'Cozaar', 'Losartan', 'Antihypertensive', 24.00),
(1012, 'Sterapred', 'Prednisone', 'Corticosteroid', 14.00),
(1013, 'Cipro', 'Ciprofloxacin', 'Antibiotic', 31.00),
(1014, 'Zoloft', 'Sertraline', 'Antidepressant', 40.00),
(1015, 'Lasix', 'Furosemide', 'Diuretic', 11.00),
(1016, 'Plavix', 'Clopidogrel', 'Antiplatelet', 52.00),
(1017, 'Lovenox', 'Enoxaparin', 'Anticoagulant', 115.00),
(1018, 'Xanax', 'Alprazolam', 'Anxiolytic', 25.00),
(1019, 'Zofran', 'Ondansetron', 'Antiemetic', 38.00),
(1020, 'Lantus', 'Insulin Glargine', 'Antidiabetic', 140.00);

-- 6. DIM_LAB_TEST (20 Rows)
TRUNCATE TABLE dim_lab_test;
INSERT INTO dim_lab_test (lab_test_id, test_name, department, standard_cost, processing_time_hours) VALUES
(2001, 'Complete Blood Count (CBC)', 'Hematology', 45.00, 2),
(2002, 'Basic Metabolic Panel (BMP)', 'Biochemistry', 65.00, 3),
(2003, 'Comprehensive Metabolic Panel (CMP)', 'Biochemistry', 90.00, 4),
(2004, 'Lipid Panel', 'Biochemistry', 75.00, 4),
(2005, 'Hemoglobin A1C', 'Endocrinology', 55.00, 2),
(2006, 'Thyroid Stimulating Hormone (TSH)', 'Endocrinology', 80.00, 6),
(2007, 'Urinalysis Routine', 'Pathology', 30.00, 1),
(2008, 'Prothrombin Time (PT/INR)', 'Hematology', 50.00, 2),
(2009, 'Liver Function Test (LFT)', 'Biochemistry', 85.00, 4),
(2010, 'Blood Culture & Sensitivity', 'Microbiology', 120.00, 48),
(2011, 'Urine Culture', 'Microbiology', 70.00, 24),
(2012, 'Troponin I High Sensitivity', 'Cardiology/Lab', 110.00, 1),
(2013, 'Arterial Blood Gas (ABG)', 'Pulmonology/Lab', 95.00, 1),
(2014, 'C-Reactive Protein (CRP)', 'Immunology', 60.00, 3),
(2015, 'Erythrocyte Sedimentation Rate (ESR)', 'Hematology', 35.00, 2),
(2016, 'Vitamin D (25-Hydroxy)', 'Biochemistry', 105.00, 12),
(2017, 'Serum Creatinine & BUN', 'Nephrology/Lab', 40.00, 2),
(2018, 'Prostate-Specific Antigen (PSA)', 'Oncology/Lab', 95.00, 8),
(2019, 'COVID-19 RT-PCR Test', 'Virology', 85.00, 6),
(2020, 'Stool Culture & Parasites', 'Microbiology', 65.00, 24);

-- 7. DIM_DIAGNOSIS (20 Rows)
TRUNCATE TABLE dim_diagnosis;
INSERT INTO dim_diagnosis (diagnosis_id, icd10_code, diagnosis_description, category, severity_level) VALUES
(3001, 'I10', 'Essential (primary) hypertension', 'Cardiovascular', 'Mild'),
(3002, 'E11.9', 'Type 2 diabetes mellitus without complications', 'Endocrine', 'Moderate'),
(3003, 'J18.9', 'Pneumonia, unspecified organism', 'Respiratory', 'Severe'),
(3004, 'J45.909', 'Unspecified asthma, uncomplicated', 'Respiratory', 'Moderate'),
(3005, 'N39.0', 'Urinary tract infection, site not specified', 'Urology', 'Mild'),
(3006, 'K21.9', 'Gastro-esophageal reflux disease without esophagitis', 'Gastrointestinal', 'Mild'),
(3007, 'M54.5', 'Low back pain, unspecified', 'Musculoskeletal', 'Mild'),
(3008, 'I50.9', 'Heart failure, unspecified', 'Cardiovascular', 'Critical'),
(3009, 'I63.9', 'Cerebral infarction, unspecified (Ischemic Stroke)', 'Neurology', 'Critical'),
(3010, 'A41.9', 'Sepsis, unspecified organism', 'Infectious', 'Critical'),
(3011, 'K80.20', 'Calculus of gallbladder without cholecystitis', 'Gastrointestinal', 'Moderate'),
(3012, 'S72.001A', 'Fracture of head of right femur, initial visit', 'Orthopedics', 'Severe'),
(3013, 'F32.9', 'Major depressive disorder, single episode', 'Psychiatry', 'Moderate'),
(3014, 'N18.9', 'Chronic kidney disease, unspecified', 'Nephrology', 'Severe'),
(3015, 'C34.90', 'Malignant neoplasm of unspecified part of bronchus/lung', 'Oncology', 'Critical'),
(3016, 'J02.9', 'Acute pharyngitis, unspecified', 'ENT', 'Mild'),
(3017, 'L03.90', 'Cellulitis, unspecified', 'Dermatology', 'Moderate'),
(3018, 'K35.80', 'Unspecified acute appendicitis', 'Surgery', 'Severe'),
(3019, 'M17.11', 'Unilateral primary osteoarthritis, right knee', 'Orthopedics', 'Moderate'),
(3020, 'R51.9', 'Headache, unspecified', 'Neurology', 'Mild');

-- =========================================================================
-- SECTION 3: PROCEDURAL GENERATORS FOR LARGE DIMENSIONS
-- =========================================================================

-- 8. DIM_DATE (1,826 Rows: Jan 1, 2022 - Dec 31, 2026)
TRUNCATE TABLE dim_date;
DROP PROCEDURE IF EXISTS seed_dim_date;
DELIMITER $$
CREATE PROCEDURE seed_dim_date(IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE current_dt DATE;
    SET current_dt = start_date;
    WHILE current_dt <= end_date DO
        INSERT INTO dim_date (
            date_key, full_date, day_of_week, day_name, 
            day_of_month, month_number, month_name, 
            quarter, year, is_weekend
        ) VALUES (
            CAST(DATE_FORMAT(current_dt, '%Y%m%d') AS UNSIGNED),
            current_dt,
            WEEKDAY(current_dt) + 1,
            DAYNAME(current_dt),
            DAY(current_dt),
            MONTH(current_dt),
            MONTHNAME(current_dt),
            CONCAT('Q', QUARTER(current_dt)),
            YEAR(current_dt),
            IF(WEEKDAY(current_dt) IN (5, 6), TRUE, FALSE)
        );
        SET current_dt = DATE_ADD(current_dt, INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

CALL seed_dim_date('2022-01-01', '2026-12-31');
DROP PROCEDURE IF EXISTS seed_dim_date;

-- 9. DIM_BED (400 Rows)
TRUNCATE TABLE dim_bed;
DROP PROCEDURE IF EXISTS seed_dim_bed;
DELIMITER $$
CREATE PROCEDURE seed_dim_bed(IN total_beds INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE ward_idx INT;
    DECLARE bed_t VARCHAR(50);
    WHILE i <= total_beds DO
        SET ward_idx = 10 + (i % 20);
        CASE (i % 5)
            WHEN 0 THEN SET bed_t = 'Standard Manual';
            WHEN 1 THEN SET bed_t = 'Semi-Electric';
            WHEN 2 THEN SET bed_t = 'Full Electric';
            WHEN 3 THEN SET bed_t = 'ICU Special Bed';
            ELSE SET bed_t = 'Pediatric Crib';
        END CASE;
        INSERT INTO dim_bed (bed_id, ward_id, bed_number, bed_type, is_operational)
        VALUES (
            i, ward_idx,
            CONCAT('BED-', ward_idx, '-', LPAD(i, 3, '0')),
            bed_t, IF(i % 23 = 0, FALSE, TRUE)
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL seed_dim_bed(400);
DROP PROCEDURE IF EXISTS seed_dim_bed;

-- 10. DIM_DOCTOR (120 Rows)
TRUNCATE TABLE dim_doctor;
DROP PROCEDURE IF EXISTS seed_dim_doctor;
DELIMITER $$
CREATE PROCEDURE seed_dim_doctor(IN total_doctors INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE fn VARCHAR(50); DECLARE ln VARCHAR(50); DECLARE spec VARCHAR(100);
    
    WHILE i <= total_doctors DO
        CASE (i % 10)
            WHEN 0 THEN SET fn = 'James'; WHEN 1 THEN SET fn = 'Mary'; WHEN 2 THEN SET fn = 'John';
            WHEN 3 THEN SET fn = 'Patricia'; WHEN 4 THEN SET fn = 'Robert'; WHEN 5 THEN SET fn = 'Jennifer';
            WHEN 6 THEN SET fn = 'Michael'; WHEN 7 THEN SET fn = 'Linda'; WHEN 8 THEN SET fn = 'William';
            ELSE SET fn = 'Elizabeth';
        END CASE;
        CASE (i % 10)
            WHEN 0 THEN SET ln = 'Smith'; WHEN 1 THEN SET ln = 'Johnson'; WHEN 2 THEN SET ln = 'Williams';
            WHEN 3 THEN SET ln = 'Brown'; WHEN 4 THEN SET ln = 'Jones'; WHEN 5 THEN SET ln = 'Garcia';
            WHEN 6 THEN SET ln = 'Miller'; WHEN 7 THEN SET ln = 'Davis'; WHEN 8 THEN SET ln = 'Rodriguez';
            ELSE SET ln = 'Martinez';
        END CASE;
        CASE (i % 8)
            WHEN 0 THEN SET spec = 'Cardiology'; WHEN 1 THEN SET spec = 'Neurology'; WHEN 2 THEN SET spec = 'Orthopedics';
            WHEN 3 THEN SET spec = 'Pediatrics'; WHEN 4 THEN SET spec = 'Oncology'; WHEN 5 THEN SET spec = 'Gastroenterology';
            WHEN 6 THEN SET spec = 'Pulmonology'; ELSE SET spec = 'General Surgery';
        END CASE;
        
        INSERT INTO dim_doctor (doctor_id, first_name, last_name, department_id, specialization, experience_years, phone_number)
        VALUES (
            100 + i, fn, ln, 1 + (i % 18), spec, 3 + (i % 28),
            CONCAT('555-', LPAD(100 + (i * 3) % 899, 3, '0'), '-', LPAD(1000 + (i * 7) % 8999, 4, '0'))
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL seed_dim_doctor(120);
DROP PROCEDURE IF EXISTS seed_dim_doctor;

-- 11. DIM_PATIENT (1,000 Rows)
TRUNCATE TABLE dim_patient;
DROP PROCEDURE IF EXISTS seed_dim_patient;
DELIMITER $$
CREATE PROCEDURE seed_dim_patient(IN total_patients INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE fn VARCHAR(50); DECLARE ln VARCHAR(50); DECLARE gen VARCHAR(10);
    DECLARE ct VARCHAR(50); DECLARE st VARCHAR(10); DECLARE bg VARCHAR(5);
    DECLARE random_days INT;
    
    WHILE i <= total_patients DO
        SET gen = IF(i % 2 = 0, 'Male', 'Female');
        CASE (i % 10)
            WHEN 0 THEN SET fn = 'David'; WHEN 1 THEN SET fn = 'Sarah'; WHEN 2 THEN SET fn = 'Daniel';
            WHEN 3 THEN SET fn = 'Emily'; WHEN 4 THEN SET fn = 'Christopher'; WHEN 5 THEN SET fn = 'Jessica';
            WHEN 6 THEN SET fn = 'Matthew'; WHEN 7 THEN SET fn = 'Amanda'; WHEN 8 THEN SET fn = 'Anthony';
            ELSE SET fn = 'Ashley';
        END CASE;
        CASE (i % 10)
            WHEN 0 THEN SET ln = 'Taylor'; WHEN 1 THEN SET ln = 'Anderson'; WHEN 2 THEN SET ln = 'Thomas';
            WHEN 3 THEN SET ln = 'Jackson'; WHEN 4 THEN SET ln = 'White'; WHEN 5 THEN SET ln = 'Harris';
            WHEN 6 THEN SET ln = 'Martin'; WHEN 7 THEN SET ln = 'Thompson'; WHEN 8 THEN SET ln = 'Garcia';
            ELSE SET ln = 'Martinez';
        END CASE;
        CASE (i % 6)
            WHEN 0 THEN SET ct = 'New York'; SET st = 'NY';
            WHEN 1 THEN SET ct = 'Los Angeles'; SET st = 'CA';
            WHEN 2 THEN SET ct = 'Chicago'; SET st = 'IL';
            WHEN 3 THEN SET ct = 'Houston'; SET st = 'TX';
            WHEN 4 THEN SET ct = 'Phoenix'; SET st = 'AZ';
            ELSE SET ct = 'Philadelphia'; SET st = 'PA';
        END CASE;
        CASE (i % 8)
            WHEN 0 THEN SET bg = 'A+'; WHEN 1 THEN SET bg = 'A-'; WHEN 2 THEN SET bg = 'B+';
            WHEN 3 THEN SET bg = 'B-'; WHEN 4 THEN SET bg = 'O+'; WHEN 5 THEN SET bg = 'O-';
            WHEN 6 THEN SET bg = 'AB+'; ELSE SET bg = 'AB-';
        END CASE;
        SET random_days = (i * 17) % 25000;
        
        INSERT INTO dim_patient (
            patient_id, first_name, last_name, gender, dob, 
            phone_number, address, city, state, blood_group
        ) VALUES (
            i, fn, ln, gen,
            DATE_SUB('2005-01-01', INTERVAL random_days DAY),
            CONCAT('555-', LPAD(100 + (i * 5) % 899, 3, '0'), '-', LPAD(1000 + (i * 11) % 8999, 4, '0')),
            CONCAT(100 + (i * 3) % 9000, ' Main Street'), ct, st, bg
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL seed_dim_patient(1000);
DROP PROCEDURE IF EXISTS seed_dim_patient;

-- Re-enable constraints
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 1;

-- =========================================================================
-- SECTION 4: TABLE LISTING & AUDIT CHECKS
-- =========================================================================

-- 1. Display all 11 dimension tables
SHOW TABLES;

-- 2. Audit record counts across all dimensions
SELECT 'dim_bed' AS Dimension_Table, COUNT(*) AS Total_Rows FROM dim_bed
UNION ALL SELECT 'dim_date', COUNT(*) FROM dim_date
UNION ALL SELECT 'dim_department', COUNT(*) FROM dim_department
UNION ALL SELECT 'dim_diagnosis', COUNT(*) FROM dim_diagnosis
UNION ALL SELECT 'dim_doctor', COUNT(*) FROM dim_doctor
UNION ALL SELECT 'dim_insurance', COUNT(*) FROM dim_insurance
UNION ALL SELECT 'dim_lab_test', COUNT(*) FROM dim_lab_test
UNION ALL SELECT 'dim_medicine', COUNT(*) FROM dim_medicine
UNION ALL SELECT 'dim_patient', COUNT(*) FROM dim_patient
UNION ALL SELECT 'dim_payment_mode', COUNT(*) FROM dim_payment_mode
UNION ALL SELECT 'dim_ward', COUNT(*) FROM dim_ward;