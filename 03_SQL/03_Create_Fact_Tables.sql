-- =========================================================================
-- HEALTHCARE DATA WAREHOUSE - EXTENDED FACT TABLES (30 ENTRIES PER TABLE)
-- Target: MySQL / MariaDB
-- =========================================================================

-- Database creation moved to 01_Create_Database.sql
USE hospital_analytics_db;

SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------------------------
-- 1. DROP EXISTING TABLES
-- -------------------------------------------------------------------------
DROP TABLE IF EXISTS fact_appointments;
DROP TABLE IF EXISTS fact_billing;
DROP TABLE IF EXISTS fact_insurance_claims;
DROP TABLE IF EXISTS fact_waiting_time;
DROP TABLE IF EXISTS fact_patient_feedback;
DROP TABLE IF EXISTS fact_radiology;
DROP TABLE IF EXISTS fact_discharge;
DROP TABLE IF EXISTS fact_bed_occupancy;

-- -------------------------------------------------------------------------
-- 2. CREATE TABLE SCHEMAS
-- -------------------------------------------------------------------------

CREATE TABLE fact_appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    date_key INT NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    appointment_type VARCHAR(30) DEFAULT 'Routine',
    consultation_fee DECIMAL(10,2) NOT NULL
);

CREATE TABLE fact_billing (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    patient_id INT NOT NULL,
    billing_date_key INT NOT NULL,
    billing_time TIME NOT NULL,
    bill_type VARCHAR(50) NOT NULL,
    gross_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    net_amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30)
);

CREATE TABLE fact_insurance_claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    billing_id INT NOT NULL,
    insurance_id INT NOT NULL,
    claim_date_key INT NOT NULL,
    claim_amount DECIMAL(10,2) NOT NULL,
    approved_amount DECIMAL(10,2) DEFAULT 0.00,
    co_pay_amount DECIMAL(10,2) DEFAULT 0.00,
    claim_status VARCHAR(20) NOT NULL
);

CREATE TABLE fact_waiting_time (
    waiting_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    department_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date_key INT NOT NULL,
    check_in_time TIME NOT NULL,
    consultation_start_time TIME NOT NULL,
    waiting_duration_minutes INT NOT NULL
);

CREATE TABLE fact_patient_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    department_id INT NOT NULL,
    date_key INT NOT NULL,
    doctor_rating INT CHECK (doctor_rating BETWEEN 1 AND 5),
    facility_rating INT CHECK (facility_rating BETWEEN 1 AND 5),
    overall_satisfaction_score INT CHECK (overall_satisfaction_score BETWEEN 1 AND 10),
    comments TEXT
);

CREATE TABLE fact_radiology (
    radiology_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date_key INT NOT NULL,
    modality VARCHAR(20) NOT NULL,
    body_part VARCHAR(50) NOT NULL,
    radiology_fee DECIMAL(10,2) NOT NULL,
    finding_summary TEXT,
    urgency_level VARCHAR(15) DEFAULT 'Normal'
);

CREATE TABLE fact_discharge (
    discharge_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    admission_date_key INT NOT NULL,
    discharge_date_key INT NOT NULL,
    discharge_type VARCHAR(30) NOT NULL,
    length_of_stay_days INT NOT NULL,
    total_discharge_cost DECIMAL(10,2) NOT NULL,
    readmission_risk_score VARCHAR(10) DEFAULT 'Low'
);

CREATE TABLE fact_bed_occupancy (
    occupancy_id INT AUTO_INCREMENT PRIMARY KEY,
    discharge_id INT,
    ward_id INT NOT NULL,
    bed_number VARCHAR(10) NOT NULL,
    date_key INT NOT NULL,
    occupancy_status VARCHAR(20) NOT NULL,
    daily_bed_rate DECIMAL(10,2) NOT NULL
);

-- -------------------------------------------------------------------------
-- 3. INSERT 30 RECORDS PER TABLE
-- -------------------------------------------------------------------------

