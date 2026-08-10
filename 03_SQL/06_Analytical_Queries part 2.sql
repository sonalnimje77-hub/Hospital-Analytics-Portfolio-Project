
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
