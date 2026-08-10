/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 1 - Executive Dashboard Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 1 : Executive KPI Summary
-- =============================================================================

SELECT

    COUNT(DISTINCT patient_id) AS total_patients,

    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,

    (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,

    (SELECT COUNT(*) FROM fact_ipd_admissions) AS total_ipd_admissions,

    (SELECT COUNT(*) FROM fact_opd_visits) AS total_opd_visits,

    ROUND(SUM(net_amount),2) AS total_revenue,

    ROUND(AVG(net_amount),2) AS average_bill,

    ROUND(MAX(net_amount),2) AS highest_bill,

    ROUND(MIN(net_amount),2) AS lowest_bill

FROM fact_billing;



-- =============================================================================
-- REPORT 2 : Monthly Revenue Trend
-- =============================================================================

SELECT

    YEAR(bill_date) AS year,

    MONTH(bill_date) AS month,

    COUNT(*) AS total_bills,

    ROUND(SUM(net_amount),2) AS revenue

FROM fact_billing

GROUP BY

    YEAR(bill_date),

    MONTH(bill_date)

ORDER BY

    year,

    month;



-- =============================================================================
-- REPORT 3 : Yearly Revenue
-- =============================================================================

SELECT

    YEAR(bill_date) AS year,

    ROUND(SUM(net_amount),2) AS revenue

FROM fact_billing

GROUP BY YEAR(bill_date)

ORDER BY year;



-- =============================================================================
-- REPORT 4 : Revenue by Department
-- =============================================================================

SELECT

    d.department_name,

    COUNT(b.bill_id) AS total_bills,

    ROUND(SUM(b.net_amount),2) AS revenue,

    ROUND(AVG(b.net_amount),2) AS average_bill

FROM fact_billing b

INNER JOIN dim_department d

ON b.department_id=d.department_id

GROUP BY d.department_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 5 : Revenue by Doctor
-- =============================================================================

SELECT

    doc.doctor_code,

    CONCAT(doc.first_name,' ',doc.last_name) AS doctor_name,

    doc.specialization,

    COUNT(b.bill_id) AS total_bills,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_doctor doc

ON b.doctor_id=doc.doctor_id

GROUP BY doc.doctor_id

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 6 : Revenue by Payment Mode
-- =============================================================================

SELECT

    pm.payment_mode_name,

    COUNT(*) AS total_transactions,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_payment_mode pm

ON b.payment_mode_id=pm.payment_mode_id

GROUP BY pm.payment_mode_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 7 : Revenue by Insurance Company
-- =============================================================================

SELECT

    i.company_name,

    COUNT(*) AS total_claims,

    ROUND(SUM(ic.claim_amount),2) AS insurance_revenue

FROM fact_insurance_claims ic

INNER JOIN dim_insurance i

ON ic.insurance_id=i.insurance_id

GROUP BY i.company_name

ORDER BY insurance_revenue DESC;



-- =============================================================================
-- REPORT 8 : Daily Revenue
-- =============================================================================

SELECT

    bill_date,

    COUNT(*) AS total_bills,

    ROUND(SUM(net_amount),2) AS daily_revenue

FROM fact_billing

GROUP BY bill_date

ORDER BY bill_date;



-- =============================================================================
-- REPORT 9 : Top 10 Revenue Days
-- =============================================================================

SELECT

    bill_date,

    ROUND(SUM(net_amount),2) AS revenue

FROM fact_billing

GROUP BY bill_date

ORDER BY revenue DESC

LIMIT 10;



-- =============================================================================
-- REPORT 10 : Executive Hospital Scorecard
-- =============================================================================

SELECT

    (SELECT COUNT(*) FROM dim_patient) AS total_patients,

    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,

    (SELECT COUNT(*) FROM fact_appointments) AS appointments,

    (SELECT COUNT(*) FROM fact_emergency) AS emergency_cases,

    (SELECT COUNT(*) FROM fact_surgeries) AS surgeries,

    (SELECT COUNT(*) FROM fact_lab_orders) AS lab_tests,

    (SELECT COUNT(*) FROM fact_pharmacy) AS pharmacy_sales,

    (SELECT ROUND(AVG(waiting_minutes),2)
        FROM fact_waiting_time) AS average_waiting_time,

    (SELECT ROUND(AVG(rating),2)
        FROM fact_patient_feedback) AS patient_satisfaction,

    (SELECT ROUND(SUM(net_amount),2)
        FROM fact_billing) AS total_revenue;
        /*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 2 - Finance Dashboard Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 11 : Monthly Financial Summary
-- =============================================================================

SELECT

    YEAR(bill_date) AS bill_year,

    MONTH(bill_date) AS bill_month,

    COUNT(*) AS total_bills,

    ROUND(SUM(gross_amount),2) AS gross_revenue,

    ROUND(SUM(discount_amount),2) AS total_discount,

    ROUND(SUM(tax_amount),2) AS total_tax,

    ROUND(SUM(net_amount),2) AS net_revenue

FROM fact_billing

GROUP BY

    YEAR(bill_date),

    MONTH(bill_date)

ORDER BY

    bill_year,

    bill_month;



-- =============================================================================
-- REPORT 12 : Daily Financial Summary
-- =============================================================================

SELECT

    bill_date,

    COUNT(*) AS total_bills,

    ROUND(SUM(net_amount),2) AS revenue,

    ROUND(AVG(net_amount),2) AS average_bill

FROM fact_billing

GROUP BY bill_date

ORDER BY bill_date;



-- =============================================================================
-- REPORT 13 : Outstanding Bills
-- =============================================================================

SELECT

    bill_id,

    patient_id,

    bill_date,

    net_amount,

    payment_status

FROM fact_billing

WHERE payment_status='Pending'

ORDER BY bill_date DESC;



-- =============================================================================
-- REPORT 14 : Payment Mode Analysis
-- =============================================================================

SELECT

    pm.payment_mode_name,

    COUNT(*) AS total_transactions,

    ROUND(SUM(b.net_amount),2) AS revenue,

    ROUND(AVG(b.net_amount),2) AS average_transaction

FROM fact_billing b

INNER JOIN dim_payment_mode pm

ON b.payment_mode_id = pm.payment_mode_id

GROUP BY pm.payment_mode_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 15 : Insurance Revenue
-- =============================================================================

SELECT

    i.company_name,

    COUNT(ic.claim_id) AS total_claims,

    ROUND(SUM(ic.claim_amount),2) AS claim_amount

FROM fact_insurance_claims ic

INNER JOIN dim_insurance i

ON ic.insurance_id=i.insurance_id

GROUP BY i.company_name

ORDER BY claim_amount DESC;



-- =============================================================================
-- REPORT 16 : Insurance Approval Analysis
-- =============================================================================

SELECT

    claim_status,

    COUNT(*) AS total_claims,

    ROUND(SUM(claim_amount),2) AS total_amount

FROM fact_insurance_claims

GROUP BY claim_status

ORDER BY total_amount DESC;



-- =============================================================================
-- REPORT 17 : Revenue by Department
-- =============================================================================

SELECT

    d.department_name,

    COUNT(*) AS total_bills,

    ROUND(SUM(b.net_amount),2) AS revenue,

    ROUND(AVG(b.net_amount),2) AS average_bill

FROM fact_billing b

INNER JOIN dim_department d

ON b.department_id=d.department_id

GROUP BY d.department_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 18 : Revenue by Doctor
-- =============================================================================

SELECT

    doc.doctor_code,

    CONCAT(doc.first_name,' ',doc.last_name) AS doctor_name,

    doc.specialization,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_doctor doc

ON b.doctor_id=doc.doctor_id

GROUP BY doc.doctor_id

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 19 : Top 20 Highest Bills
-- =============================================================================

SELECT

    bill_id,

    patient_id,

    bill_date,

    net_amount

FROM fact_billing

ORDER BY net_amount DESC

LIMIT 20;



-- =============================================================================
-- REPORT 20 : Lowest 20 Bills
-- =============================================================================

SELECT

    bill_id,

    patient_id,

    bill_date,

    net_amount

FROM fact_billing

ORDER BY net_amount ASC

LIMIT 20;



-- =============================================================================
-- REPORT 21 : Average Revenue per Patient
-- =============================================================================

SELECT

    ROUND(

        SUM(net_amount)/

        COUNT(DISTINCT patient_id)

    ,2) AS revenue_per_patient

FROM fact_billing;



-- =============================================================================
-- REPORT 22 : Average Revenue per Doctor
-- =============================================================================

SELECT

    doc.doctor_code,

    CONCAT(doc.first_name,' ',doc.last_name) AS doctor_name,

    ROUND(AVG(b.net_amount),2) AS average_revenue

FROM fact_billing b

INNER JOIN dim_doctor doc

ON b.doctor_id=doc.doctor_id

GROUP BY doc.doctor_id

ORDER BY average_revenue DESC;



-- =============================================================================
-- REPORT 23 : Revenue by Month and Department
-- =============================================================================

SELECT

    YEAR(b.bill_date) AS bill_year,

    MONTH(b.bill_date) AS bill_month,

    d.department_name,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_department d

ON b.department_id=d.department_id

GROUP BY

    YEAR(b.bill_date),

    MONTH(b.bill_date),

    d.department_name

ORDER BY

    bill_year,

    bill_month,

    revenue DESC;



-- =============================================================================
-- REPORT 24 : Revenue Growth by Month
-- =============================================================================

SELECT

    YEAR(bill_date) AS bill_year,

    MONTH(bill_date) AS bill_month,

    ROUND(SUM(net_amount),2) AS monthly_revenue

FROM fact_billing

GROUP BY

    YEAR(bill_date),

    MONTH(bill_date)

ORDER BY

    bill_year,

    bill_month;



-- =============================================================================
-- REPORT 25 : Finance Dashboard KPI Dataset
-- =============================================================================

SELECT

    COUNT(*) AS total_bills,

    ROUND(SUM(gross_amount),2) AS gross_revenue,

    ROUND(SUM(discount_amount),2) AS total_discount,

    ROUND(SUM(tax_amount),2) AS total_tax,

    ROUND(SUM(net_amount),2) AS net_revenue,

    ROUND(AVG(net_amount),2) AS average_bill,

    ROUND(MAX(net_amount),2) AS highest_bill,

    ROUND(MIN(net_amount),2) AS lowest_bill

FROM fact_billing;



/*==============================================================================
 END OF PART 2
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 3 - Patient Dashboard Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 26 : Patient Demographics Summary
-- =============================================================================

SELECT

    COUNT(*) AS total_patients,

    COUNT(DISTINCT city) AS total_cities,

    COUNT(DISTINCT state) AS total_states,

    ROUND(AVG(age),2) AS average_age

FROM dim_patient;



-- =============================================================================
-- REPORT 27 : Gender Distribution
-- =============================================================================

SELECT

    gender,

    COUNT(*) AS total_patients,

    ROUND(
        COUNT(*)*100.0/
        (SELECT COUNT(*) FROM dim_patient),
    2) AS percentage

FROM dim_patient

GROUP BY gender

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 28 : Age Group Distribution
-- =============================================================================

SELECT

CASE

WHEN age <18 THEN 'Below 18'

WHEN age BETWEEN 18 AND 30 THEN '18-30'

WHEN age BETWEEN 31 AND 45 THEN '31-45'

WHEN age BETWEEN 46 AND 60 THEN '46-60'

ELSE 'Above 60'

END AS age_group,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY age_group

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 29 : Blood Group Distribution
-- =============================================================================

SELECT

blood_group,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY blood_group

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 30 : Marital Status Distribution
-- =============================================================================

SELECT

marital_status,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY marital_status

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 31 : Occupation Distribution
-- =============================================================================

SELECT

occupation,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY occupation

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 32 : Patient Distribution by City
-- =============================================================================

SELECT

city,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY city

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 33 : Patient Distribution by State
-- =============================================================================

SELECT

state,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY state

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 34 : Top 20 Cities
-- =============================================================================

SELECT

city,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY city

ORDER BY total_patients DESC

LIMIT 20;



-- =============================================================================
-- REPORT 35 : Registration Trend
-- =============================================================================

SELECT

YEAR(registration_date) AS registration_year,

MONTH(registration_date) AS registration_month,

COUNT(*) AS new_patients

FROM dim_patient

GROUP BY

YEAR(registration_date),

MONTH(registration_date)

ORDER BY

registration_year,

registration_month;



-- =============================================================================
-- REPORT 36 : Monthly Patient Registration
-- =============================================================================

SELECT

DATE_FORMAT(registration_date,'%Y-%m') AS registration_month,

COUNT(*) AS total_patients

FROM dim_patient

GROUP BY registration_month

ORDER BY registration_month;



-- =============================================================================
-- REPORT 37 : Repeat Patients
-- =============================================================================

SELECT

patient_id,

COUNT(*) AS total_visits

FROM fact_appointments

GROUP BY patient_id

HAVING COUNT(*)>1

ORDER BY total_visits DESC;



-- =============================================================================
-- REPORT 38 : Top Frequent Patients
-- =============================================================================

SELECT

p.patient_code,

CONCAT(p.first_name,' ',p.last_name) AS patient_name,

COUNT(a.appointment_id) AS total_visits

FROM dim_patient p

INNER JOIN fact_appointments a

ON p.patient_id=a.patient_id

GROUP BY p.patient_id

ORDER BY total_visits DESC

LIMIT 20;



-- =============================================================================
-- REPORT 39 : Patient Satisfaction
-- =============================================================================

SELECT

ROUND(AVG(rating),2) AS average_rating,

MAX(rating) AS highest_rating,

MIN(rating) AS lowest_rating,

COUNT(*) AS total_feedback

FROM fact_patient_feedback;



-- =============================================================================
-- REPORT 40 : Satisfaction by Department
-- =============================================================================

SELECT

d.department_name,

ROUND(AVG(f.rating),2) AS average_rating,

COUNT(*) AS feedback_count

FROM fact_patient_feedback f

INNER JOIN dim_department d

ON f.department_id=d.department_id

GROUP BY d.department_name

ORDER BY average_rating DESC;



-- =============================================================================
-- REPORT 41 : Satisfaction by Doctor
-- =============================================================================

SELECT

doc.doctor_code,

CONCAT(doc.first_name,' ',doc.last_name) AS doctor_name,

ROUND(AVG(f.rating),2) AS average_rating,

COUNT(*) AS feedback_count

FROM fact_patient_feedback f

INNER JOIN dim_doctor doc

ON f.doctor_id=doc.doctor_id

GROUP BY doc.doctor_id

ORDER BY average_rating DESC;



-- =============================================================================
-- REPORT 42 : Patient Dashboard KPI Dataset
-- =============================================================================

SELECT

(SELECT COUNT(*) FROM dim_patient) AS total_patients,

(SELECT COUNT(DISTINCT city) FROM dim_patient) AS cities,

(SELECT COUNT(DISTINCT state) FROM dim_patient) AS states,

(SELECT ROUND(AVG(age),2) FROM dim_patient) AS average_age,

(SELECT ROUND(AVG(rating),2)
 FROM fact_patient_feedback) AS patient_satisfaction,

(SELECT COUNT(*)
 FROM fact_appointments) AS total_appointments,

(SELECT COUNT(DISTINCT patient_id)
 FROM fact_appointments) AS unique_patients;



/*==============================================================================
 END OF PART 3
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 4 - Doctor & Department Dashboard Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 43 : Doctor Performance Summary
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    d.specialization,

    dep.department_name,

    COUNT(DISTINCT a.appointment_id) AS total_appointments,

    COUNT(DISTINCT a.patient_id) AS total_patients,

    ROUND(IFNULL(SUM(b.net_amount),0),2) AS total_revenue,

    ROUND(IFNULL(AVG(f.rating),0),2) AS average_rating

FROM dim_doctor d

LEFT JOIN dim_department dep
       ON d.department_id = dep.department_id

LEFT JOIN fact_appointments a
       ON d.doctor_id = a.doctor_id

LEFT JOIN fact_billing b
       ON d.doctor_id = b.doctor_id

LEFT JOIN fact_patient_feedback f
       ON d.doctor_id = f.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name,
    d.specialization,
    dep.department_name

ORDER BY total_revenue DESC;



-- =============================================================================
-- REPORT 44 : Doctor Revenue Ranking
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    d.specialization,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_doctor d
ON b.doctor_id=d.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name,
    d.specialization

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 45 : Doctor Appointment Summary
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    COUNT(a.appointment_id) AS total_appointments,

    SUM(CASE WHEN a.status='Completed' THEN 1 ELSE 0 END) AS completed,

    SUM(CASE WHEN a.status='Cancelled' THEN 1 ELSE 0 END) AS cancelled,

    SUM(CASE WHEN a.status='No Show' THEN 1 ELSE 0 END) AS no_show

FROM dim_doctor d

LEFT JOIN fact_appointments a
ON d.doctor_id=a.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name

ORDER BY total_appointments DESC;



-- =============================================================================
-- REPORT 46 : Doctor Waiting Time
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    ROUND(AVG(w.waiting_minutes),2) AS average_waiting_time,

    MAX(w.waiting_minutes) AS maximum_waiting_time,

    MIN(w.waiting_minutes) AS minimum_waiting_time

FROM dim_doctor d

INNER JOIN fact_waiting_time w

ON d.doctor_id=w.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name

ORDER BY average_waiting_time DESC;



-- =============================================================================
-- REPORT 47 : Doctor Feedback Summary
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    COUNT(f.feedback_id) AS total_feedback,

    ROUND(AVG(f.rating),2) AS average_rating

FROM dim_doctor d

LEFT JOIN fact_patient_feedback f

ON d.doctor_id=f.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name

ORDER BY average_rating DESC;



-- =============================================================================
-- REPORT 48 : Department Performance
-- =============================================================================

SELECT

    dep.department_name,

    COUNT(DISTINCT a.appointment_id) AS total_appointments,

    COUNT(DISTINCT a.patient_id) AS total_patients,

    ROUND(IFNULL(SUM(b.net_amount),0),2) AS revenue,

    ROUND(IFNULL(AVG(f.rating),0),2) AS patient_satisfaction

FROM dim_department dep

LEFT JOIN fact_appointments a
ON dep.department_id=a.department_id

LEFT JOIN fact_billing b
ON dep.department_id=b.department_id

LEFT JOIN fact_patient_feedback f
ON dep.department_id=f.department_id

GROUP BY
    dep.department_id,
    dep.department_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 49 : Department Revenue
-- =============================================================================

SELECT

    dep.department_name,

    ROUND(SUM(b.net_amount),2) AS revenue,

    COUNT(b.bill_id) AS total_bills,

    ROUND(AVG(b.net_amount),2) AS average_bill

FROM fact_billing b

INNER JOIN dim_department dep

ON b.department_id=dep.department_id

GROUP BY
    dep.department_id,
    dep.department_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 50 : Department Appointment Trend
-- =============================================================================

SELECT

    YEAR(a.appointment_date) AS appointment_year,

    MONTH(a.appointment_date) AS appointment_month,

    dep.department_name,

    COUNT(*) AS total_appointments

FROM fact_appointments a

INNER JOIN dim_department dep

ON a.department_id=dep.department_id

GROUP BY

    YEAR(a.appointment_date),

    MONTH(a.appointment_date),

    dep.department_name

ORDER BY

    appointment_year,

    appointment_month,

    dep.department_name;



-- =============================================================================
-- REPORT 51 : Top 10 Doctors
-- =============================================================================

SELECT

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_doctor d

ON b.doctor_id=d.doctor_id

GROUP BY
    d.doctor_id,
    d.doctor_code,
    doctor_name

ORDER BY revenue DESC

LIMIT 10;



-- =============================================================================
-- REPORT 52 : Top 10 Departments
-- =============================================================================

SELECT

    dep.department_name,

    ROUND(SUM(b.net_amount),2) AS revenue

FROM fact_billing b

INNER JOIN dim_department dep

ON b.department_id=dep.department_id

GROUP BY
    dep.department_id,
    dep.department_name

ORDER BY revenue DESC

LIMIT 10;



-- =============================================================================
-- REPORT 53 : Doctor KPI Dataset
-- =============================================================================

SELECT

    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,

    (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,

    (SELECT ROUND(AVG(waiting_minutes),2)
     FROM fact_waiting_time) AS average_waiting_time,

    (SELECT ROUND(AVG(rating),2)
     FROM fact_patient_feedback) AS average_rating,

    (SELECT ROUND(SUM(net_amount),2)
     FROM fact_billing) AS total_revenue;



-- =============================================================================
-- REPORT 54 : Department KPI Dataset
-- =============================================================================

SELECT

    COUNT(*) AS total_departments,

    (SELECT COUNT(*) FROM fact_appointments) AS appointments,

    (SELECT ROUND(SUM(net_amount),2)
     FROM fact_billing) AS revenue,

    (SELECT ROUND(AVG(rating),2)
     FROM fact_patient_feedback) AS satisfaction_score

FROM dim_department;



/*==============================================================================
 END OF PART 4
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 5 - Operations Dashboard Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 55 : OPD Summary
-- =============================================================================

SELECT

    visit_date,

    COUNT(*) AS total_opd_visits

FROM fact_opd_visits

GROUP BY visit_date

ORDER BY visit_date;



-- =============================================================================
-- REPORT 56 : IPD Admissions Summary
-- =============================================================================

SELECT

    admission_date,

    COUNT(*) AS total_admissions

FROM fact_ipd_admissions

GROUP BY admission_date

ORDER BY admission_date;



-- =============================================================================
-- REPORT 57 : OPD vs IPD Comparison
-- =============================================================================

SELECT
    'OPD' AS visit_type,
    COUNT(*) AS total_records
FROM fact_opd_visits

UNION ALL

SELECT
    'IPD',
    COUNT(*)
FROM fact_ipd_admissions;



-- =============================================================================
-- REPORT 58 : Daily Appointment Trend
-- =============================================================================

SELECT

    appointment_date,

    COUNT(*) AS total_appointments

FROM fact_appointments

GROUP BY appointment_date

ORDER BY appointment_date;



-- =============================================================================
-- REPORT 59 : Appointment Status Summary
-- =============================================================================

SELECT

    status,

    COUNT(*) AS total_appointments

FROM fact_appointments

GROUP BY status

ORDER BY total_appointments DESC;



-- =============================================================================
-- REPORT 60 : Waiting Time by Department
-- =============================================================================

SELECT

    d.department_name,

    ROUND(AVG(w.waiting_minutes),2) AS average_waiting_time,

    MAX(w.waiting_minutes) AS maximum_waiting_time,

    MIN(w.waiting_minutes) AS minimum_waiting_time

FROM fact_waiting_time w

INNER JOIN dim_department d
ON w.department_id = d.department_id

GROUP BY d.department_name

ORDER BY average_waiting_time DESC;



-- =============================================================================
-- REPORT 61 : Waiting Time by Doctor
-- =============================================================================

SELECT

    doc.doctor_code,

    CONCAT(doc.first_name,' ',doc.last_name) AS doctor_name,

    ROUND(AVG(w.waiting_minutes),2) AS average_waiting_time

FROM fact_waiting_time w

INNER JOIN dim_doctor doc
ON w.doctor_id = doc.doctor_id

GROUP BY
    doc.doctor_id,
    doc.doctor_code,
    doctor_name

ORDER BY average_waiting_time DESC;



-- =============================================================================
-- REPORT 62 : Bed Occupancy Summary
-- =============================================================================

SELECT

    occupancy_status,

    COUNT(*) AS total_beds

FROM fact_bed_occupancy

GROUP BY occupancy_status

ORDER BY total_beds DESC;



-- =============================================================================
-- REPORT 63 : Ward-wise Bed Occupancy
-- =============================================================================

SELECT

    w.ward_name,

    COUNT(*) AS occupied_beds

FROM fact_bed_occupancy bo

INNER JOIN dim_bed b
ON bo.bed_id = b.bed_id

INNER JOIN dim_ward w
ON b.ward_id = w.ward_id

WHERE bo.occupancy_status = 'Occupied'

GROUP BY w.ward_name

ORDER BY occupied_beds DESC;



-- =============================================================================
-- REPORT 64 : Bed Availability
-- =============================================================================

SELECT

    w.ward_name,

    COUNT(*) AS available_beds

FROM dim_bed b

INNER JOIN dim_ward w
ON b.ward_id = w.ward_id

WHERE b.bed_status='Available'

GROUP BY w.ward_name

ORDER BY available_beds DESC;



-- =============================================================================
-- REPORT 65 : Emergency Visits
-- =============================================================================

SELECT

    visit_date,

    COUNT(*) AS emergency_cases

FROM fact_emergency

GROUP BY visit_date

ORDER BY visit_date;



-- =============================================================================
-- REPORT 66 : Emergency Cases by Department
-- =============================================================================

SELECT

    d.department_name,

    COUNT(*) AS emergency_cases

FROM fact_emergency e

INNER JOIN dim_department d
ON e.department_id = d.department_id

GROUP BY d.department_name

ORDER BY emergency_cases DESC;



-- =============================================================================
-- REPORT 67 : Surgery Summary
-- =============================================================================

SELECT

    surgery_type,

    COUNT(*) AS total_surgeries

FROM fact_surgeries

GROUP BY surgery_type

ORDER BY total_surgeries DESC;



-- =============================================================================
-- REPORT 68 : Surgery by Department
-- =============================================================================

SELECT

    d.department_name,

    COUNT(*) AS total_surgeries

FROM fact_surgeries s

INNER JOIN dim_department d
ON s.department_id = d.department_id

GROUP BY d.department_name

ORDER BY total_surgeries DESC;



-- =============================================================================
-- REPORT 69 : Discharge Summary
-- =============================================================================

SELECT

    discharge_status,

    COUNT(*) AS total_patients

FROM fact_discharge

GROUP BY discharge_status

ORDER BY total_patients DESC;



-- =============================================================================
-- REPORT 70 : Average Length of Stay (ALOS)
-- =============================================================================

SELECT

    ROUND(AVG(length_of_stay),2) AS average_length_of_stay

FROM fact_discharge;



-- =============================================================================
-- REPORT 71 : Daily Hospital Operations
-- =============================================================================

SELECT

    d.full_date,

    IFNULL(opd.total_opd,0) AS opd_visits,

    IFNULL(ipd.total_ipd,0) AS ipd_admissions,

    IFNULL(app.total_appointments,0) AS appointments

FROM dim_date d

LEFT JOIN
(
    SELECT
        visit_date,
        COUNT(*) AS total_opd
    FROM fact_opd_visits
    GROUP BY visit_date
) opd
ON d.full_date = opd.visit_date

LEFT JOIN
(
    SELECT
        admission_date,
        COUNT(*) AS total_ipd
    FROM fact_ipd_admissions
    GROUP BY admission_date
) ipd
ON d.full_date = ipd.admission_date

LEFT JOIN
(
    SELECT
        appointment_date,
        COUNT(*) AS total_appointments
    FROM fact_appointments
    GROUP BY appointment_date
) app
ON d.full_date = app.appointment_date

ORDER BY d.full_date;



-- =============================================================================
-- REPORT 72 : Operations KPI Dataset
-- =============================================================================

SELECT

    (SELECT COUNT(*) FROM fact_opd_visits) AS total_opd_visits,

    (SELECT COUNT(*) FROM fact_ipd_admissions) AS total_ipd_admissions,

    (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,

    (SELECT COUNT(*) FROM fact_emergency) AS emergency_cases,

    (SELECT ROUND(AVG(waiting_minutes),2)
     FROM fact_waiting_time) AS average_waiting_time,

    (SELECT COUNT(*) FROM fact_surgeries) AS surgeries,

    (SELECT ROUND(AVG(length_of_stay),2)
     FROM fact_discharge) AS average_length_of_stay,

    (SELECT COUNT(*) FROM fact_bed_occupancy
     WHERE occupancy_status='Occupied') AS occupied_beds;



/*==============================================================================
 END OF PART 5
==============================================================================*/
/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 10_Reporting_Queries.sql
 Part    : 6 - Pharmacy, Laboratory, Insurance & Executive Reporting
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

-- =============================================================================
-- REPORT 73 : Pharmacy Revenue
-- =============================================================================

SELECT

    m.medicine_name,

    COUNT(*) AS total_sales,

    SUM(p.quantity) AS total_quantity,

    ROUND(SUM(p.total_amount),2) AS revenue

FROM fact_pharmacy p

INNER JOIN dim_medicine m

ON p.medicine_id = m.medicine_id

GROUP BY m.medicine_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 74 : Top Selling Medicines
-- =============================================================================

SELECT

    m.medicine_name,

    SUM(p.quantity) AS quantity_sold

FROM fact_pharmacy p

INNER JOIN dim_medicine m

ON p.medicine_id = m.medicine_id

GROUP BY m.medicine_name

ORDER BY quantity_sold DESC

LIMIT 20;



-- =============================================================================
-- REPORT 75 : Pharmacy Daily Sales
-- =============================================================================

SELECT

    sale_date,

    COUNT(*) AS total_transactions,

    ROUND(SUM(total_amount),2) AS revenue

FROM fact_pharmacy

GROUP BY sale_date

ORDER BY sale_date;



-- =============================================================================
-- REPORT 76 : Laboratory Test Summary
-- =============================================================================

SELECT

    lt.test_name,

    COUNT(*) AS total_orders,

    ROUND(SUM(lo.test_amount),2) AS revenue

FROM fact_lab_orders lo

INNER JOIN dim_lab_test lt

ON lo.lab_test_id = lt.lab_test_id

GROUP BY lt.test_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 77 : Most Requested Lab Tests
-- =============================================================================

SELECT

    lt.test_name,

    COUNT(*) AS total_tests

FROM fact_lab_orders lo

INNER JOIN dim_lab_test lt

ON lo.lab_test_id = lt.lab_test_id

GROUP BY lt.test_name

ORDER BY total_tests DESC

LIMIT 20;



-- =============================================================================
-- REPORT 78 : Laboratory Daily Summary
-- =============================================================================

SELECT

    order_date,

    COUNT(*) AS tests_performed,

    ROUND(SUM(test_amount),2) AS revenue

FROM fact_lab_orders

GROUP BY order_date

ORDER BY order_date;



-- =============================================================================
-- REPORT 79 : Insurance Company Performance
-- =============================================================================

SELECT

    i.company_name,

    COUNT(ic.claim_id) AS total_claims,

    ROUND(SUM(ic.claim_amount),2) AS claim_amount

FROM fact_insurance_claims ic

INNER JOIN dim_insurance i

ON ic.insurance_id = i.insurance_id

GROUP BY i.company_name

ORDER BY claim_amount DESC;



-- =============================================================================
-- REPORT 80 : Insurance Approval Rate
-- =============================================================================

SELECT

    claim_status,

    COUNT(*) AS total_claims,

    ROUND(SUM(claim_amount),2) AS total_amount

FROM fact_insurance_claims

GROUP BY claim_status

ORDER BY total_claims DESC;



-- =============================================================================
-- REPORT 81 : Radiology Summary
-- =============================================================================

SELECT

    test_name,

    COUNT(*) AS total_scans,

    ROUND(SUM(test_amount),2) AS revenue

FROM fact_radiology

GROUP BY test_name

ORDER BY revenue DESC;



-- =============================================================================
-- REPORT 82 : Complaint Analysis
-- =============================================================================

SELECT

    complaint_type,

    COUNT(*) AS total_complaints

FROM fact_complaints

GROUP BY complaint_type

ORDER BY total_complaints DESC;



-- =============================================================================
-- REPORT 83 : Complaint Status Summary
-- =============================================================================

SELECT

    complaint_status,

    COUNT(*) AS total_cases

FROM fact_complaints

GROUP BY complaint_status

ORDER BY total_cases DESC;



-- =============================================================================
-- REPORT 84 : Patient Feedback Distribution
-- =============================================================================

SELECT

    rating,

    COUNT(*) AS total_feedback

FROM fact_patient_feedback

GROUP BY rating

ORDER BY rating DESC;



-- =============================================================================
-- REPORT 85 : Feedback by Department
-- =============================================================================

SELECT

    d.department_name,

    ROUND(AVG(f.rating),2) AS average_rating,

    COUNT(*) AS total_feedback

FROM fact_patient_feedback f

INNER JOIN dim_department d

ON f.department_id = d.department_id

GROUP BY d.department_name

ORDER BY average_rating DESC;



-- =============================================================================
-- REPORT 86 : Feedback Trend
-- =============================================================================

SELECT

    feedback_date,

    COUNT(*) AS feedback_received,

    ROUND(AVG(rating),2) AS average_rating

FROM fact_patient_feedback

GROUP BY feedback_date

ORDER BY feedback_date;



-- =============================================================================
-- REPORT 87 : Executive KPI Dataset
-- =============================================================================

SELECT

    (SELECT COUNT(*) FROM dim_patient) AS total_patients,

    (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,

    (SELECT COUNT(*) FROM fact_appointments) AS appointments,

    (SELECT COUNT(*) FROM fact_ipd_admissions) AS ipd,

    (SELECT COUNT(*) FROM fact_opd_visits) AS opd,

    (SELECT ROUND(SUM(net_amount),2)
     FROM fact_billing) AS total_revenue,

    (SELECT ROUND(AVG(net_amount),2)
     FROM fact_billing) AS average_bill,

    (SELECT ROUND(AVG(waiting_minutes),2)
     FROM fact_waiting_time) AS average_waiting_time,

    (SELECT ROUND(AVG(rating),2)
     FROM fact_patient_feedback) AS patient_satisfaction,

    (SELECT COUNT(*) FROM fact_emergency) AS emergency_cases,

    (SELECT COUNT(*) FROM fact_surgeries) AS surgeries;



-- =============================================================================
-- REPORT 88 : Hospital Master Dashboard Dataset
-- =============================================================================

SELECT

    d.full_date,

    COUNT(DISTINCT a.appointment_id) AS appointments,

    COUNT(DISTINCT o.visit_id) AS opd_visits,

    COUNT(DISTINCT i.admission_id) AS ipd_admissions,

    COUNT(DISTINCT b.bill_id) AS bills,

    ROUND(IFNULL(SUM(b.net_amount),0),2) AS revenue

FROM dim_date d

LEFT JOIN fact_appointments a
ON d.full_date = a.appointment_date

LEFT JOIN fact_opd_visits o
ON d.full_date = o.visit_date

LEFT JOIN fact_ipd_admissions i
ON d.full_date = i.admission_date

LEFT JOIN fact_billing b
ON d.full_date = b.bill_date

GROUP BY d.full_date

ORDER BY d.full_date;



-- =============================================================================
-- REPORT 89 : Hospital Operational Scorecard
-- =============================================================================

SELECT

    (SELECT COUNT(*) FROM fact_billing) AS total_bills,

    (SELECT COUNT(*) FROM fact_lab_orders) AS lab_tests,

    (SELECT COUNT(*) FROM fact_pharmacy) AS pharmacy_sales,

    (SELECT COUNT(*) FROM fact_insurance_claims) AS insurance_claims,

    (SELECT COUNT(*) FROM fact_radiology) AS radiology_tests,

    (SELECT COUNT(*) FROM fact_complaints) AS complaints,

    (SELECT COUNT(*) FROM fact_patient_feedback) AS feedback_records;



-- =============================================================================
-- REPORT 90 : Complete Hospital BI Dataset
-- =============================================================================

SELECT

    p.patient_code,

    CONCAT(p.first_name,' ',p.last_name) AS patient_name,

    d.doctor_code,

    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

    dep.department_name,

    b.bill_date,

    b.net_amount,

    pm.payment_mode_name,

    ins.company_name

FROM fact_billing b

INNER JOIN dim_patient p
ON b.patient_id = p.patient_id

INNER JOIN dim_doctor d
ON b.doctor_id = d.doctor_id

INNER JOIN dim_department dep
ON b.department_id = dep.department_id

INNER JOIN dim_payment_mode pm
ON b.payment_mode_id = pm.payment_mode_id

LEFT JOIN dim_insurance ins
ON b.insurance_id = ins.insurance_id

ORDER BY b.bill_date DESC;



/*==============================================================================
 END OF FILE
 10_Reporting_Queries.sql
==============================================================================*/