-- 1. fact_appointments (30 records)
INSERT INTO fact_appointments (appointment_id, patient_id, doctor_id, department_id, date_key, appointment_time, status, appointment_type, consultation_fee) VALUES
(101, 1, 101, 1, 20260101, '09:00:00', 'Completed', 'Consultation', 150.00),
(102, 2, 102, 2, 20260101, '09:30:00', 'Completed', 'Follow-up', 100.00),
(103, 3, 101, 1, 20260102, '10:00:00', 'Completed', 'Consultation', 150.00),
(104, 4, 103, 3, 20260102, '10:30:00', 'Cancelled', 'Routine Checkup', 80.00),
(105, 5, 104, 4, 20260103, '11:00:00', 'Completed', 'Specialist Review', 200.00),
(106, 6, 102, 2, 20260103, '11:30:00', 'Completed', 'Consultation', 150.00),
(107, 7, 105, 5, 20260104, '14:00:00', 'No-Show', 'Routine Checkup', 80.00),
(108, 8, 103, 3, 20260104, '14:30:00', 'Completed', 'Follow-up', 100.00),
(109, 9, 101, 1, 20260105, '15:00:00', 'Completed', 'Consultation', 150.00),
(110, 10, 104, 4, 20260105, '15:30:00', 'Completed', 'Specialist Review', 200.00),
(111, 11, 102, 2, 20260106, '09:00:00', 'Completed', 'Follow-up', 100.00),
(112, 12, 105, 5, 20260106, '09:30:00', 'Completed', 'Consultation', 150.00),
(113, 13, 103, 3, 20260107, '10:15:00', 'Completed', 'Specialist Review', 200.00),
(114, 14, 101, 1, 20260107, '11:00:00', 'Cancelled', 'Routine Checkup', 80.00),
(115, 15, 104, 4, 20260108, '11:30:00', 'Completed', 'Consultation', 150.00),
(116, 16, 102, 2, 20260108, '13:00:00', 'Completed', 'Follow-up', 100.00),
(117, 17, 105, 5, 20260109, '13:30:00', 'No-Show', 'Routine Checkup', 80.00),
(118, 18, 103, 3, 20260109, '14:00:00', 'Completed', 'Specialist Review', 200.00),
(119, 19, 101, 1, 20260110, '14:45:00', 'Completed', 'Consultation', 150.00),
(120, 20, 104, 4, 20260110, '15:15:00', 'Completed', 'Follow-up', 100.00),
(121, 21, 102, 2, 20260111, '09:15:00', 'Completed', 'Consultation', 150.00),
(122, 22, 105, 5, 20260111, '10:00:00', 'Completed', 'Specialist Review', 200.00),
(123, 23, 103, 3, 20260112, '10:45:00', 'Cancelled', 'Follow-up', 100.00),
(124, 24, 101, 1, 20260112, '11:30:00', 'Completed', 'Consultation', 150.00),
(125, 25, 104, 4, 20260113, '13:15:00', 'Completed', 'Routine Checkup', 80.00),
(126, 26, 102, 2, 20260113, '14:00:00', 'Completed', 'Specialist Review', 200.00),
(127, 27, 105, 5, 20260114, '14:30:00', 'Completed', 'Follow-up', 100.00),
(128, 28, 103, 3, 20260114, '15:00:00', 'No-Show', 'Consultation', 150.00),
(129, 29, 101, 1, 20260115, '15:30:00', 'Completed', 'Specialist Review', 200.00),
(130, 30, 104, 4, 20260115, '16:00:00', 'Completed', 'Routine Checkup', 80.00);

