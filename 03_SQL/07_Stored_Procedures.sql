/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 08_Stored_Procedures.sql
 Part    : 1
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

DELIMITER $$

/*==============================================================================
Procedure 1 : Get All Active Patients
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_get_active_patients$$

CREATE PROCEDURE sp_get_active_patients()
BEGIN

    SELECT
        patient_id,
        patient_code,
        first_name,
        last_name,
        gender,
        mobile_number
    FROM dim_patient
    WHERE is_active = TRUE
    ORDER BY first_name;

END$$


/*==============================================================================
Procedure 2 : Get Patient By ID
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_get_patient_by_id$$

CREATE PROCEDURE sp_get_patient_by_id
(
    IN p_patient_id INT
)
BEGIN

    SELECT *
    FROM dim_patient
    WHERE patient_id = p_patient_id;

END$$


/*==============================================================================
Procedure 3 : Doctor Directory
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_doctor_directory$$

CREATE PROCEDURE sp_doctor_directory()
BEGIN

    SELECT
        doctor_code,
        CONCAT(first_name,' ',last_name) AS doctor_name,
        specialization,
        consultation_fee
    FROM dim_doctor
    ORDER BY doctor_name;

END$$


/*==============================================================================
Procedure 4 : Department List
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_department_list$$

CREATE PROCEDURE sp_department_list()
BEGIN

    SELECT
        department_id,
        department_name,
        department_type
    FROM dim_department
    ORDER BY department_name;

END$$


/*==============================================================================
Procedure 5 : Revenue Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_total_revenue$$

CREATE PROCEDURE sp_total_revenue()
BEGIN

    SELECT
        COUNT(*) AS total_bills,
        ROUND(SUM(net_amount),2) AS total_revenue,
        ROUND(AVG(net_amount),2) AS average_bill
    FROM fact_billing;

END$$


/*==============================================================================
Procedure 6 : Revenue By Department
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_department_revenue$$

CREATE PROCEDURE sp_department_revenue()
BEGIN

    SELECT
        d.department_name,
        ROUND(SUM(b.net_amount),2) AS revenue
    FROM fact_billing b
    INNER JOIN dim_department d
        ON b.department_id=d.department_id
    GROUP BY d.department_name
    ORDER BY revenue DESC;

END$$


/*==============================================================================
Procedure 7 : Revenue By Doctor
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_doctor_revenue$$

CREATE PROCEDURE sp_doctor_revenue()
BEGIN

    SELECT
        CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
        ROUND(SUM(b.net_amount),2) AS revenue
    FROM fact_billing b
    INNER JOIN dim_doctor d
        ON b.doctor_id=d.doctor_id
    GROUP BY d.doctor_id
    ORDER BY revenue DESC;

END$$


/*==============================================================================
Procedure 8 : Bed Availability
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_available_beds$$

CREATE PROCEDURE sp_available_beds()
BEGIN

    SELECT
        bed_code,
        ward_id,
        room_number
    FROM dim_bed
    WHERE bed_status='Available'
    ORDER BY ward_id, room_number;

END$$

DELIMITER ;

/*==============================================================================
Testing Stored Procedures
==============================================================================*/

CALL sp_get_active_patients();

CALL sp_get_patient_by_id(1);

CALL sp_doctor_directory();

CALL sp_department_list();

CALL sp_total_revenue();

CALL sp_department_revenue();

CALL sp_doctor_revenue();

CALL sp_available_beds();

/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 08_Stored_Procedures.sql
 Part    : 2
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

DELIMITER $$

