/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 1 - Basic Analytical Queries
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- PATIENT ANALYTICS
-- =============================================================================

-- Query 1 : Total Patients
SELECT COUNT(*) AS total_patients
FROM dim_patient;


-- Query 2 : Active Patients
SELECT COUNT(*) AS active_patients
FROM dim_patient
WHERE is_active = TRUE;


-- Query 3 : Male vs Female Patients
SELECT
    gender,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY gender
ORDER BY total_patients DESC;


-- Query 4 : Patients by Blood Group
SELECT
    blood_group,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY blood_group
ORDER BY total_patients DESC;


-- Query 5 : Patients by City
SELECT
    city,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY city
ORDER BY total_patients DESC;


-- Query 6 : Patients by State
SELECT
    state,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY state
ORDER BY total_patients DESC;


-- =============================================================================
-- DOCTOR ANALYTICS
-- =============================================================================

-- Query 7 : Total Doctors
SELECT COUNT(*) AS total_doctors
FROM dim_doctor;


-- Query 8 : Doctors by Department
SELECT
    department_id,
    COUNT(*) AS total_doctors
FROM dim_doctor
GROUP BY department_id
ORDER BY total_doctors DESC;


-- Query 9 : Doctors by Specialization
SELECT
    specialization,
    COUNT(*) AS total_doctors
FROM dim_doctor
GROUP BY specialization
ORDER BY total_doctors DESC;


-- Query 10 : Average Consultation Fee
SELECT
    ROUND(AVG(consultation_fee),2) AS average_consultation_fee
FROM dim_doctor;


-- =============================================================================
-- DEPARTMENT ANALYTICS
-- =============================================================================

-- Query 11 : Total Departments
SELECT COUNT(*) AS total_departments
FROM dim_department;


-- Query 12 : Departments by Type
SELECT
    department_type,
    COUNT(*) AS total_departments
FROM dim_department
GROUP BY department_type;


-- =============================================================================
-- BED ANALYTICS
-- =============================================================================

-- Query 13 : Available Beds
SELECT COUNT(*) AS available_beds
FROM dim_bed
WHERE bed_status='Available';


-- Query 14 : Occupied Beds
SELECT COUNT(*) AS occupied_beds
FROM dim_bed
WHERE bed_status='Occupied';


-- Query 15 : Beds by Type
SELECT
    bed_type,
    COUNT(*) AS total_beds
FROM dim_bed
GROUP BY bed_type;


-- =============================================================================
-- MEDICINE ANALYTICS
-- =============================================================================

-- Query 16 : Total Medicines
SELECT COUNT(*) AS total_medicines
FROM dim_medicine;


-- Query 17 : Medicines by Category
SELECT
    category,
    COUNT(*) AS total_medicines
FROM dim_medicine
GROUP BY category
ORDER BY total_medicines DESC;


-- =============================================================================
-- LAB ANALYTICS
-- =============================================================================

-- Query 18 : Total Lab Tests
SELECT COUNT(*) AS total_lab_tests
FROM dim_lab_test;


-- Query 19 : Lab Tests by Category
SELECT
    category,
    COUNT(*) AS total_tests
FROM dim_lab_test
GROUP BY category
ORDER BY total_tests DESC;


-- =============================================================================
-- INSURANCE ANALYTICS
-- =============================================================================

-- Query 20 : Insurance Companies
SELECT COUNT(*) AS total_insurance_companies
FROM dim_insurance;


-- =============================================================================
-- DATE DIMENSION ANALYTICS
-- =============================================================================

-- Query 21 : Years Available
SELECT DISTINCT calendar_year
FROM dim_date
ORDER BY calendar_year;


-- Query 22 : Months Available
SELECT DISTINCT month_name
FROM dim_date
ORDER BY month_number;


-- =============================================================================
-- APPOINTMENT ANALYTICS
-- =============================================================================

-- Query 23 : Total Appointments
SELECT COUNT(*) AS total_appointments
FROM fact_appointments;


-- Query 24 : Appointments by Status
SELECT
    status,
    COUNT(*) AS total
FROM fact_appointments
GROUP BY status
ORDER BY total DESC;


-- =============================================================================
-- BILLING ANALYTICS
-- =============================================================================

-- Query 25 : Total Bills
SELECT COUNT(*) AS total_bills
FROM fact_billing;


-- Query 26 : Total Revenue
SELECT
    ROUND(SUM(net_amount),2) AS total_revenue
FROM fact_billing;


-- Query 27 : Average Bill Value
SELECT
    ROUND(AVG(net_amount),2) AS average_bill
FROM fact_billing;


-- Query 28 : Highest Bill
SELECT MAX(net_amount) AS highest_bill
FROM fact_billing;


-- Query 29 : Lowest Bill
SELECT MIN(net_amount) AS lowest_bill
FROM fact_billing;


-- =============================================================================
-- INSURANCE CLAIM ANALYTICS
-- =============================================================================

-- Query 30 : Total Insurance Claims
SELECT COUNT(*) AS total_claims
FROM fact_insurance_claims;


/*==============================================================================
 END OF PART 1
==============================================================================*/

/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 2 - Aggregate Functions & GROUP BY
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- PATIENT ANALYTICS
-- =============================================================================

-- Query 31 : Patients by Marital Status
SELECT
    marital_status,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY marital_status
ORDER BY total_patients DESC;


-- Query 32 : Patients by Occupation
SELECT
    occupation,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY occupation
ORDER BY total_patients DESC;


-- Query 33 : Average Patient Age
SELECT
    ROUND(AVG(age),2) AS average_age
FROM dim_patient;


-- Query 34 : Youngest Patient
SELECT
    MIN(age) AS youngest_patient