-- 2. fact_billing (30 records)
INSERT INTO fact_billing (billing_id, appointment_id, patient_id, billing_date_key, billing_time, bill_type, gross_amount, discount_amount, net_amount, payment_status, payment_method) VALUES
(201, 101, 1, 20260101, '09:45:00', 'OPD Bill', 150.00, 10.00, 140.00, 'Paid', 'Credit Card'),
(202, 102, 2, 20260101, '10:15:00', 'OPD Bill', 100.00, 0.00, 100.00, 'Paid', 'Cash'),
(203, 103, 3, 20260102, '10:45:00', 'OPD Bill', 150.00, 15.00, 135.00, 'Paid', 'Insurance'),
(204, 105, 5, 20260103, '12:00:00', 'Specialist Care', 200.00, 20.00, 180.00, 'Partially Paid', 'Debit Card'),
(205, 106, 6, 20260103, '12:30:00', 'OPD Bill', 150.00, 0.00, 150.00, 'Paid', 'Cash'),
(206, 108, 8, 20260104, '15:15:00', 'OPD Bill', 100.00, 5.00, 95.00, 'Paid', 'UPI'),
(207, 109, 9, 20260105, '16:00:00', 'OPD Bill', 150.00, 0.00, 150.00, 'Unpaid', NULL),
(208, 110, 10, 20260105, '16:30:00', 'Specialist Care', 200.00, 0.00, 200.00, 'Paid', 'Insurance'),
(209, 111, 11, 20260106, '09:45:00', 'OPD Bill', 100.00, 0.00, 100.00, 'Paid', 'Debit Card'),
(210, 112, 12, 20260106, '10:15:00', 'OPD Bill', 150.00, 10.00, 140.00, 'Paid', 'Insurance'),
(211, 113, 13, 20260107, '11:00:00', 'Specialist Care', 200.00, 20.00, 180.00, 'Paid', 'Credit Card'),
(212, 115, 15, 20260108, '12:15:00', 'OPD Bill', 150.00, 0.00, 150.00, 'Unpaid', NULL),
(213, 116, 16, 20260108, '13:45:00', 'OPD Bill', 100.00, 5.00, 95.00, 'Paid', 'UPI'),
(214, 118, 18, 20260109, '14:45:00', 'Specialist Care', 200.00, 10.00, 190.00, 'Paid', 'Insurance'),
(215, 119, 19, 20260110, '15:30:00', 'OPD Bill', 150.00, 0.00, 150.00, 'Paid', 'Cash'),
(216, 120, 20, 20260110, '16:00:00', 'OPD Bill', 100.00, 0.00, 100.00, 'Partially Paid', 'Debit Card'),
(217, 121, 21, 20260111, '10:00:00', 'OPD Bill', 150.00, 15.00, 135.00, 'Paid', 'Credit Card'),
(218, 122, 22, 20260111, '10:45:00', 'Specialist Care', 200.00, 0.00, 200.00, 'Paid', 'Insurance'),
(219, 124, 24, 20260112, '12:15:00', 'OPD Bill', 150.00, 10.00, 140.00, 'Paid', 'UPI'),
(220, 125, 25, 20260113, '14:00:00', 'Routine Checkup', 80.00, 0.00, 80.00, 'Paid', 'Cash'),
(221, 126, 26, 20260113, '14:45:00', 'Specialist Care', 200.00, 20.00, 180.00, 'Paid', 'Insurance'),
(222, 127, 27, 20260114, '15:15:00', 'OPD Bill', 100.00, 0.00, 100.00, 'Unpaid', NULL),
(223, 129, 29, 20260115, '16:15:00', 'Specialist Care', 200.00, 10.00, 190.00, 'Paid', 'Credit Card'),
(224, 130, 30, 20260115, '16:45:00', 'Routine Checkup', 80.00, 5.00, 75.00, 'Paid', 'UPI'),
(225, NULL, 11, 20260116, '11:00:00', 'IPD Final Bill', 2500.00, 250.00, 2250.00, 'Paid', 'Insurance'),
(226, NULL, 12, 20260116, '14:20:00', 'Pharmacy Purchase', 350.00, 10.00, 340.00, 'Paid', 'Credit Card'),
(227, NULL, 13, 20260117, '09:30:00', 'Lab Services', 450.00, 20.00, 430.00, 'Paid', 'Debit Card'),
(228, NULL, 14, 20260117, '11:15:00', 'IPD Final Bill', 3800.00, 300.00, 3500.00, 'Paid', 'Insurance'),
(229, NULL, 15, 20260118, '13:00:00', 'Radiology Exam', 650.00, 50.00, 600.00, 'Paid', 'UPI'),
(230, NULL, 16, 20260118, '15:40:00', 'Pharmacy Purchase', 210.00, 0.00, 210.00, 'Paid', 'Cash');