/*==============================================================================
Procedure 9 : Appointment Report By Status
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_appointment_by_status$$

CREATE PROCEDURE sp_appointment_by_status
(
    IN p_status VARCHAR(20)
)
BEGIN

    SELECT
        appointment_id,
        patient_id,
        doctor_id,
        department_id,
        appointment_date,
        appointment_time,
        status
    FROM fact_appointments
    WHERE status = p_status
    ORDER BY appointment_date DESC;

END$$


/*==============================================================================
Procedure 10 : Appointments Between Two Dates
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_appointments_between_dates$$

CREATE PROCEDURE sp_appointments_between_dates
(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN

    SELECT
        appointment_id,
        patient_id,
        doctor_id,
        appointment_date,
        status
    FROM fact_appointments
    WHERE appointment_date
          BETWEEN p_start_date
          AND p_end_date
    ORDER BY appointment_date;

END$$


/*==============================================================================
Procedure 11 : Billing Between Two Dates
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_billing_between_dates$$

CREATE PROCEDURE sp_billing_between_dates
(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN

    SELECT
        bill_id,
        patient_id,
        bill_date,
        gross_amount,
        discount_amount,
        tax_amount,
        net_amount
    FROM fact_billing
    WHERE bill_date
          BETWEEN p_start_date
          AND p_end_date
    ORDER BY bill_date;

END$$


/*==============================================================================
Procedure 12 : Revenue Between Two Dates
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_revenue_between_dates$$

CREATE PROCEDURE sp_revenue_between_dates
(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN

    SELECT

        COUNT(*) AS total_bills,

        ROUND(SUM(net_amount),2) AS total_revenue,

        ROUND(AVG(net_amount),2) AS average_bill,

        ROUND(MAX(net_amount),2) AS highest_bill,

        ROUND(MIN(net_amount),2) AS lowest_bill

    FROM fact_billing

    WHERE bill_date
          BETWEEN p_start_date
          AND p_end_date;

END$$


/*==============================================================================
Procedure 13 : Department Revenue
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_department_revenue_by_id$$

CREATE PROCEDURE sp_department_revenue_by_id
(
    IN p_department_id INT
)
BEGIN

    SELECT

        department_id,

        ROUND(SUM(net_amount),2) AS revenue

    FROM fact_billing

    WHERE department_id = p_department_id

    GROUP BY department_id;

END$$


/*==============================================================================
Procedure 14 : Doctor Revenue
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_doctor_revenue_by_id$$

CREATE PROCEDURE sp_doctor_revenue_by_id
(
    IN p_doctor_id INT
)
BEGIN

    SELECT

        doctor_id,

        COUNT(*) AS total_bills,

        ROUND(SUM(net_amount),2) AS revenue

    FROM fact_billing

    WHERE doctor_id = p_doctor_id

    GROUP BY doctor_id;

END$$


/*==============================================================================
Procedure 15 : Waiting Time By Department
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_waiting_time_department$$

CREATE PROCEDURE sp_waiting_time_department
(
    IN p_department_id INT
)
BEGIN

    SELECT

        department_id,

        ROUND(AVG(waiting_minutes),2) AS average_waiting_time,

        MAX(waiting_minutes) AS maximum_waiting_time,

        MIN(waiting_minutes) AS minimum_waiting_time

    FROM fact_waiting_time

    WHERE department_id = p_department_id

    GROUP BY department_id;

END$$


/*==============================================================================
Procedure 16 : Insurance Claims By Status
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_insurance_claim_status$$

CREATE PROCEDURE sp_insurance_claim_status
(
    IN p_claim_status VARCHAR(30)
)
BEGIN

    SELECT

        claim_id,

        patient_id,

        insurance_id,

        claim_amount,

        claim_status

    FROM fact_insurance_claims

    WHERE claim_status = p_claim_status

    ORDER BY claim_amount DESC;

END$$

DELIMITER ;



/*==============================================================================
Testing Procedures
==============================================================================*/

CALL sp_appointment_by_status('Completed');

CALL sp_appointments_between_dates
(
'2025-01-01',
'2025-12-31'
);

CALL sp_billing_between_dates
(
'2025-01-01',
'2025-12-31'
);

CALL sp_revenue_between_dates
(
'2025-01-01',
'2025-12-31'
);

CALL sp_department_revenue_by_id(1);

CALL sp_doctor_revenue_by_id(5);

CALL sp_waiting_time_department(2);