FROM dim_patient;


-- Query 35 : Oldest Patient
SELECT
    MAX(age) AS oldest_patient
FROM dim_patient;


-- =============================================================================
-- DOCTOR ANALYTICS
-- =============================================================================

-- Query 36 : Average Experience by Specialization
SELECT
    specialization,
    ROUND(AVG(experience_years),2) AS average_experience
FROM dim_doctor
GROUP BY specialization
ORDER BY average_experience DESC;


-- Query 37 : Average Consultation Fee by Department
SELECT
    department_id,
    ROUND(AVG(consultation_fee),2) AS average_fee
FROM dim_doctor
GROUP BY department_id
ORDER BY average_fee DESC;


-- Query 38 : Maximum Consultation Fee
SELECT
    MAX(consultation_fee) AS highest_fee
FROM dim_doctor;


-- Query 39 : Minimum Consultation Fee
SELECT
    MIN(consultation_fee) AS lowest_fee
FROM dim_doctor;


-- Query 40 : Doctors Having More Than 10 Years Experience
SELECT
    specialization,
    COUNT(*) AS experienced_doctors
FROM dim_doctor
WHERE experience_years > 10
GROUP BY specialization
ORDER BY experienced_doctors DESC;


-- =============================================================================
-- DEPARTMENT ANALYTICS
-- =============================================================================

-- Query 41 : Departments Having More Than 20 Beds
SELECT
    department_name,
    total_beds
FROM dim_department
WHERE total_beds > 20
ORDER BY total_beds DESC;


-- Query 42 : Average Consultation Fee by Department
SELECT
    department_name,
    consultation_fee
FROM dim_department
ORDER BY consultation_fee DESC;


-- =============================================================================
-- WARD ANALYTICS
-- =============================================================================

-- Query 43 : Beds Available in Each Ward
SELECT
    ward_id,
    COUNT(*) AS total_beds
FROM dim_bed
GROUP BY ward_id
ORDER BY total_beds DESC;


-- Query 44 : Available Beds by Ward
SELECT
    ward_id,
    COUNT(*) AS available_beds
FROM dim_bed
WHERE bed_status = 'Available'
GROUP BY ward_id
ORDER BY available_beds DESC;


-- Query 45 : Occupied Beds by Ward
SELECT
    ward_id,
    COUNT(*) AS occupied_beds
FROM dim_bed
WHERE bed_status = 'Occupied'
GROUP BY ward_id
ORDER BY occupied_beds DESC;


-- =============================================================================
-- MEDICINE ANALYTICS
-- =============================================================================

-- Query 46 : Average Medicine Price
SELECT
    ROUND(AVG(unit_price),2) AS average_price
FROM dim_medicine;


-- Query 47 : Highest Medicine Price
SELECT
    MAX(unit_price) AS highest_price
FROM dim_medicine;


-- Query 48 : Lowest Medicine Price
SELECT
    MIN(unit_price) AS lowest_price
FROM dim_medicine;


-- =============================================================================
-- LAB TEST ANALYTICS
-- =============================================================================

-- Query 49 : Average Test Price
SELECT
    ROUND(AVG(test_price),2) AS average_test_price
FROM dim_lab_test;


-- Query 50 : Highest Test Price
SELECT
    MAX(test_price) AS highest_test_price
FROM dim_lab_test;


-- =============================================================================
-- BILLING ANALYTICS
-- =============================================================================

-- Query 51 : Total Discount Given
SELECT
    ROUND(SUM(discount_amount),2) AS total_discount
FROM fact_billing;


-- Query 52 : Total Tax Collected
SELECT
    ROUND(SUM(tax_amount),2) AS total_tax
FROM fact_billing;


-- Query 53 : Average Tax Per Bill
SELECT
    ROUND(AVG(tax_amount),2) AS average_tax
FROM fact_billing;


-- Query 54 : Revenue by Payment Mode
SELECT
    payment_mode_id,
    ROUND(SUM(net_amount),2) AS revenue
FROM fact_billing
GROUP BY payment_mode_id
ORDER BY revenue DESC;


-- Query 55 : Revenue by Department
SELECT
    department_id,
    ROUND(SUM(net_amount),2) AS revenue
FROM fact_billing
GROUP BY department_id
ORDER BY revenue DESC;


-- =============================================================================
-- INSURANCE ANALYTICS
-- =============================================================================

-- Query 56 : Claims by Status
SELECT
    claim_status,
    COUNT(*) AS total_claims
FROM fact_insurance_claims
GROUP BY claim_status
ORDER BY total_claims DESC;


-- Query 57 : Total Approved Claim Amount
SELECT
    ROUND(SUM(claim_amount),2) AS approved_amount
FROM fact_insurance_claims
WHERE claim_status='Approved';


-- Query 58 : Total Pending Claim Amount
SELECT
    ROUND(SUM(claim_amount),2) AS pending_amount
FROM fact_insurance_claims
WHERE claim_status='Pending';


-- =============================================================================
-- FEEDBACK ANALYTICS
-- =============================================================================

-- Query 59 : Average Patient Rating
SELECT
    ROUND(AVG(rating),2) AS average_rating
FROM fact_patient_feedback;


-- Query 60 : Rating Distribution
SELECT
    rating,
    COUNT(*) AS total_feedback
FROM fact_patient_feedback
GROUP BY rating
ORDER BY rating DESC;


/*==============================================================================
 END OF PART 2
==============================================================================*/

/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 3 - JOIN Queries
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- INNER JOIN QUERIES
-- =============================================================================

-- Query 61 : Appointment Details with Patient Information

SELECT
    fa.appointment_id,
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    fa.status
FROM fact_appointments fa
INNER JOIN dim_patient dp
ON fa.patient_id = dp.patient_id;