-- 3. fact_insurance_claims (30 records)
INSERT INTO fact_insurance_claims (claim_id, billing_id, insurance_id, claim_date_key, claim_amount, approved_amount, co_pay_amount, claim_status) VALUES
(301, 203, 501, 20260102, 135.00, 120.00, 15.00, 'Approved'),
(302, 208, 502, 20260105, 200.00, 180.00, 20.00, 'Approved'),
(303, 210, 503, 20260106, 140.00, 130.00, 10.00, 'Approved'),
(304, 211, 501, 20260107, 180.00, 150.00, 30.00, 'Approved'),
(305, 214, 502, 20260109, 190.00, 170.00, 20.00, 'Approved'),
(306, 218, 503, 20260111, 200.00, 200.00, 0.00, 'Approved'),
(307, 221, 501, 20260113, 180.00, 160.00, 20.00, 'Approved'),
(308, 225, 502, 20260116, 2250.00, 2000.00, 250.00, 'Approved'),
(309, 228, 503, 20260117, 3500.00, 3200.00, 300.00, 'Approved'),
(310, 201, 501, 20260118, 140.00, 0.00, 140.00, 'Rejected'),
(311, 204, 502, 20260118, 180.00, 150.00, 30.00, 'Approved'),
(312, 206, 504, 20260119, 95.00, 95.00, 0.00, 'Approved'),
(313, 207, 501, 20260119, 150.00, 0.00, 0.00, 'Pending'),
(314, 209, 502, 20260120, 100.00, 80.00, 20.00, 'Approved'),
(315, 212, 503, 20260120, 150.00, 0.00, 0.00, 'Pending'),
(316, 213, 504, 20260121, 95.00, 85.00, 10.00, 'Approved'),
(317, 215, 501, 20260121, 150.00, 130.00, 20.00, 'Approved'),
(318, 216, 502, 20260122, 100.00, 0.00, 100.00, 'Rejected'),
(319, 217, 503, 20260122, 135.00, 125.00, 10.00, 'Approved'),
(320, 219, 504, 20260123, 140.00, 140.00, 0.00, 'Approved'),
(321, 220, 501, 20260123, 80.00, 70.00, 10.00, 'Approved'),
(322, 222, 502, 20260124, 100.00, 0.00, 0.00, 'In Review'),
(323, 223, 503, 20260124, 190.00, 175.00, 15.00, 'Approved'),
(324, 224, 504, 20260125, 75.00, 75.00, 0.00, 'Approved'),
(325, 226, 501, 20260125, 340.00, 300.00, 40.00, 'Approved'),
(326, 227, 502, 20260126, 430.00, 400.00, 30.00, 'Approved'),
(327, 229, 503, 20260126, 600.00, 550.00, 50.00, 'Approved'),
(328, 230, 504, 20260127, 210.00, 190.00, 20.00, 'Approved'),
(329, 202, 501, 20260127, 100.00, 0.00, 0.00, 'In Review'),
(330, 205, 502, 20260128, 150.00, 120.00, 30.00, 'Approved');