CALL sp_insurance_claim_status('Approved');

/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 08_Stored_Procedures.sql
 Part    : 3
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

DELIMITER $$

/*==============================================================================
Procedure 17 : Monthly Revenue Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_monthly_revenue_report$$

CREATE PROCEDURE sp_monthly_revenue_report()
BEGIN

    SELECT
        YEAR(bill_date) AS bill_year,
        MONTH(bill_date) AS bill_month,
        COUNT(*) AS total_bills,
        ROUND(SUM(net_amount),2) AS total_revenue,
        ROUND(AVG(net_amount),2) AS average_bill
    FROM fact_billing
    GROUP BY YEAR(bill_date), MONTH(bill_date)
    ORDER BY bill_year,bill_month;

END$$


/*==============================================================================
Procedure 18 : Daily Revenue Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_daily_revenue_report$$

CREATE PROCEDURE sp_daily_revenue_report()
BEGIN

    SELECT
        bill_date,
        COUNT(*) AS total_bills,
        ROUND(SUM(net_amount),2) AS total_revenue
    FROM fact_billing
    GROUP BY bill_date
    ORDER BY bill_date;

END$$


/*==============================================================================
Procedure 19 : Doctor Performance Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_doctor_performance$$

CREATE PROCEDURE sp_doctor_performance()
BEGIN

    SELECT

        d.doctor_code,

        CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

        d.specialization,

        COUNT(a.appointment_id) AS total_appointments,

        ROUND(IFNULL(SUM(b.net_amount),0),2) AS total_revenue

    FROM dim_doctor d

    LEFT JOIN fact_appointments a
           ON d.doctor_id=a.doctor_id

    LEFT JOIN fact_billing b
           ON d.doctor_id=b.doctor_id

    GROUP BY d.doctor_id

    ORDER BY total_revenue DESC;

END$$


/*==============================================================================
Procedure 20 : Department Performance Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_department_performance$$

CREATE PROCEDURE sp_department_performance()
BEGIN

    SELECT

        dep.department_name,

        COUNT(a.appointment_id) AS appointments,

        ROUND(IFNULL(SUM(b.net_amount),0),2) AS revenue

    FROM dim_department dep

    LEFT JOIN fact_appointments a
           ON dep.department_id=a.department_id

    LEFT JOIN fact_billing b
           ON dep.department_id=b.department_id

    GROUP BY dep.department_id

    ORDER BY revenue DESC;

END$$


/*==============================================================================
Procedure 21 : Patient Feedback Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_feedback_summary$$

CREATE PROCEDURE sp_feedback_summary()
BEGIN

    SELECT

        COUNT(*) AS total_feedback,

        ROUND(AVG(rating),2) AS average_rating,

        MAX(rating) AS highest_rating,

        MIN(rating) AS lowest_rating

    FROM fact_patient_feedback;

END$$


/*==============================================================================
Procedure 22 : Bed Occupancy Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_bed_occupancy_report$$

CREATE PROCEDURE sp_bed_occupancy_report()
BEGIN

    SELECT

        occupancy_status,

        COUNT(*) AS total_beds

    FROM fact_bed_occupancy

    GROUP BY occupancy_status

    ORDER BY total_beds DESC;

END$$


/*==============================================================================
Procedure 23 : Waiting Time Report
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_waiting_time_summary$$

CREATE PROCEDURE sp_waiting_time_summary()
BEGIN

    SELECT

        ROUND(AVG(waiting_minutes),2) AS average_waiting,

        MAX(waiting_minutes) AS maximum_waiting,

        MIN(waiting_minutes) AS minimum_waiting

    FROM fact_waiting_time;

END$$


/*==============================================================================
Procedure 24 : Insurance Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_insurance_summary$$

CREATE PROCEDURE sp_insurance_summary()
BEGIN

    SELECT

        claim_status,

        COUNT(*) AS total_claims,

        ROUND(SUM(claim_amount),2) AS claim_amount

    FROM fact_insurance_claims

    GROUP BY claim_status

    ORDER BY claim_amount DESC;

END$$


/*==============================================================================
Procedure 25 : Top 10 Revenue Doctors
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_top10_doctors$$

CREATE PROCEDURE sp_top10_doctors()
BEGIN

    SELECT

        d.doctor_code,

        CONCAT(d.first_name,' ',d.last_name) AS doctor_name,

        ROUND(SUM(b.net_amount),2) AS revenue

    FROM fact_billing b

    INNER JOIN dim_doctor d
            ON b.doctor_id=d.doctor_id

    GROUP BY d.doctor_id

    ORDER BY revenue DESC

    LIMIT 10;

END$$


/*==============================================================================
Procedure 26 : Top 10 Revenue Departments
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_top10_departments$$

CREATE PROCEDURE sp_top10_departments()
BEGIN

    SELECT

        dep.department_name,

        ROUND(SUM(b.net_amount),2) AS revenue

    FROM fact_billing b

    INNER JOIN dim_department dep
            ON b.department_id=dep.department_id

    GROUP BY dep.department_id

    ORDER BY revenue DESC

    LIMIT 10;

END$$

DELIMITER ;



/*==============================================================================
Testing Procedures
==============================================================================*/