-- Query 62 : Appointment Details with Doctor Information

SELECT
    fa.appointment_id,
    dd.doctor_code,
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    dd.specialization,
    fa.status
FROM fact_appointments fa
INNER JOIN dim_doctor dd
ON fa.doctor_id = dd.doctor_id;



-- Query 63 : Doctor with Department

SELECT
    dd.doctor_code,
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    dep.department_name
FROM dim_doctor dd
INNER JOIN dim_department dep
ON dd.department_id = dep.department_id;



-- Query 64 : Patient Billing Details

SELECT
    fb.bill_id,
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    fb.net_amount
FROM fact_billing fb
INNER JOIN dim_patient dp
ON fb.patient_id = dp.patient_id;



-- Query 65 : Billing with Payment Mode

SELECT
    fb.bill_id,
    pm.payment_mode_name,
    fb.net_amount
FROM fact_billing fb
INNER JOIN dim_payment_mode pm
ON fb.payment_mode_id = pm.payment_mode_id;



-- Query 66 : Insurance Claim with Company

SELECT
    fic.claim_id,
    di.company_name,
    fic.claim_amount,
    fic.claim_status
FROM fact_insurance_claims fic
INNER JOIN dim_insurance di
ON fic.insurance_id = di.insurance_id;



-- Query 67 : Bed with Ward

SELECT
    b.bed_code,
    w.ward_name,
    b.room_number,
    b.bed_status
FROM dim_bed b
INNER JOIN dim_ward w
ON b.ward_id = w.ward_id;



-- Query 68 : Ward with Department

SELECT
    w.ward_name,
    d.department_name,
    w.total_beds
FROM dim_ward w
INNER JOIN dim_department d
ON w.department_id = d.department_id;



-- Query 69 : Lab Orders with Patient

SELECT
    flo.lab_order_id,
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    flo.test_result
FROM fact_lab_orders flo
INNER JOIN dim_patient dp
ON flo.patient_id = dp.patient_id;



-- Query 70 : Lab Orders with Test Details

SELECT
    flo.lab_order_id,
    lt.test_name,
    lt.category,
    flo.test_result
FROM fact_lab_orders flo
INNER JOIN dim_lab_test lt
ON flo.lab_test_id = lt.lab_test_id;



-- =============================================================================
-- LEFT JOIN QUERIES
-- =============================================================================

-- Query 71 : All Patients with Appointment Status

SELECT
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    fa.status
FROM dim_patient dp
LEFT JOIN fact_appointments fa
ON dp.patient_id = fa.patient_id;



-- Query 72 : All Doctors with Appointments

SELECT
    dd.doctor_code,
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    fa.appointment_id
FROM dim_doctor dd
LEFT JOIN fact_appointments fa
ON dd.doctor_id = fa.doctor_id;



-- Query 73 : Departments with Doctors

SELECT
    dep.department_name,
    dd.doctor_code
FROM dim_department dep
LEFT JOIN dim_doctor dd
ON dep.department_id = dd.department_id;



-- Query 74 : Patients with Insurance Claims

SELECT
    dp.patient_code,
    fic.claim_status
FROM dim_patient dp
LEFT JOIN fact_insurance_claims fic
ON dp.patient_id = fic.patient_id;



-- Query 75 : Patients with Feedback

SELECT
    dp.patient_code,
    fpf.rating
FROM dim_patient dp
LEFT JOIN fact_patient_feedback fpf
ON dp.patient_id = fpf.patient_id;



-- =============================================================================
-- MULTI TABLE JOIN
-- =============================================================================

-- Query 76 : Appointment Report

SELECT
    fa.appointment_id,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    dep.department_name,
    fa.status
FROM fact_appointments fa
INNER JOIN dim_patient dp
ON fa.patient_id = dp.patient_id
INNER JOIN dim_doctor dd
ON fa.doctor_id = dd.doctor_id
INNER JOIN dim_department dep
ON fa.department_id = dep.department_id;



-- Query 77 : Billing Report

SELECT
    fb.bill_id,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    dep.department_name,
    pm.payment_mode_name,
    fb.net_amount
FROM fact_billing fb
INNER JOIN dim_patient dp
ON fb.patient_id = dp.patient_id
INNER JOIN dim_department dep
ON fb.department_id = dep.department_id
INNER JOIN dim_payment_mode pm
ON fb.payment_mode_id = pm.payment_mode_id;



-- Query 78 : Insurance Billing Report

SELECT
    fb.bill_id,
    di.company_name,
    fic.claim_amount,
    fb.net_amount
FROM fact_billing fb
INNER JOIN fact_insurance_claims fic
ON fb.bill_id = fic.bill_id
INNER JOIN dim_insurance di
ON fic.insurance_id = di.insurance_id;



-- Query 79 : Bed Occupancy Report

SELECT
    bo.occupancy_id,
    b.bed_code,
    w.ward_name,
    bo.occupancy_status
FROM fact_bed_occupancy bo
INNER JOIN dim_bed b
ON bo.bed_id = b.bed_id
INNER JOIN dim_ward w
ON b.ward_id = w.ward_id;



-- Query 80 : Complete Patient Hospital Journey

SELECT
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    dd.first_name AS doctor,
    dep.department_name,
    fb.net_amount,
    fa.status
FROM fact_appointments fa
INNER JOIN dim_patient dp
ON fa.patient_id = dp.patient_id
INNER JOIN dim_doctor dd
ON fa.doctor_id = dd.doctor_id
INNER JOIN dim_department dep
ON fa.department_id = dep.department_id
LEFT JOIN fact_billing fb
ON fa.patient_id = fb.patient_id
ORDER BY patient_name;