-- 4. fact_waiting_time (30 records)
INSERT INTO fact_waiting_time (waiting_id, appointment_id, patient_id, department_id, doctor_id, date_key, check_in_time, consultation_start_time, waiting_duration_minutes) VALUES
(401, 101, 1, 1, 101, 20260101, '08:45:00', '09:05:00', 20),
(402, 102, 2, 2, 102, 20260101, '09:20:00', '09:35:00', 15),
(403, 103, 3, 1, 101, 20260102, '09:40:00', '10:10:00', 30),
(404, 105, 5, 4, 104, 20260103, '10:50:00', '11:05:00', 15),
(405, 106, 6, 2, 102, 20260103, '11:15:00', '11:40:00', 25),
(406, 108, 8, 3, 103, 20260104, '14:10:00', '14:35:00', 25),
(407, 109, 9, 1, 101, 20260105, '14:30:00', '15:10:00', 40),
(408, 110, 10, 4, 104, 20260105, '15:20:00', '15:35:00', 15),
(409, 111, 11, 2, 102, 20260106, '08:50:00', '09:05:00', 15),
(410, 112, 12, 5, 105, 20260106, '09:10:00', '09:40:00', 30),
(411, 113, 13, 3, 103, 20260107, '10:00:00', '10:20:00', 20),
(412, 115, 15, 4, 104, 20260108, '11:15:00', '11:35:00', 20),
(413, 116, 16, 2, 102, 20260108, '12:40:00', '13:05:00', 25),
(414, 118, 18, 3, 103, 20260109, '13:45:00', '14:15:00', 30),
(415, 119, 19, 1, 101, 20260110, '14:30:00', '14:50:00', 20),
(416, 120, 20, 4, 104, 20260110, '15:00:00', '15:20:00', 20),
(417, 121, 21, 2, 102, 20260111, '09:00:00', '09:20:00', 20),
(418, 122, 22, 5, 105, 20260111, '09:45:00', '10:10:00', 25),
(419, 124, 24, 1, 101, 20260112, '11:10:00', '11:35:00', 25),
(420, 125, 25, 4, 104, 20260113, '13:00:00', '13:20:00', 20),
(421, 126, 26, 2, 102, 20260113, '13:35:00', '14:10:00', 35),
(422, 127, 27, 5, 105, 20260114, '14:15:00', '14:35:00', 20),
(423, 129, 29, 1, 101, 20260115, '15:15:00', '15:35:00', 20),
(424, 130, 30, 4, 104, 20260115, '15:50:00', '16:05:00', 15),
(425, 101, 1, 1, 101, 20260116, '08:40:00', '09:00:00', 20),
(426, 102, 2, 2, 102, 20260116, '09:15:00', '09:45:00', 30),
(427, 103, 3, 1, 101, 20260117, '09:50:00', '10:05:00', 15),
(428, 105, 5, 4, 104, 20260117, '10:40:00', '11:10:00', 30),
(429, 106, 6, 2, 102, 20260118, '11:20:00', '11:35:00', 15),
(430, 108, 8, 3, 103, 20260118, '14:05:00', '14:40:00', 35);

-- 5. fact_patient_feedback (30 records)
INSERT INTO fact_patient_feedback (feedback_id, patient_id, doctor_id, department_id, date_key, doctor_rating, facility_rating, overall_satisfaction_score, comments) VALUES
(501, 1, 101, 1, 20260101, 5, 4, 9, 'Doctor was very attentive and helpful.'),
(502, 2, 102, 2, 20260101, 4, 4, 8, 'Quick appointment process.'),
(503, 3, 101, 1, 20260102, 5, 3, 8, 'Waiting area was slightly crowded.'),
(504, 5, 104, 4, 20260103, 4, 5, 9, 'Clean facility and polite nursing staff.'),
(505, 6, 102, 2, 20260103, 3, 3, 6, 'Longer delay than expected.'),
(506, 8, 103, 3, 20260104, 5, 5, 10, 'Outstanding experience.'),
(507, 9, 101, 1, 20260105, 2, 3, 5, 'Doctor seemed rushed due to heavy flow.'),
(508, 10, 104, 4, 20260105, 4, 4, 8, 'Satisfactory services overall.'),
(509, 11, 102, 2, 20260106, 5, 4, 9, 'Great post-discharge care guidance.'),
(510, 12, 105, 5, 20260106, 3, 2, 5, 'Parking space was difficult to find.'),
(511, 13, 103, 3, 20260107, 4, 4, 8, 'Friendly staff at consultation counter.'),
(512, 15, 104, 4, 20260108, 5, 4, 9, 'Doctor answered all my questions clearly.'),
(513, 16, 102, 2, 20260108, 4, 3, 7, 'Treatment plan explained well.'),
(514, 18, 103, 3, 20260109, 5, 5, 10, 'Seamless check-in and checkout.'),
(515, 19, 101, 1, 20260110, 4, 4, 8, 'Good experience overall.'),
(516, 20, 104, 4, 20260110, 3, 4, 7, 'A bit noisy in the waiting hall.'),
(517, 21, 102, 2, 20260111, 5, 5, 10, 'Prompt service and great doctor.'),
(518, 22, 105, 5, 20260111, 4, 3, 7, 'Facility condition was decent.'),
(519, 24, 101, 1, 20260112, 5, 4, 9, 'Very professional consultation.'),
(520, 25, 104, 4, 20260113, 4, 4, 8, 'Smooth process throughout.'),
(521, 26, 102, 2, 20260113, 2, 2, 4, 'Long waiting duration.'),
(522, 27, 105, 5, 20260114, 4, 5, 9, 'Clean and hygienic premises.'),
(523, 29, 101, 1, 20260115, 5, 5, 10, 'Exceeded my expectations.'),
(524, 30, 104, 4, 20260115, 3, 3, 6, 'Average overall care service.'),
(525, 1, 101, 1, 20260116, 4, 4, 8, 'Follow-up visit was quick.'),
(526, 2, 102, 2, 20260116, 5, 4, 9, 'Helpful desk support team.'),
(527, 3, 101, 1, 20260117, 4, 4, 8, 'Good consultation depth.'),
(528, 5, 104, 4, 20260117, 5, 5, 10, 'Top-tier medical facility.'),
(529, 6, 102, 2, 20260118, 3, 4, 7, 'Doctor was helpful but late.'),
(530, 8, 103, 3, 20260118, 5, 4, 9, 'Consistent quality of care.');