CALL sp_monthly_revenue_report();

CALL sp_daily_revenue_report();

CALL sp_doctor_performance();

CALL sp_department_performance();

CALL sp_feedback_summary();

CALL sp_bed_occupancy_report();

CALL sp_waiting_time_summary();

CALL sp_insurance_summary();

CALL sp_top10_doctors();

CALL sp_top10_departments();

/*==============================================================================
 Project : Hospital Analytics Portfolio Project
 File    : 08_Stored_Procedures.sql
 Part    : 4 (Final)
 Database: hospital_analytics_db
==============================================================================*/

USE hospital_analytics_db;

DELIMITER $$

/*==============================================================================
Procedure 27 : Executive KPI Dashboard
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_executive_dashboard$$

CREATE PROCEDURE sp_executive_dashboard()
BEGIN

    SELECT

        (SELECT COUNT(*) FROM dim_patient) AS total_patients,

        (SELECT COUNT(*) FROM dim_doctor) AS total_doctors,

        (SELECT COUNT(*) FROM fact_appointments) AS total_appointments,

        (SELECT COUNT(*) FROM fact_billing) AS total_bills,

        (SELECT ROUND(SUM(net_amount),2)
         FROM fact_billing) AS total_revenue,

        (SELECT ROUND(AVG(waiting_minutes),2)
         FROM fact_waiting_time) AS average_waiting_time,

        (SELECT ROUND(AVG(rating),2)
         FROM fact_patient_feedback) AS patient_satisfaction;

END$$



/*==============================================================================
Procedure 28 : Hospital Scorecard
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_hospital_scorecard$$

CREATE PROCEDURE sp_hospital_scorecard()
BEGIN

    SELECT

        COUNT(DISTINCT patient_id) AS total_patients,

        COUNT(*) AS total_bills,

        ROUND(SUM(net_amount),2) AS revenue,

        ROUND(AVG(net_amount),2) AS average_bill,

        ROUND(MAX(net_amount),2) AS highest_bill,

        ROUND(MIN(net_amount),2) AS lowest_bill

    FROM fact_billing;

END$$



/*==============================================================================
Procedure 29 : Search Patient By Mobile Number
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_patient_by_mobile$$

CREATE PROCEDURE sp_patient_by_mobile
(
    IN p_mobile VARCHAR(15)
)
BEGIN

    SELECT *

    FROM dim_patient

    WHERE mobile_number = p_mobile;

END$$



/*==============================================================================
Procedure 30 : Search Patient By City
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_patient_by_city$$

CREATE PROCEDURE sp_patient_by_city
(
    IN p_city VARCHAR(100)
)
BEGIN

    SELECT

        patient_code,

        CONCAT(first_name,' ',last_name) AS patient_name,

        gender,

        city,

        mobile_number

    FROM dim_patient

    WHERE city = p_city

    ORDER BY patient_name;

END$$



/*==============================================================================
Procedure 31 : Search Doctor By Specialization
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_doctor_specialization$$

CREATE PROCEDURE sp_doctor_specialization
(
    IN p_specialization VARCHAR(100)
)
BEGIN

    SELECT

        doctor_code,

        CONCAT(first_name,' ',last_name) AS doctor_name,

        specialization,

        consultation_fee

    FROM dim_doctor

    WHERE specialization = p_specialization

    ORDER BY doctor_name;

END$$



/*==============================================================================
Procedure 32 : Department Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_department_summary$$

CREATE PROCEDURE sp_department_summary()
BEGIN

    SELECT

        department_name,

        department_type,

        total_beds

    FROM dim_department

    ORDER BY department_name;

END$$



/*==============================================================================
Procedure 33 : Available Beds By Ward
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_available_beds_by_ward$$

CREATE PROCEDURE sp_available_beds_by_ward()
BEGIN

    SELECT

        ward_id,

        COUNT(*) AS available_beds

    FROM dim_bed

    WHERE bed_status='Available'

    GROUP BY ward_id

    ORDER BY available_beds DESC;

END$$



/*==============================================================================
Procedure 34 : Insurance Approval Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_insurance_approval_summary$$

CREATE PROCEDURE sp_insurance_approval_summary()
BEGIN

    SELECT

        claim_status,

        COUNT(*) AS total_claims,

        ROUND(SUM(claim_amount),2) AS claim_amount

    FROM fact_insurance_claims

    GROUP BY claim_status

    ORDER BY claim_amount DESC;

END$$



/*==============================================================================
Procedure 35 : Daily Hospital Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_daily_hospital_summary$$

CREATE PROCEDURE sp_daily_hospital_summary()
BEGIN

    SELECT

        CURDATE() AS report_date,

        (SELECT COUNT(*) FROM fact_appointments
         WHERE appointment_date = CURDATE()) AS appointments_today,

        (SELECT COUNT(*) FROM fact_billing
         WHERE bill_date = CURDATE()) AS bills_today,

        (SELECT ROUND(IFNULL(SUM(net_amount),0),2)
         FROM fact_billing
         WHERE bill_date = CURDATE()) AS revenue_today;

END$$



/*==============================================================================
Procedure 36 : Monthly Hospital Summary
==============================================================================*/