/*==============================================================================
 END OF PART 3
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 4 - Revenue & Billing Analytics
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REVENUE ANALYTICS
-- =============================================================================

-- Query 81 : Total Hospital Revenue

SELECT
    ROUND(SUM(net_amount),2) AS total_revenue
FROM fact_billing;



-- Query 82 : Total Gross Revenue

SELECT
    ROUND(SUM(gross_amount),2) AS gross_revenue
FROM fact_billing;



-- Query 83 : Total Discount Given

SELECT
    ROUND(SUM(discount_amount),2) AS total_discount
FROM fact_billing;



-- Query 84 : Total Tax Collected

SELECT
    ROUND(SUM(tax_amount),2) AS total_tax
FROM fact_billing;



-- Query 85 : Average Bill Amount

SELECT
    ROUND(AVG(net_amount),2) AS average_bill
FROM fact_billing;



-- =============================================================================
-- PAYMENT MODE ANALYSIS
-- =============================================================================

-- Query 86 : Revenue by Payment Mode

SELECT
    pm.payment_mode_name,
    ROUND(SUM(fb.net_amount),2) AS revenue
FROM fact_billing fb
INNER JOIN dim_payment_mode pm
ON fb.payment_mode_id = pm.payment_mode_id
GROUP BY pm.payment_mode_name
ORDER BY revenue DESC;



-- Query 87 : Number of Bills by Payment Mode

SELECT
    pm.payment_mode_name,
    COUNT(*) AS total_bills
FROM fact_billing fb
INNER JOIN dim_payment_mode pm
ON fb.payment_mode_id = pm.payment_mode_id
GROUP BY pm.payment_mode_name
ORDER BY total_bills DESC;



-- =============================================================================
-- DEPARTMENT REVENUE
-- =============================================================================

-- Query 88 : Revenue by Department

SELECT
    d.department_name,
    ROUND(SUM(fb.net_amount),2) AS revenue
FROM fact_billing fb
INNER JOIN dim_department d
ON fb.department_id = d.department_id
GROUP BY d.department_name
ORDER BY revenue DESC;



-- Query 89 : Average Revenue by Department

SELECT
    d.department_name,
    ROUND(AVG(fb.net_amount),2) AS average_revenue
FROM fact_billing fb
INNER JOIN dim_department d
ON fb.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_revenue DESC;



-- =============================================================================
-- PATIENT BILLING
-- =============================================================================

-- Query 90 : Top 10 Highest Paying Patients

SELECT
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    ROUND(SUM(fb.net_amount),2) AS total_spent
FROM fact_billing fb
INNER JOIN dim_patient dp
ON fb.patient_id = dp.patient_id
GROUP BY dp.patient_id
ORDER BY total_spent DESC
LIMIT 10;



-- Query 91 : Lowest Paying Patients

SELECT
    dp.patient_code,
    CONCAT(dp.first_name,' ',dp.last_name) AS patient_name,
    ROUND(SUM(fb.net_amount),2) AS total_spent
FROM fact_billing fb
INNER JOIN dim_patient dp
ON fb.patient_id = dp.patient_id
GROUP BY dp.patient_id
ORDER BY total_spent ASC
LIMIT 10;



-- =============================================================================
-- DOCTOR REVENUE
-- =============================================================================

-- Query 92 : Revenue Generated by Doctor

SELECT
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    ROUND(SUM(fb.net_amount),2) AS revenue
FROM fact_billing fb
INNER JOIN dim_doctor dd
ON fb.doctor_id = dd.doctor_id
GROUP BY dd.doctor_id
ORDER BY revenue DESC;



-- Query 93 : Top 5 Revenue Generating Doctors

SELECT
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    ROUND(SUM(fb.net_amount),2) AS revenue
FROM fact_billing fb
INNER JOIN dim_doctor dd
ON fb.doctor_id = dd.doctor_id
GROUP BY dd.doctor_id
ORDER BY revenue DESC
LIMIT 5;



-- =============================================================================
-- INSURANCE ANALYSIS
-- =============================================================================

-- Query 94 : Total Insurance Claim Amount

SELECT
    ROUND(SUM(claim_amount),2) AS insurance_claim_amount
FROM fact_insurance_claims;



-- Query 95 : Insurance Claim Amount by Company

SELECT
    di.company_name,
    ROUND(SUM(fic.claim_amount),2) AS total_claim
FROM fact_insurance_claims fic
INNER JOIN dim_insurance di
ON fic.insurance_id = di.insurance_id
GROUP BY di.company_name
ORDER BY total_claim DESC;



-- Query 96 : Approved Claims

SELECT
    COUNT(*) AS approved_claims
FROM fact_insurance_claims
WHERE claim_status='Approved';



-- Query 97 : Pending Claims

SELECT
    COUNT(*) AS pending_claims
FROM fact_insurance_claims
WHERE claim_status='Pending';



-- Query 98 : Rejected Claims

SELECT
    COUNT(*) AS rejected_claims
FROM fact_insurance_claims
WHERE claim_status='Rejected';



-- =============================================================================
-- BILL STATUS ANALYSIS
-- =============================================================================

-- Query 99 : Bills by Status

SELECT
    payment_status,
    COUNT(*) AS total_bills
FROM fact_billing
GROUP BY payment_status
ORDER BY total_bills DESC;



-- Query 100 : Revenue by Bill Status

SELECT
    payment_status,
    ROUND(SUM(net_amount),2) AS revenue
FROM fact_billing
GROUP BY payment_status
ORDER BY revenue DESC;



/*==============================================================================
 END OF PART 4
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 5 - Patient & Operational Analytics
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- PATIENT ANALYTICS
-- =============================================================================

-- Query 101 : Patients Registered by Year
SELECT
    YEAR(registration_date) AS registration_year,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY YEAR(registration_date)
ORDER BY registration_year;


-- Query 102 : Patients Registered by Month
SELECT
    MONTH(registration_date) AS registration_month,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY MONTH(registration_date)
ORDER BY registration_month;


-- Query 103 : Patient Distribution by Gender
SELECT
    gender,
    COUNT(*) AS total_patients,
    ROUND(COUNT(*) * 100 /
    (SELECT COUNT(*) FROM dim_patient),2) AS percentage
FROM dim_patient
GROUP BY gender;


-- Query 104 : Patient Distribution by Blood Group
SELECT
    blood_group,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY blood_group
ORDER BY total_patients DESC;


-- Query 105 : Top 10 Cities by Patient Count
SELECT
    city,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY city
ORDER BY total_patients DESC
LIMIT 10;


-- =============================================================================
-- APPOINTMENT ANALYTICS
-- =============================================================================

-- Query 106 : Appointment Count by Status
SELECT
    status,
    COUNT(*) AS total_appointments
FROM fact_appointments
GROUP BY status
ORDER BY total_appointments DESC;


-- Query 107 : Completed Appointment Percentage
SELECT
    ROUND(
        SUM(CASE WHEN status='Completed' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),2
    ) AS completed_percentage
FROM fact_appointments;


-- Query 108 : Cancelled Appointment Percentage
SELECT
    ROUND(
        SUM(CASE WHEN status='Cancelled' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),2
    ) AS cancelled_percentage
FROM fact_appointments;


-- Query 109 : No Show Percentage
SELECT
    ROUND(
        SUM(CASE WHEN status='No Show' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),2
    ) AS no_show_percentage
FROM fact_appointments;


-- Query 110 : Appointment Count by Department
SELECT
    d.department_name,
    COUNT(*) AS total_appointments
FROM fact_appointments fa
INNER JOIN dim_department d
ON fa.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_appointments DESC;


-- =============================================================================
-- WAITING TIME ANALYTICS
-- =============================================================================

-- Query 111 : Average Waiting Time
SELECT
    ROUND(AVG(waiting_minutes),2) AS average_waiting_time
FROM fact_waiting_time;


-- Query 112 : Maximum Waiting Time
SELECT
    MAX(waiting_minutes) AS maximum_waiting_time
FROM fact_waiting_time;


-- Query 113 : Minimum Waiting Time
SELECT
    MIN(waiting_minutes) AS minimum_waiting_time
FROM fact_waiting_time;


-- Query 114 : Waiting Time by Department
SELECT
    d.department_name,
    ROUND(AVG(wt.waiting_minutes),2) AS average_waiting_time
FROM fact_waiting_time wt
INNER JOIN dim_department d
ON wt.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_waiting_time DESC;


-- Query 115 : Waiting Time by Doctor
SELECT
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    ROUND(AVG(wt.waiting_minutes),2) AS average_waiting_time
FROM fact_waiting_time wt
INNER JOIN dim_doctor dd
ON wt.doctor_id = dd.doctor_id
GROUP BY dd.doctor_id
ORDER BY average_waiting_time DESC;


-- =============================================================================
-- PATIENT FEEDBACK ANALYTICS
-- =============================================================================

-- Query 116 : Average Patient Rating
SELECT
    ROUND(AVG(rating),2) AS average_rating
FROM fact_patient_feedback;


-- Query 117 : Feedback Rating Distribution
SELECT
    rating,
    COUNT(*) AS total_feedback
FROM fact_patient_feedback
GROUP BY rating
ORDER BY rating DESC;


-- Query 118 : Doctor Wise Average Rating
SELECT
    CONCAT(dd.first_name,' ',dd.last_name) AS doctor_name,
    ROUND(AVG(fp.rating),2) AS average_rating
FROM fact_patient_feedback fp
INNER JOIN dim_doctor dd
ON fp.doctor_id = dd.doctor_id
GROUP BY dd.doctor_id
ORDER BY average_rating DESC;


-- Query 119 : Department Wise Average Rating
SELECT
    d.department_name,
    ROUND(AVG(fp.rating),2) AS average_rating
FROM fact_patient_feedback fp
INNER JOIN dim_department d
ON fp.department_id = d.department_id
GROUP BY d.department_name
ORDER BY average_rating DESC;


-- =============================================================================
-- BED OCCUPANCY ANALYTICS
-- =============================================================================

-- Query 120 : Bed Occupancy Status
SELECT
    occupancy_status,
    COUNT(*) AS total_records
FROM fact_bed_occupancy
GROUP BY occupancy_status
ORDER BY total_records DESC;


/*==============================================================================
 END OF PART 5
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 6 - Doctor & Department Performance Analytics
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- DOCTOR PERFORMANCE ANALYTICS
-- =============================================================================

-- Query 121 : Patients Handled by Each Doctor

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_patients
FROM dim_doctor d
LEFT JOIN fact_appointments a
ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_patients DESC;


-- Query 122 : Top 10 Doctors by Revenue

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    ROUND(SUM(b.net_amount),2) AS total_revenue
FROM fact_billing b
INNER JOIN dim_doctor d
ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 123 : Average Revenue Per Doctor

SELECT
    ROUND(AVG(doctor_revenue),2) AS average_revenue
FROM
(
    SELECT
        doctor_id,
        SUM(net_amount) AS doctor_revenue
    FROM fact_billing
    GROUP BY doctor_id
) x;


-- Query 124 : Doctor Consultation Fee Ranking

SELECT
    doctor_code,
    CONCAT(first_name,' ',last_name) AS doctor_name,
    consultation_fee
FROM dim_doctor
ORDER BY consultation_fee DESC;


-- Query 125 : Doctors with Above Average Consultation Fee

SELECT
    doctor_code,
    CONCAT(first_name,' ',last_name) AS doctor_name,
    consultation_fee
FROM dim_doctor
WHERE consultation_fee >
(
    SELECT AVG(consultation_fee)
    FROM dim_doctor
)
ORDER BY consultation_fee DESC;



-- =============================================================================
-- DEPARTMENT PERFORMANCE
-- =============================================================================

-- Query 126 : Department Wise Revenue

SELECT
    d.department_name,
    ROUND(SUM(b.net_amount),2) AS revenue
FROM fact_billing b
INNER JOIN dim_department d
ON b.department_id=d.department_id
GROUP BY d.department_name
ORDER BY revenue DESC;


-- Query 127 : Department Wise Patient Count

SELECT
    d.department_name,
    COUNT(a.appointment_id) AS patient_count
FROM fact_appointments a
INNER JOIN dim_department d
ON a.department_id=d.department_id
GROUP BY d.department_name
ORDER BY patient_count DESC;


-- Query 128 : Department Wise Average Bill

SELECT
    d.department_name,
    ROUND(AVG(b.net_amount),2) AS average_bill
FROM fact_billing b
INNER JOIN dim_department d
ON b.department_id=d.department_id
GROUP BY d.department_name
ORDER BY average_bill DESC;


-- Query 129 : Department Wise Waiting Time

SELECT
    d.department_name,
    ROUND(AVG(w.waiting_minutes),2) AS average_wait
FROM fact_waiting_time w
INNER JOIN dim_department d
ON w.department_id=d.department_id
GROUP BY d.department_name
ORDER BY average_wait DESC;


-- Query 130 : Top Performing Department

SELECT
    d.department_name,
    ROUND(SUM(b.net_amount),2) AS revenue
FROM fact_billing b
INNER JOIN dim_department d
ON b.department_id=d.department_id
GROUP BY d.department_name
ORDER BY revenue DESC
LIMIT 1;



-- =============================================================================
-- INSURANCE PERFORMANCE
-- =============================================================================

-- Query 131 : Insurance Company Wise Claims

SELECT
    i.company_name,
    COUNT(c.claim_id) AS total_claims
FROM fact_insurance_claims c
INNER JOIN dim_insurance i
ON c.insurance_id=i.insurance_id
GROUP BY i.company_name
ORDER BY total_claims DESC;


-- Query 132 : Insurance Approval Rate

SELECT
ROUND(
SUM(CASE
WHEN claim_status='Approved'
THEN 1 ELSE 0 END)
*100/COUNT(*),2)
AS approval_rate
FROM fact_insurance_claims;


-- Query 133 : Insurance Rejection Rate

SELECT
ROUND(
SUM(CASE
WHEN claim_status='Rejected'
THEN 1 ELSE 0 END)
*100/COUNT(*),2)
AS rejection_rate
FROM fact_insurance_claims;


-- =============================================================================
-- HOSPITAL KPIs
-- =============================================================================

-- Query 134 : Average Revenue Per Patient

SELECT
ROUND(
SUM(net_amount)/
COUNT(DISTINCT patient_id),2)
AS revenue_per_patient
FROM fact_billing;


-- Query 135 : Average Revenue Per Appointment

SELECT
ROUND(
SUM(net_amount)/
COUNT(DISTINCT appointment_id),2)
AS revenue_per_appointment
FROM fact_billing;


-- Query 136 : Patients Without Appointments

SELECT
COUNT(*) AS patients_without_appointments
FROM dim_patient p
LEFT JOIN fact_appointments a
ON p.patient_id=a.patient_id
WHERE a.patient_id IS NULL;


-- Query 137 : Doctors Without Appointments

SELECT
COUNT(*) AS doctors_without_appointments
FROM dim_doctor d
LEFT JOIN fact_appointments a
ON d.doctor_id=a.doctor_id
WHERE a.doctor_id IS NULL;


-- Query 138 : Revenue Per Department

SELECT
department_id,
ROUND(SUM(net_amount),2) AS revenue
FROM fact_billing
GROUP BY department_id
ORDER BY revenue DESC;


-- Query 139 : Total Revenue Collected

SELECT
ROUND(SUM(net_amount),2) AS hospital_revenue
FROM fact_billing;


-- Query 140 : Total Bills Generated

SELECT
COUNT(*) AS total_bills
FROM fact_billing;


/*==============================================================================
 END OF PART 6
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 7 - Advanced SQL (Window Functions & CTE)
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- WINDOW FUNCTIONS
-- =============================================================================

-- Query 141 : Rank Doctors by Revenue

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    SUM(b.net_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(b.net_amount) DESC) AS revenue_rank
FROM fact_billing b
INNER JOIN dim_doctor d
ON b.doctor_id = d.doctor_id
GROUP BY d.doctor_id;



-- Query 142 : Dense Rank Departments by Revenue

SELECT
    dep.department_name,
    SUM(b.net_amount) AS revenue,
    DENSE_RANK() OVER (ORDER BY SUM(b.net_amount) DESC) AS department_rank
FROM fact_billing b
INNER JOIN dim_department dep
ON b.department_id = dep.department_id
GROUP BY dep.department_id;



-- Query 143 : Row Number for Patients

SELECT
    patient_id,
    patient_code,
    CONCAT(first_name,' ',last_name) AS patient_name,
    ROW_NUMBER() OVER (ORDER BY registration_date) AS row_number
FROM dim_patient;



-- Query 144 : Top Revenue Doctor Using ROW_NUMBER()

SELECT *
FROM
(
    SELECT
        d.doctor_code,
        CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
        SUM(b.net_amount) AS revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(b.net_amount) DESC) AS rn
    FROM fact_billing b
    INNER JOIN dim_doctor d
        ON b.doctor_id=d.doctor_id
    GROUP BY d.doctor_id
) t
WHERE rn<=10;



-- =============================================================================
-- RUNNING TOTALS
-- =============================================================================

-- Query 145 : Running Revenue

SELECT
    bill_date,
    net_amount,
    SUM(net_amount)
    OVER(
        ORDER BY bill_date
    ) AS running_revenue
FROM fact_billing
ORDER BY bill_date;



-- Query 146 : Running Total by Department

SELECT
    department_id,
    bill_date,
    net_amount,
    SUM(net_amount)
    OVER(
        PARTITION BY department_id
        ORDER BY bill_date
    ) AS department_running_total
FROM fact_billing;



-- =============================================================================
-- LAG & LEAD
-- =============================================================================

-- Query 147 : Previous Bill Amount

SELECT
    bill_id,
    bill_date,
    net_amount,
    LAG(net_amount)
    OVER(
        ORDER BY bill_date
    ) AS previous_bill
FROM fact_billing;



-- Query 148 : Next Bill Amount

SELECT
    bill_id,
    bill_date,
    net_amount,
    LEAD(net_amount)
    OVER(
        ORDER BY bill_date
    ) AS next_bill
FROM fact_billing;



-- =============================================================================
-- MOVING AVERAGE
-- =============================================================================

-- Query 149 : 7-Day Moving Average Revenue

SELECT
    bill_date,
    net_amount,
    ROUND(
        AVG(net_amount)
        OVER(
            ORDER BY bill_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_average
FROM fact_billing;



-- =============================================================================
-- CTE (COMMON TABLE EXPRESSIONS)
-- =============================================================================

-- Query 150 : Doctors Above Average Revenue

WITH doctor_revenue AS
(
    SELECT
        doctor_id,
        SUM(net_amount) AS revenue
    FROM fact_billing
    GROUP BY doctor_id
)

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    dr.revenue
FROM doctor_revenue dr
INNER JOIN dim_doctor d
ON dr.doctor_id=d.doctor_id
WHERE dr.revenue >
(
    SELECT AVG(revenue)
    FROM doctor_revenue
)
ORDER BY dr.revenue DESC;



-- Query 151 : Departments Above Average Revenue

WITH department_revenue AS
(
    SELECT
        department_id,
        SUM(net_amount) AS revenue
    FROM fact_billing
    GROUP BY department_id
)

SELECT
    dep.department_name,
    revenue
FROM department_revenue r
INNER JOIN dim_department dep
ON r.department_id=dep.department_id
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM department_revenue
)
ORDER BY revenue DESC;



-- =============================================================================
-- NTILE
-- =============================================================================

-- Query 152 : Revenue Quartiles

SELECT
    bill_id,
    net_amount,
    NTILE(4)
    OVER(
        ORDER BY net_amount DESC
    ) AS revenue_quartile
FROM fact_billing;



-- =============================================================================
-- PERCENT RANK
-- =============================================================================

-- Query 153 : Percent Rank of Bills

SELECT
    bill_id,
    net_amount,
    ROUND(
        PERCENT_RANK()
        OVER(
            ORDER BY net_amount
        ),
        4
    ) AS percent_rank
FROM fact_billing;



-- =============================================================================
-- CUME_DIST
-- =============================================================================

-- Query 154 : Revenue Distribution

SELECT
    bill_id,
    net_amount,
    ROUND(
        CUME_DIST()
        OVER(
            ORDER BY net_amount
        ),
        4
    ) AS cumulative_distribution
FROM fact_billing;



-- =============================================================================
-- FIRST_VALUE
-- =============================================================================

-- Query 155 : Highest Bill in Dataset

SELECT
    bill_id,
    net_amount,
    FIRST_VALUE(net_amount)
    OVER(
        ORDER BY net_amount DESC
    ) AS highest_bill
FROM fact_billing;



-- =============================================================================
-- LAST_VALUE
-- =============================================================================

-- Query 156 : Lowest Bill in Dataset

SELECT
    bill_id,
    net_amount,
    LAST_VALUE(net_amount)
    OVER(
        ORDER BY net_amount
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS lowest_bill
FROM fact_billing;



/*==============================================================================
 END OF PART 7
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 09_Analytical_Queries.sql
 Part    : 8 - Executive Dashboard Queries
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- EXECUTIVE KPI DASHBOARD
-- =============================================================================

-- Query 157 : Executive KPI Summary

SELECT
    (SELECT COUNT(*) FROM dim_patient) AS total_patients,
    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,
    (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,
    (SELECT COUNT(*) FROM fact_billing) AS total_bills,
    (SELECT ROUND(SUM(net_amount),2) FROM fact_billing) AS total_revenue;



-- Query 158 : Revenue by Year

SELECT
    YEAR(bill_date) AS bill_year,
    ROUND(SUM(net_amount),2) AS total_revenue
FROM fact_billing
GROUP BY YEAR(bill_date)
ORDER BY bill_year;



-- Query 159 : Revenue by Month

SELECT
    YEAR(bill_date) AS bill_year,
    MONTH(bill_date) AS bill_month,
    ROUND(SUM(net_amount),2) AS total_revenue
FROM fact_billing
GROUP BY YEAR(bill_date), MONTH(bill_date)
ORDER BY bill_year, bill_month;



-- Query 160 : Monthly Growth Rate

SELECT
    YEAR(bill_date) AS bill_year,
    MONTH(bill_date) AS bill_month,
    ROUND(SUM(net_amount),2) AS monthly_revenue
FROM fact_billing
GROUP BY YEAR(bill_date), MONTH(bill_date)
ORDER BY bill_year, bill_month;



-- =============================================================================
-- PATIENT DASHBOARD
-- =============================================================================

-- Query 161 : New Patients by Month

SELECT
    YEAR(registration_date) AS year,
    MONTH(registration_date) AS month,
    COUNT(*) AS new_patients
FROM dim_patient
GROUP BY YEAR(registration_date), MONTH(registration_date)
ORDER BY year, month;



-- Query 162 : Repeat Patients

SELECT
    patient_id,
    COUNT(*) AS total_visits
FROM fact_appointments
GROUP BY patient_id
HAVING COUNT(*) > 1
ORDER BY total_visits DESC;



-- Query 163 : Top 10 Cities by Patient Volume

SELECT
    city,
    COUNT(*) AS total_patients
FROM dim_patient
GROUP BY city
ORDER BY total_patients DESC
LIMIT 10;



-- =============================================================================
-- DOCTOR DASHBOARD
-- =============================================================================

-- Query 164 : Doctor Productivity

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    COUNT(a.appointment_id) AS total_consultations
FROM dim_doctor d
LEFT JOIN fact_appointments a
ON d.doctor_id=a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_consultations DESC;



-- Query 165 : Revenue Generated by Each Doctor

SELECT
    d.doctor_code,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    ROUND(SUM(b.net_amount),2) AS revenue
FROM fact_billing b
INNER JOIN dim_doctor d
ON b.doctor_id=d.doctor_id
GROUP BY d.doctor_id
ORDER BY revenue DESC;



-- =============================================================================
-- DEPARTMENT DASHBOARD
-- =============================================================================

-- Query 166 : Department Performance

SELECT
    dep.department_name,
    COUNT(a.appointment_id) AS appointments,
    ROUND(SUM(b.net_amount),2) AS revenue
FROM dim_department dep
LEFT JOIN fact_appointments a
ON dep.department_id=a.department_id
LEFT JOIN fact_billing b
ON dep.department_id=b.department_id
GROUP BY dep.department_id
ORDER BY revenue DESC;



-- =============================================================================
-- INSURANCE DASHBOARD
-- =============================================================================

-- Query 167 : Insurance Approval Summary

SELECT
    claim_status,
    COUNT(*) AS total_claims,
    ROUND(SUM(claim_amount),2) AS claim_amount
FROM fact_insurance_claims
GROUP BY claim_status;



-- =============================================================================
-- BED OCCUPANCY DASHBOARD
-- =============================================================================

-- Query 168 : Current Bed Occupancy

SELECT
    occupancy_status,
    COUNT(*) AS total_beds
FROM fact_bed_occupancy
GROUP BY occupancy_status;



-- Query 169 : Ward-wise Bed Occupancy

SELECT
    w.ward_name,
    COUNT(*) AS occupied_beds
FROM fact_bed_occupancy bo
INNER JOIN dim_bed b
ON bo.bed_id=b.bed_id
INNER JOIN dim_ward w
ON b.ward_id=w.ward_id
WHERE bo.occupancy_status='Occupied'
GROUP BY w.ward_name
ORDER BY occupied_beds DESC;



-- =============================================================================
-- WAITING TIME DASHBOARD
-- =============================================================================

-- Query 170 : Department-wise Average Waiting Time

SELECT
    d.department_name,
    ROUND(AVG(w.waiting_minutes),2) AS average_wait
FROM fact_waiting_time w
INNER JOIN dim_department d
ON w.department_id=d.department_id
GROUP BY d.department_name
ORDER BY average_wait DESC;



-- =============================================================================
-- PATIENT SATISFACTION DASHBOARD
-- =============================================================================

-- Query 171 : Overall Patient Satisfaction Score

SELECT
    ROUND(AVG(rating),2) AS satisfaction_score
FROM fact_patient_feedback;



-- Query 172 : Department-wise Satisfaction

SELECT
    d.department_name,
    ROUND(AVG(f.rating),2) AS average_rating
FROM fact_patient_feedback f
INNER JOIN dim_department d
ON f.department_id=d.department_id
GROUP BY d.department_name
ORDER BY average_rating DESC;



-- =============================================================================
-- FINANCIAL DASHBOARD
-- =============================================================================

-- Query 173 : Daily Revenue

SELECT
    bill_date,
    ROUND(SUM(net_amount),2) AS daily_revenue
FROM fact_billing
GROUP BY bill_date
ORDER BY bill_date;



-- Query 174 : Top 10 Highest Bills

SELECT
    bill_id,
    patient_id,
    net_amount
FROM fact_billing
ORDER BY net_amount DESC
LIMIT 10;



-- Query 175 : Outstanding Bills

SELECT
    COUNT(*) AS outstanding_bills,
    ROUND(SUM(net_amount),2) AS outstanding_amount
FROM fact_billing
WHERE payment_status='Pending';



-- =============================================================================
-- HOSPITAL SCORECARD
-- =============================================================================

-- Query 176 : Executive Scorecard

SELECT
    (SELECT COUNT(*) FROM dim_patient) AS total_patients,
    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,
    (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,
    (SELECT COUNT(*) FROM fact_billing) AS total_bills,
    (SELECT ROUND(SUM(net_amount),2) FROM fact_billing) AS revenue,
    (SELECT ROUND(AVG(waiting_minutes),2) FROM fact_waiting_time) AS avg_waiting_time,
    (SELECT ROUND(AVG(rating),2) FROM fact_patient_feedback) AS patient_satisfaction,
    (SELECT COUNT(*) FROM fact_insurance_claims WHERE claim_status='Approved') AS approved_claims;



/*==============================================================================
 END OF PART 8
==============================================================================*/