-- 6. fact_radiology (30 records)
INSERT INTO fact_radiology (radiology_id, patient_id, doctor_id, date_key, modality, body_part, radiology_fee, finding_summary, urgency_level) VALUES
(601, 1, 101, 20260101, 'X-Ray', 'Chest', 120.00, 'Clear lungs, no visible congestion.', 'Routine'),
(602, 3, 101, 20260102, 'MRI', 'Brain', 850.00, 'Mild inflammation observed.', 'Urgent'),
(603, 5, 104, 20260103, 'Ultrasound', 'Abdomen', 250.00, 'Gallbladder normal, no stones.', 'Routine'),
(604, 6, 102, 20260103, 'CT Scan', 'Lumbar Spine', 600.00, 'L4-L5 disc bulge detected.', 'Urgent'),
(605, 8, 103, 20260104, 'X-Ray', 'Left Knee', 120.00, 'No acute fracture detected.', 'Routine'),
(606, 9, 101, 20260105, 'CT Scan', 'Chest', 650.00, 'Minor infection patch in lower lobe.', 'Urgent'),
(607, 10, 104, 20260105, 'MRI', 'Right Shoulder', 800.00, 'Partial rotator cuff tear.', 'Routine'),
(608, 11, 102, 20260106, 'X-Ray', 'Wrist', 100.00, 'Hairline fracture confirmed.', 'Urgent'),
(609, 12, 103, 20260106, 'Ultrasound', 'Pelvis', 280.00, 'No structural abnormalities seen.', 'Routine'),
(610, 2, 102, 20260107, 'MRI', 'Cervical Spine', 850.00, 'Degenerative changes consistent with age.', 'Routine'),
(611, 13, 103, 20260107, 'CT Scan', 'Abdomen', 620.00, 'Small kidney stone noted on left.', 'Urgent'),
(612, 15, 104, 20260108, 'X-Ray', 'Foot', 110.00, 'Soft tissue swelling only.', 'Routine'),
(613, 16, 102, 20260108, 'Ultrasound', 'Thyroid', 230.00, 'Benign nodule identified.', 'Routine'),
(614, 18, 103, 20260109, 'MRI', 'Knee', 820.00, 'Meniscus tear detected.', 'Urgent'),
(615, 19, 101, 20260110, 'X-Ray', 'Chest', 120.00, 'Normal lung fields.', 'Routine'),
(616, 20, 104, 20260110, 'CT Scan', 'Head', 700.00, 'No acute intracranial hemorrhage.', 'Emergency'),
(617, 21, 102, 20260111, 'Ultrasound', 'Carotid', 300.00, 'Minor plaque build-up.', 'Routine'),
(618, 22, 105, 20260111, 'MRI', 'Brain', 880.00, 'Stable scan, no progression.', 'Routine'),
(619, 24, 101, 20260112, 'X-Ray', 'Hand', 100.00, 'Dislocation reduced.', 'Routine'),
(620, 25, 104, 20260113, 'CT Scan', 'Pelvis', 640.00, 'No bone lesion identified.', 'Routine'),
(621, 26, 102, 20260113, 'Ultrasound', 'Liver', 260.00, 'Mild fatty liver changes.', 'Routine'),
(622, 27, 105, 20260114, 'X-Ray', 'Chest', 120.00, 'Clear lung fields.', 'Routine'),
(623, 29, 101, 20260115, 'MRI', 'Lumbar Spine', 840.00, 'Mild spinal stenosis.', 'Urgent'),
(624, 30, 104, 20260115, 'CT Scan', 'Sinus', 580.00, 'Chronic sinusitis findings.', 'Routine'),
(625, 1, 101, 20260116, 'X-Ray', 'Ankle', 110.00, 'Sprain, no fracture.', 'Routine'),
(626, 2, 102, 20260116, 'Ultrasound', 'Abdomen', 250.00, 'Unremarkable scan.', 'Routine'),
(627, 3, 101, 20260117, 'CT Scan', 'Chest', 650.00, 'Resolution of prior patch.', 'Routine'),
(628, 5, 104, 20260117, 'MRI', 'Shoulder', 810.00, 'Intact tendons.', 'Routine'),
(629, 6, 102, 20260118, 'X-Ray', 'Chest', 120.00, 'Clear lungs.', 'Routine'),
(630, 8, 103, 20260118, 'Ultrasound', 'Vascular', 320.00, 'Normal blood flow.', 'Routine');