DROP PROCEDURE IF EXISTS sp_monthly_hospital_summary$$

CREATE PROCEDURE sp_monthly_hospital_summary()
BEGIN

    SELECT

        YEAR(bill_date) AS year,

        MONTH(bill_date) AS month,

        COUNT(*) AS total_bills,

        ROUND(SUM(net_amount),2) AS revenue

    FROM fact_billing

    GROUP BY YEAR(bill_date),MONTH(bill_date)

    ORDER BY year,month;

END$$



DELIMITER ;



/*==============================================================================
TESTING ALL FINAL PROCEDURES
==============================================================================*/

CALL sp_executive_dashboard();

CALL sp_hospital_scorecard();

CALL sp_patient_by_mobile('9876543210');

CALL sp_patient_by_city('Nagpur');

CALL sp_doctor_specialization('Cardiology');

CALL sp_department_summary();

CALL sp_available_beds_by_ward();

CALL sp_insurance_approval_summary();

CALL sp_daily_hospital_summary();

CALL sp_monthly_hospital_summary();



/*==============================================================================
VERIFICATION
==============================================================================*/

SHOW PROCEDURE STATUS
WHERE Db='hospital_analytics_db';



/*==============================================================================
LIST ALL PROCEDURES
==============================================================================*/

SELECT

    ROUTINE_NAME,

    ROUTINE_TYPE

FROM information_schema.ROUTINES

WHERE ROUTINE_SCHEMA='hospital_analytics_db'

ORDER BY ROUTINE_NAME;



/*==============================================================================
END OF FILE
08_Stored_Procedures.sql
==============================================================================*/