-- 7. fact_discharge (30 records)
INSERT INTO fact_discharge (discharge_id, patient_id, doctor_id, admission_date_key, discharge_date_key, discharge_type, length_of_stay_days, total_discharge_cost, readmission_risk_score) VALUES
(701, 11, 102, 20260101, 20260106, 'Regular', 5, 4200.00, 'Low'),
(702, 12, 103, 20260102, 20260105, 'Regular', 3, 2800.00, 'Low'),
(703, 13, 101, 20260101, 20260108, 'Regular', 7, 7500.00, 'Medium'),
(704, 14, 104, 20260103, 20260104, 'LAMA', 1, 1100.00, 'High'),
(705, 15, 105, 20260104, 20260109, 'Regular', 5, 5300.00, 'Low'),
(706, 16, 102, 20260105, 20260111, 'Transferred', 6, 6200.00, 'High'),
(707, 17, 103, 20260106, 20260110, 'Regular', 4, 3900.00, 'Low'),
(708, 18, 101, 20260107, 20260112, 'Regular', 5, 4800.00, 'Medium'),
(709, 19, 104, 20260108, 20260114, 'Regular', 6, 6100.00, 'Low'),
(710, 20, 105, 20260109, 20260113, 'Regular', 4, 3600.00, 'Low'),
(711, 21, 102, 20260110, 20260112, 'Regular', 2, 2200.00, 'Low'),
(712, 22, 103, 20260110, 20260115, 'Regular', 5, 4900.00, 'Medium'),
(713, 23, 101, 20260111, 20260117, 'Regular', 6, 5800.00, 'Low'),
(714, 24, 104, 20260112, 20260113, 'LAMA', 1, 1200.00, 'High'),
(715, 25, 105, 20260112, 20260116, 'Regular', 4, 4100.00, 'Low'),
(716, 26, 102, 20260113, 20260118, 'Regular', 5, 5000.00, 'Medium'),
(717, 27, 103, 20260114, 20260119, 'Transferred', 5, 5500.00, 'High'),
(718, 28, 101, 20260114, 20260117, 'Regular', 3, 3100.00, 'Low'),
(719, 29, 104, 20260115, 20260121, 'Regular', 6, 6400.00, 'Medium'),
(720, 30, 105, 20260115, 20260118, 'Regular', 3, 2900.00, 'Low'),
(721, 1, 102, 20260116, 20260120, 'Regular', 4, 4300.00, 'Low'),
(722, 2, 103, 20260116, 20260122, 'Regular', 6, 6000.00, 'Medium'),
(723, 3, 101, 20260117, 20260119, 'Regular', 2, 2100.00, 'Low'),
(724, 4, 104, 20260117, 20260123, 'Regular', 6, 6300.00, 'Medium'),
(725, 5, 105, 20260118, 20260121, 'LAMA', 3, 3000.00, 'High'),
(726, 6, 102, 20260118, 20260124, 'Regular', 6, 6100.00, 'Low'),
(727, 7, 103, 20260119, 20260123, 'Regular', 4, 4200.00, 'Low'),
(728, 8, 101, 20260119, 20260125, 'Transferred', 6, 6700.00, 'High'),
(729, 9, 104, 20260120, 20260124, 'Regular', 4, 4000.00, 'Low'),
(730, 10, 105, 20260120, 20260126, 'Regular', 6, 6200.00, 'Medium');

-- 8. fact_bed_occupancy (30 records)
INSERT INTO fact_bed_occupancy (occupancy_id, discharge_id, ward_id, bed_number, date_key, occupancy_status, daily_bed_rate) VALUES
(801, 701, 10, 'B-101', 20260106, 'Available', 200.00),
(802, 702, 10, 'B-102', 20260105, 'Cleaning', 200.00),
(803, 703, 12, 'ICU-04', 20260108, 'Occupied', 800.00),
(804, 704, 11, 'B-205', 20260104, 'Available', 250.00),
(805, 705, 10, 'B-103', 20260109, 'Maintenance', 200.00),
(806, 706, 12, 'ICU-01', 20260111, 'Cleaning', 800.00),
(807, 707, 11, 'B-202', 20260110, 'Available', 250.00),
(808, 708, 10, 'B-105', 20260112, 'Occupied', 200.00),
(809, 709, 11, 'B-208', 20260114, 'Cleaning', 250.00),
(810, 710, 10, 'B-108', 20260113, 'Available', 200.00),
(811, 711, 11, 'B-210', 20260112, 'Available', 250.00),
(812, 712, 10, 'B-112', 20260115, 'Cleaning', 200.00),
(813, 713, 12, 'ICU-02', 20260117, 'Occupied', 800.00),
(814, 714, 11, 'B-212', 20260113, 'Available', 250.00),
(815, 715, 10, 'B-115', 20260116, 'Maintenance', 200.00),
(816, 716, 12, 'ICU-05', 20260118, 'Cleaning', 800.00),
(817, 717, 11, 'B-215', 20260119, 'Available', 250.00),
(818, 718, 10, 'B-118', 20260117, 'Occupied', 200.00),
(819, 719, 11, 'B-218', 20260121, 'Cleaning', 250.00),
(820, 720, 10, 'B-120', 20260118, 'Available', 200.00),
(821, 721, 11, 'B-220', 20260120, 'Available', 250.00),
(822, 722, 10, 'B-122', 20260122, 'Cleaning', 200.00),
(823, 723, 12, 'ICU-03', 20260119, 'Occupied', 800.00),
(824, 724, 11, 'B-222', 20260123, 'Available', 250.00),
(825, 725, 10, 'B-125', 20260121, 'Maintenance', 200.00),
(826, 726, 12, 'ICU-06', 20260124, 'Cleaning', 800.00),
(827, 727, 11, 'B-225', 20260123, 'Available', 250.00),
(828, 728, 10, 'B-128', 20260125, 'Occupied', 200.00),
(829, 729, 11, 'B-228', 20260124, 'Cleaning', 250.00),
(830, 730, 10, 'B-130', 20260126, 'Available', 200.00);

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------------------
-- 4. RECORD COUNT SUMMARY
-- -------------------------------------------------------------------------

SELECT 'fact_appointments' AS Table_Name, COUNT(*) AS Total_Records FROM fact_appointments
UNION ALL SELECT 'fact_billing', COUNT(*) FROM fact_billing
UNION ALL SELECT 'fact_insurance_claims', COUNT(*) FROM fact_insurance_claims
UNION ALL SELECT 'fact_waiting_time', COUNT(*) FROM fact_waiting_time
UNION ALL SELECT 'fact_patient_feedback', COUNT(*) FROM fact_patient_feedback
UNION ALL SELECT 'fact_radiology', COUNT(*) FROM fact_radiology
UNION ALL SELECT 'fact_discharge', COUNT(*) FROM fact_discharge
UNION ALL SELECT 'fact_bed_occupancy', COUNT(*) FROM fact_bed_occupancy;

-- -------------------------------------------------------------------------
-- 5. SHOW ALL INDIVIDUAL TABLES
-- -------------------------------------------------------------------------

SELECT * FROM fact_appointments;
SELECT * FROM fact_billing;
SELECT * FROM fact_insurance_claims;
SELECT * FROM fact_waiting_time;
SELECT * FROM fact_patient_feedback;
SELECT * FROM fact_radiology;
SELECT * FROM fact_discharge;
SELECT * FROM fact_bed_occupancy;