/*=========================================================
  Create Database
=========================================================*/

-- Database creation moved to 01_Create_Database.sql



USE hospital_analytics_db;


/*=========================================================
  Create Table : dim_department
=========================================================*/

CREATE TABLE dim_department
(
    department_id INT AUTO_INCREMENT PRIMARY KEY,

    department_code VARCHAR(20) NOT NULL UNIQUE,

    department_name VARCHAR(100) NOT NULL UNIQUE,

    department_type VARCHAR(50) NOT NULL,

    floor_number SMALLINT NOT NULL,

    building_name VARCHAR(100) NOT NULL,

    extension_number VARCHAR(10) NOT NULL,

    head_of_department VARCHAR(100) NOT NULL,

    consultation_fee DECIMAL(10,2) NOT NULL,

    operating_hours VARCHAR(100) NOT NULL,

    is_emergency_department BOOLEAN NOT NULL DEFAULT FALSE,

    total_rooms SMALLINT NOT NULL,

    total_beds SMALLINT NOT NULL,

    department_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_floor
        CHECK (floor_number >= 0),

    CONSTRAINT chk_rooms
        CHECK (total_rooms >= 0),

    CONSTRAINT chk_beds
        CHECK (total_beds >= 0),

    CONSTRAINT chk_department_consultation_fee
        CHECK (consultation_fee >= 0)
);


/*=========================================================
  View Table Structure
=========================================================*/
 
DESC dim_department;


/*=========================================================
  Insert Sample Records
=========================================================*/

INSERT INTO dim_department
(
department_code,
department_name,
department_type,
floor_number,
building_name,
extension_number,
head_of_department,
consultation_fee,
operating_hours,
is_emergency_department,
total_rooms,
total_beds,
department_status
)
VALUES

('DEP001','General Medicine','Clinical',1,'Main Building','101','Dr. Rajesh Sharma',500.00,'09:00 AM - 05:00 PM',FALSE,20,60,'Active'),

('DEP002','Cardiology','Clinical',2,'Main Building','201','Dr. Anjali Mehta',1200.00,'09:00 AM - 06:00 PM',FALSE,18,45,'Active'),

('DEP003','Neurology','Clinical',3,'Main Building','301','Dr. Vivek Verma',1500.00,'09:00 AM - 05:00 PM',FALSE,15,35,'Active'),

('DEP004','Orthopedics','Surgical',2,'Surgical Block','221','Dr. Neha Kulkarni',1000.00,'09:00 AM - 06:00 PM',FALSE,22,55,'Active'),

('DEP005','Emergency','Clinical',0,'Emergency Block','001','Dr. Amit Singh',800.00,'24 Hours',TRUE,30,80,'Active');


/*=========================================================
  Display All Data
=========================================================*/

SELECT * FROM dim_department;

/*==============================================================================
 TABLE : dim_insurance
 Description -
 Insurance companies accepted by hospital.
 ==============================================================================*/
/*=========================================================
  TABLE : dim_insurance
  Description :
  Insurance companies accepted by the hospital.
=========================================================*/

DROP TABLE IF EXISTS dim_insurance;

CREATE TABLE dim_insurance
(
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,

    insurance_code VARCHAR(20) NOT NULL UNIQUE,

    company_name VARCHAR(150) NOT NULL,

    plan_name VARCHAR(100) NOT NULL,

    insurance_type ENUM
    (
        'Government',
        'Private',
        'Corporate'
    ) NOT NULL,

    coverage_percentage DECIMAL(5,2) NOT NULL,

    maximum_claim_amount DECIMAL(12,2) NOT NULL,

    contact_person VARCHAR(100) NOT NULL,

    contact_number VARCHAR(20) NOT NULL,

    email VARCHAR(120) NOT NULL,

    website VARCHAR(255) NOT NULL,

    claim_processing_days INT NOT NULL,

    cashless_available BOOLEAN NOT NULL DEFAULT TRUE,

    company_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_company_plan
        UNIQUE(company_name, plan_name),

    CONSTRAINT chk_coverage
        CHECK (coverage_percentage BETWEEN 0 AND 100),

    CONSTRAINT chk_claim_amount
        CHECK (maximum_claim_amount >= 0),

    CONSTRAINT chk_processing_days
        CHECK (claim_processing_days >= 0)
);


/*=========================================================
  View Table Structure
=========================================================*/

DESC dim_insurance;


/*=========================================================
  Insert Sample Data
=========================================================*/

INSERT INTO dim_insurance
(
insurance_code,
company_name,
plan_name,
insurance_type,
coverage_percentage,
maximum_claim_amount,
contact_person,
contact_number,
email,
website,
claim_processing_days,
cashless_available,
company_status
)
VALUES

('INS001','Star Health Insurance','Family Health Optima','Private',90.00,500000.00,'Rahul Sharma','9876543210','support@starhealth.com','www.starhealth.in',7,TRUE,'Active'),

('INS002','ICICI Lombard','Complete Health Insurance','Private',85.00,1000000.00,'Priya Mehta','9876543211','claims@icicilombard.com','www.icicilombard.com',10,TRUE,'Active'),

('INS003','New India Assurance','Mediclaim Policy','Government',80.00,300000.00,'Amit Verma','9876543212','support@newindia.co.in','www.newindia.co.in',15,TRUE,'Active'),

('INS004','HDFC ERGO','Health Suraksha','Private',95.00,750000.00,'Sneha Patil','9876543213','care@hdfcergo.com','www.hdfcergo.com',5,TRUE,'Active'),

('INS005','Employees State Insurance','ESI Scheme','Government',100.00,200000.00,'Vikas Kumar','9876543214','help@esic.gov.in','www.esic.gov.in',20,TRUE,'Active'),

('INS006','Medi Assist','Corporate Health Plan','Corporate',90.00,1500000.00,'Anjali Desai','9876543215','support@mediassist.in','www.mediassist.in',8,TRUE,'Active'),

('INS007','Care Health Insurance','Care Supreme','Private',88.00,1000000.00,'Rohit Singh','9876543216','claims@careinsurance.com','www.careinsurance.com',6,TRUE,'Active'),

('INS008','Bajaj Allianz','Health Guard','Private',92.00,600000.00,'Neha Kulkarni','9876543217','care@bajajallianz.co.in','www.bajajallianz.com',9,TRUE,'Active'),

('INS009','Niva Bupa','ReAssure 2.0','Private',85.00,800000.00,'Sandeep Joshi','9876543218','help@nivabupa.com','www.nivabupa.com',7,TRUE,'Active'),

('INS010','Reliance General Insurance','Health Infinity','Private',90.00,1200000.00,'Pooja Sharma','9876543219','claims@reliancegeneral.co.in','www.reliancegeneral.co.in',12,TRUE,'Active');


/*=========================================================
  Display Data
=========================================================*/

SELECT * FROM dim_insurance;

/*==============================================================================
 TABLE : dim_payment_mode
 Description :
 Payment methods used in hospital.
==============================================================================*/

/*=========================================================
 TABLE : dim_payment_mode
 Description :
 Payment methods accepted by the hospital.
=========================================================*/

DROP TABLE IF EXISTS dim_payment_mode;

CREATE TABLE dim_payment_mode
(
    payment_mode_id INT AUTO_INCREMENT PRIMARY KEY,

    payment_code VARCHAR(20) NOT NULL UNIQUE,

    payment_mode_name VARCHAR(50) NOT NULL UNIQUE,

    payment_category ENUM
    (
        'Cash',
        'Card',
        'Digital',
        'Insurance',
        'Bank'
    ) NOT NULL,

    requires_reference BOOLEAN NOT NULL DEFAULT FALSE,

    allows_refund BOOLEAN NOT NULL DEFAULT TRUE,

    processing_fee_percentage DECIMAL(5,2) NOT NULL DEFAULT 0.00,

    description VARCHAR(255) NOT NULL,

    status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_processing_fee
        CHECK (processing_fee_percentage >= 0)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_payment_mode;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_payment_mode
(
payment_code,
payment_mode_name,
payment_category,
requires_reference,
allows_refund,
processing_fee_percentage,
description,
status
)
VALUES

('PAY001','Cash','Cash',FALSE,TRUE,0.00,
'Cash payment collected at billing counter','Active'),

('PAY002','Credit Card','Card',TRUE,TRUE,2.00,
'Visa, MasterCard and RuPay credit cards accepted','Active'),

('PAY003','Debit Card','Card',TRUE,TRUE,1.00,
'Debit card payment through POS machine','Active'),

('PAY004','UPI','Digital',TRUE,TRUE,0.00,
'Payments using Google Pay, PhonePe, BHIM and Paytm','Active'),

('PAY005','Net Banking','Bank',TRUE,TRUE,0.50,
'Online bank transfer payment','Active'),

('PAY006','Cheque','Bank',TRUE,FALSE,0.00,
'Cheque payment subject to realization','Active'),

('PAY007','Insurance Claim','Insurance',TRUE,FALSE,0.00,
'Cashless insurance settlement','Active'),

('PAY008','Corporate Credit','Insurance',TRUE,TRUE,0.00,
'Corporate tie-up billing','Active'),

('PAY009','Demand Draft','Bank',TRUE,FALSE,0.00,
'Payment through demand draft','Active'),

('PAY010','Wallet','Digital',TRUE,TRUE,0.00,
'Digital wallets such as Amazon Pay and Mobikwik','Active');


/*=========================================================
 Display Data
=========================================================*/
/*==============================================================================
 TABLE : dim_ward
 Description :
 Hospital ward master.
==============================================================================*/

/*=========================================================
 TABLE : dim_ward
 Description :
 Hospital Ward Master Table
=========================================================*/

DROP TABLE IF EXISTS dim_ward;

CREATE TABLE dim_ward
(
    ward_id INT AUTO_INCREMENT PRIMARY KEY,

    ward_code VARCHAR(20) NOT NULL UNIQUE,

    ward_name VARCHAR(100) NOT NULL UNIQUE,

    ward_type ENUM
    (
        'General',
        'Semi Private',
        'Private',
        'ICU',
        'NICU',
        'PICU',
        'CCU',
        'Emergency',
        'Operation Theatre'
    ) NOT NULL,

    department_id INT NOT NULL,

    floor_number SMALLINT NOT NULL,

    total_beds SMALLINT NOT NULL,

    nurse_in_charge VARCHAR(100) NOT NULL,

    ward_phone VARCHAR(20) NOT NULL,

    ward_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_total_beds
        CHECK (total_beds > 0),

    CONSTRAINT fk_ward_department
        FOREIGN KEY (department_id)
        REFERENCES dim_department(department_id)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_ward;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_ward
(
ward_code,
ward_name,
ward_type,
department_id,
floor_number,
total_beds,
nurse_in_charge,
ward_phone,
ward_status
)
VALUES

('WRD001','General Ward A','General',1,1,30,'Mrs. Sunita Patil','0712-2201001','Active'),

('WRD002','General Ward B','General',1,1,25,'Mrs. Kavita Sharma','0712-2201002','Active'),

('WRD003','Cardiac ICU','ICU',2,2,15,'Mrs. Neha Joshi','0712-2201003','Active'),

('WRD004','Private Ward','Private',2,3,20,'Mrs. Pooja Deshmukh','0712-2201004','Active'),

('WRD005','Semi Private Ward','Semi Private',3,2,18,'Mrs. Anita Verma','0712-2201005','Active'),

('WRD006','Neurology ICU','ICU',3,3,12,'Mrs. Ritu Singh','0712-2201006','Active'),

('WRD007','Emergency Ward','Emergency',5,0,40,'Mrs. Swati Kulkarni','0712-2201007','Active'),

('WRD008','Operation Theatre 1','Operation Theatre',4,2,8,'Mrs. Meena Gupta','0712-2201008','Active'),

('WRD009','NICU','NICU',5,3,10,'Mrs. Shalini Rao','0712-2201009','Active'),

('WRD010','CCU','CCU',2,3,16,'Mrs. Rekha Patil','0712-2201010','Active');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_ward;

/*=========================================================
 TABLE : dim_bed
 Description :
 Individual Hospital Beds
=========================================================*/

DROP TABLE IF EXISTS dim_bed;

CREATE TABLE dim_bed
(
    bed_id INT AUTO_INCREMENT PRIMARY KEY,

    bed_code VARCHAR(20) NOT NULL UNIQUE,

    ward_id INT NOT NULL,

    room_number VARCHAR(20) NOT NULL,

    bed_number VARCHAR(20) NOT NULL,

    bed_type ENUM
    (
        'General',
        'ICU',
        'Ventilator',
        'Private',
        'Semi Private'
    ) NOT NULL,

    daily_charge DECIMAL(10,2) NOT NULL,

    bed_status ENUM
    (
        'Available',
        'Occupied',
        'Reserved',
        'Maintenance'
    ) NOT NULL DEFAULT 'Available',

    oxygen_supported BOOLEAN NOT NULL DEFAULT FALSE,

    ventilator_supported BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT uq_room_bed
        UNIQUE (room_number, bed_number),

    CONSTRAINT chk_daily_charge
        CHECK (daily_charge >= 0),

    CONSTRAINT fk_bed_ward
        FOREIGN KEY (ward_id)
        REFERENCES dim_ward(ward_id)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_bed;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_bed
(
bed_code,
ward_id,
room_number,
bed_number,
bed_type,
daily_charge,
bed_status,
oxygen_supported,
ventilator_supported
)
VALUES

('BED001',1,'G101','B1','General',1500.00,'Available',FALSE,FALSE),

('BED002',1,'G101','B2','General',1500.00,'Occupied',FALSE,FALSE),

('BED003',2,'G102','B1','General',1500.00,'Reserved',FALSE,FALSE),

('BED004',3,'ICU201','B1','ICU',5000.00,'Occupied',TRUE,TRUE),

('BED005',3,'ICU201','B2','Ventilator',7000.00,'Available',TRUE,TRUE),

('BED006',4,'P301','B1','Private',3500.00,'Available',TRUE,FALSE),

('BED007',5,'SP202','B1','Semi Private',2500.00,'Occupied',FALSE,FALSE),

('BED008',6,'ICU302','B1','ICU',5500.00,'Maintenance',TRUE,TRUE),

('BED009',7,'ER001','B1','General',1800.00,'Available',TRUE,FALSE),

('BED010',10,'CCU401','B1','ICU',6000.00,'Occupied',TRUE,TRUE);


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_bed;

/*=========================================================
 TABLE : dim_doctor
 Description :
 Doctor Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_doctor;

CREATE TABLE dim_doctor
(
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,

    doctor_code VARCHAR(20) NOT NULL UNIQUE,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    gender ENUM
    (
        'Male',
        'Female',
        'Other'
    ) NOT NULL,

    date_of_birth DATE NOT NULL,

    specialization VARCHAR(100) NOT NULL,

    qualification VARCHAR(150) NOT NULL,

    experience_years INT NOT NULL DEFAULT 0,

    department_id INT NOT NULL,

    consultation_fee DECIMAL(10,2) NOT NULL,

    phone_number VARCHAR(20) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    joining_date DATE NOT NULL,

    shift_type ENUM
    (
        'Morning',
        'Evening',
        'Night',
        'Rotational'
    ) NOT NULL DEFAULT 'Morning',

    employment_type ENUM
    (
        'Full Time',
        'Part Time',
        'Visiting'
    ) NOT NULL DEFAULT 'Full Time',

    doctor_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_experience
        CHECK (experience_years >= 0),

    CONSTRAINT chk_consultation_fee
        CHECK (consultation_fee >= 0),

    CONSTRAINT fk_doctor_department
        FOREIGN KEY (department_id)
        REFERENCES dim_department(department_id)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_doctor;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_doctor
(
doctor_code,
first_name,
last_name,
gender,
date_of_birth,
specialization,
qualification,
experience_years,
department_id,
consultation_fee,
phone_number,
email,
joining_date,
shift_type,
employment_type,
doctor_status
)
VALUES

('DOC001','Rajesh','Sharma','Male','1978-05-12','General Medicine','MBBS, MD',18,1,500.00,'9876543201','rajesh.sharma@hospital.com','2012-04-10','Morning','Full Time','Active'),

('DOC002','Anjali','Mehta','Female','1982-09-20','Cardiology','MBBS, DM Cardiology',15,2,1200.00,'9876543202','anjali.mehta@hospital.com','2015-06-15','Morning','Full Time','Active'),

('DOC003','Vivek','Verma','Male','1975-03-18','Neurology','MBBS, DM Neurology',20,3,1500.00,'9876543203','vivek.verma@hospital.com','2010-01-20','Morning','Full Time','Active'),

('DOC004','Neha','Kulkarni','Female','1985-11-08','Orthopedics','MBBS, MS Orthopedics',12,4,1000.00,'9876543204','neha.kulkarni@hospital.com','2016-08-12','Evening','Full Time','Active'),

('DOC005','Amit','Singh','Male','1980-07-14','Emergency Medicine','MBBS, MD Emergency',16,5,800.00,'9876543205','amit.singh@hospital.com','2013-03-05','Rotational','Full Time','Active'),

('DOC006','Priya','Deshmukh','Female','1988-02-25','Pediatrics','MBBS, MD Pediatrics',10,6,700.00,'9876543206','priya.deshmukh@hospital.com','2018-09-18','Morning','Full Time','Active'),

('DOC007','Rohan','Patil','Male','1983-12-11','Radiology','MBBS, MD Radiology',13,7,900.00,'9876543207','rohan.patil@hospital.com','2014-11-01','Evening','Full Time','Active'),

('DOC008','Sneha','Joshi','Female','1986-06-17','Pathology','MBBS, MD Pathology',11,8,600.00,'9876543208','sneha.joshi@hospital.com','2017-05-22','Morning','Part Time','Active'),

('DOC009','Sandeep','Rao','Male','1979-01-30','ICU Specialist','MBBS, Critical Care',17,9,1800.00,'9876543209','sandeep.rao@hospital.com','2011-07-11','Night','Full Time','Active'),

('DOC010','Kavita','Patil','Female','1984-10-09','Anesthesiology','MBBS, MD Anesthesia',14,10,1100.00,'9876543210','kavita.patil@hospital.com','2014-02-28','Rotational','Full Time','Active');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_doctor;

/*=========================================================
 TABLE : dim_patient
 Description :
 Patient Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_patient;

CREATE TABLE dim_patient
(
    patient_id INT AUTO_INCREMENT PRIMARY KEY,

    patient_code VARCHAR(20) NOT NULL UNIQUE,

    first_name VARCHAR(50) NOT NULL,

    last_name VARCHAR(50) NOT NULL,

    gender ENUM
    (
        'Male',
        'Female',
        'Other'
    ) NOT NULL,

    date_of_birth DATE NOT NULL,

    age INT NOT NULL,

    blood_group ENUM
    (
        'A+','A-',
        'B+','B-',
        'AB+','AB-',
        'O+','O-'
    ) NOT NULL,

    marital_status ENUM
    (
        'Single',
        'Married',
        'Divorced',
        'Widowed'
    ) NOT NULL,

    phone_number VARCHAR(20) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    address VARCHAR(200) NOT NULL,

    city VARCHAR(100) NOT NULL,

    state VARCHAR(100) NOT NULL,

    pincode VARCHAR(10) NOT NULL,

    occupation VARCHAR(100) NOT NULL,

    registration_date DATE NOT NULL,

    patient_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_age
        CHECK (age BETWEEN 0 AND 120)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_patient;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_patient
(
patient_code,
first_name,
last_name,
gender,
date_of_birth,
age,
blood_group,
marital_status,
phone_number,
email,
address,
city,
state,
pincode,
occupation,
registration_date,
patient_status
)
VALUES

('PAT001','Rahul','Sharma','Male','1992-05-14',33,'B+','Married','9876543001','rahul.sharma@gmail.com','MG Road','Nagpur','Maharashtra','440001','Engineer','2024-01-15','Active'),

('PAT002','Priya','Patel','Female','1988-09-21',37,'O+','Married','9876543002','priya.patel@gmail.com','Civil Lines','Nagpur','Maharashtra','440010','Teacher','2024-01-18','Active'),

('PAT003','Amit','Verma','Male','1998-07-10',27,'A+','Single','9876543003','amit.verma@gmail.com','Dharampeth','Nagpur','Maharashtra','440012','Software Engineer','2024-02-05','Active'),

('PAT004','Sneha','Kulkarni','Female','1995-11-03',30,'AB+','Single','9876543004','sneha.kulkarni@gmail.com','Pratap Nagar','Nagpur','Maharashtra','440022','Accountant','2024-02-20','Active'),

('PAT005','Rohan','Patil','Male','1985-03-25',40,'O-','Married','9876543005','rohan.patil@gmail.com','Wardha Road','Nagpur','Maharashtra','440015','Businessman','2024-03-02','Active'),

('PAT006','Neha','Joshi','Female','1993-08-17',32,'A-','Married','9876543006','neha.joshi@gmail.com','Manish Nagar','Nagpur','Maharashtra','440025','Bank Manager','2024-03-15','Active'),

('PAT007','Vikas','Gupta','Male','1979-12-08',46,'B-','Married','9876543007','vikas.gupta@gmail.com','Sitabuldi','Nagpur','Maharashtra','440018','Lawyer','2024-04-01','Active'),

('PAT008','Pooja','Deshmukh','Female','2000-01-19',26,'AB-','Single','9876543008','pooja.deshmukh@gmail.com','Trimurti Nagar','Nagpur','Maharashtra','440020','Student','2024-04-10','Active'),

('PAT009','Sandeep','Rao','Male','1990-06-11',35,'O+','Married','9876543009','sandeep.rao@gmail.com','Laxmi Nagar','Nagpur','Maharashtra','440022','Sales Manager','2024-04-22','Active'),

('PAT010','Kavita','Shinde','Female','1987-10-28',38,'A+','Married','9876543010','kavita.shinde@gmail.com','Bajaj Nagar','Nagpur','Maharashtra','440010','Doctor','2024-05-05','Active');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_patient;

/*=========================================================
 TABLE : dim_date
 Description :
 Date Dimension Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date
(
    date_id INT AUTO_INCREMENT PRIMARY KEY,

    full_date DATE NOT NULL UNIQUE,

    day_number TINYINT NOT NULL,

    day_name VARCHAR(20) NOT NULL,

    week_number TINYINT NOT NULL,

    month_number TINYINT NOT NULL,

    month_name VARCHAR(20) NOT NULL,

    quarter_number TINYINT NOT NULL,

    year_number SMALLINT NOT NULL,

    is_weekend BOOLEAN NOT NULL DEFAULT FALSE,

    is_holiday BOOLEAN NOT NULL DEFAULT FALSE,

    financial_year VARCHAR(10) NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_day
        CHECK (day_number BETWEEN 1 AND 31),

    CONSTRAINT chk_week
        CHECK (week_number BETWEEN 1 AND 53),

    CONSTRAINT chk_month
        CHECK (month_number BETWEEN 1 AND 12),

    CONSTRAINT chk_quarter
        CHECK (quarter_number BETWEEN 1 AND 4)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_date;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_date
(
full_date,
day_number,
day_name,
week_number,
month_number,
month_name,
quarter_number,
year_number,
is_weekend,
is_holiday,
financial_year
)
VALUES

('2024-01-01',1,'Monday',1,1,'January',1,2024,FALSE,TRUE,'2023-24'),

('2024-01-02',2,'Tuesday',1,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-03',3,'Wednesday',1,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-04',4,'Thursday',1,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-05',5,'Friday',1,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-06',6,'Saturday',1,1,'January',1,2024,TRUE,FALSE,'2023-24'),

('2024-01-07',7,'Sunday',1,1,'January',1,2024,TRUE,FALSE,'2023-24'),

('2024-01-08',8,'Monday',2,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-09',9,'Tuesday',2,1,'January',1,2024,FALSE,FALSE,'2023-24'),

('2024-01-10',10,'Wednesday',2,1,'January',1,2024,FALSE,FALSE,'2023-24');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_date;

/*=========================================================
 TABLE : dim_medicine
 Description :
 Medicine Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_medicine;

CREATE TABLE dim_medicine
(
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,

    medicine_code VARCHAR(20) NOT NULL UNIQUE,

    medicine_name VARCHAR(100) NOT NULL,

    generic_name VARCHAR(100) NOT NULL,

    brand_name VARCHAR(100) NOT NULL,

    medicine_category ENUM
    (
        'Tablet',
        'Capsule',
        'Syrup',
        'Injection',
        'Ointment',
        'Drops',
        'Inhaler',
        'Powder'
    ) NOT NULL,

    dosage_strength VARCHAR(50) NOT NULL,

    manufacturer_name VARCHAR(100) NOT NULL,

    purchase_price DECIMAL(10,2) NOT NULL,

    selling_price DECIMAL(10,2) NOT NULL,

    stock_quantity INT NOT NULL,

    reorder_level INT NOT NULL,

    storage_condition VARCHAR(100) NOT NULL,

    medicine_status ENUM
    (
        'Available',
        'Out of Stock',
        'Discontinued'
    ) NOT NULL DEFAULT 'Available',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_purchase_price
        CHECK (purchase_price >= 0),

    CONSTRAINT chk_selling_price
        CHECK (selling_price >= purchase_price),

    CONSTRAINT chk_stock_quantity
        CHECK (stock_quantity >= 0),

    CONSTRAINT chk_reorder_level
        CHECK (reorder_level >= 0)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_medicine;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_medicine
(
medicine_code,
medicine_name,
generic_name,
brand_name,
medicine_category,
dosage_strength,
manufacturer_name,
purchase_price,
selling_price,
stock_quantity,
reorder_level,
storage_condition,
medicine_status
)
VALUES

('MED001','Paracetamol 500','Paracetamol','Crocin','Tablet','500 mg','GSK',2.50,5.00,500,100,'Room Temperature','Available'),

('MED002','Azithromycin','Azithromycin','Azee','Tablet','500 mg','Cipla',18.00,28.00,250,50,'Room Temperature','Available'),

('MED003','Amoxicillin','Amoxicillin','Mox','Capsule','250 mg','Sun Pharma',8.00,15.00,300,75,'Room Temperature','Available'),

('MED004','Pantoprazole','Pantoprazole','Pantocid','Tablet','40 mg','Sun Pharma',5.00,10.00,400,80,'Room Temperature','Available'),

('MED005','Insulin','Human Insulin','Huminsulin','Injection','100 IU/ml','Eli Lilly',180.00,250.00,120,30,'Refrigerated (2°C-8°C)','Available'),

('MED006','Cough Syrup','Ambroxol','Ambrolite','Syrup','100 ml','Abbott',45.00,70.00,180,40,'Room Temperature','Available'),

('MED007','Diclofenac Gel','Diclofenac','Voveran','Ointment','30 g','Novartis',55.00,85.00,150,25,'Cool & Dry Place','Available'),

('MED008','Eye Drops','Moxifloxacin','Moxicip','Drops','5 ml','Cipla',65.00,95.00,100,20,'Room Temperature','Available'),

('MED009','Asthma Inhaler','Salbutamol','Asthalin','Inhaler','100 mcg','Cipla',140.00,190.00,80,20,'Room Temperature','Available'),

('MED010','ORS Powder','Oral Rehydration Salts','Electral','Powder','21.8 g','FDC Ltd.',12.00,20.00,350,60,'Dry Place','Available');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_medicine;
/*=========================================================
 TABLE : dim_lab_test
 Description :
 Laboratory Test Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_lab_test;

CREATE TABLE dim_lab_test
(
    lab_test_id INT AUTO_INCREMENT PRIMARY KEY,

    lab_test_code VARCHAR(20) NOT NULL UNIQUE,

    lab_test_name VARCHAR(100) NOT NULL,

    test_category ENUM
    (
        'Blood',
        'Urine',
        'Stool',
        'Biochemistry',
        'Microbiology',
        'Pathology',
        'Radiology',
        'Cardiology',
        'Hormone',
        'COVID-19'
    ) NOT NULL,

    sample_type VARCHAR(50) NOT NULL,

    test_method VARCHAR(100) NOT NULL,

    normal_range VARCHAR(100) NOT NULL,

    unit_of_measure VARCHAR(30) NOT NULL,

    test_cost DECIMAL(10,2) NOT NULL,

    report_delivery_time VARCHAR(50) NOT NULL,

    fasting_required BOOLEAN NOT NULL DEFAULT FALSE,

    preparation_instructions VARCHAR(255) NOT NULL,

    lab_department VARCHAR(100) NOT NULL,

    lab_test_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_test_cost
        CHECK (test_cost >= 0)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_lab_test;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_lab_test
(
lab_test_code,
lab_test_name,
test_category,
sample_type,
test_method,
normal_range,
unit_of_measure,
test_cost,
report_delivery_time,
fasting_required,
preparation_instructions,
lab_department,
lab_test_status
)
VALUES

('LAB001','Complete Blood Count (CBC)','Blood','Blood','Automated Cell Counter','4.5 - 11.0','x10³/uL',450.00,'4 Hours',FALSE,'No special preparation required','Pathology','Active'),

('LAB002','Blood Sugar Fasting','Blood','Blood','Glucose Oxidase','70 - 100','mg/dL',250.00,'2 Hours',TRUE,'Fast for 8-10 hours','Biochemistry','Active'),

('LAB003','Liver Function Test','Biochemistry','Blood','Spectrophotometry','Normal','IU/L',850.00,'6 Hours',TRUE,'Fast for 10 hours','Biochemistry','Active'),

('LAB004','Kidney Function Test','Biochemistry','Blood','Automated Analyzer','Normal','mg/dL',800.00,'6 Hours',TRUE,'Drink adequate water','Biochemistry','Active'),

('LAB005','Urine Routine Examination','Urine','Urine','Microscopy','Normal','N/A',300.00,'3 Hours',FALSE,'Collect first morning sample','Pathology','Active'),

('LAB006','Lipid Profile','Blood','Blood','Enzymatic Method','Normal','mg/dL',900.00,'6 Hours',TRUE,'Fast for 10-12 hours','Biochemistry','Active'),

('LAB007','Thyroid Profile (T3,T4,TSH)','Hormone','Blood','Immunoassay','Normal','mIU/L',1200.00,'24 Hours',FALSE,'No special preparation','Hormone Lab','Active'),

('LAB008','COVID-19 RT-PCR','COVID-19','Nasal Swab','RT-PCR','Negative','N/A',1500.00,'24 Hours',FALSE,'Wear a mask during collection','Microbiology','Active'),

('LAB009','Chest X-Ray','Radiology','None','Digital X-Ray','Normal','N/A',600.00,'1 Hour',FALSE,'Remove metal objects','Radiology','Active'),

('LAB010','ECG','Cardiology','None','Electrocardiography','Normal','N/A',350.00,'30 Minutes',FALSE,'Avoid heavy exercise before test','Cardiology','Active');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_lab_test;
/*=========================================================
 TABLE : dim_diagnosis
 Description :
 Diagnosis Master Information
=========================================================*/

DROP TABLE IF EXISTS dim_diagnosis;

CREATE TABLE dim_diagnosis
(
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,

    diagnosis_code VARCHAR(20) NOT NULL UNIQUE,

    icd10_code VARCHAR(20) NOT NULL UNIQUE,

    diagnosis_name VARCHAR(150) NOT NULL,

    diagnosis_category ENUM
    (
        'Cardiology',
        'Neurology',
        'Orthopedics',
        'General Medicine',
        'Pulmonology',
        'Gastroenterology',
        'Nephrology',
        'Endocrinology',
        'Dermatology',
        'Infectious Disease'
    ) NOT NULL,

    disease_type ENUM
    (
        'Acute',
        'Chronic',
        'Infectious',
        'Genetic',
        'Lifestyle',
        'Congenital'
    ) NOT NULL,

    severity_level ENUM
    (
        'Low',
        'Moderate',
        'High',
        'Critical'
    ) NOT NULL,

    description VARCHAR(255) NOT NULL,

    treatment_department VARCHAR(100) NOT NULL,

    average_treatment_days INT NOT NULL,

    follow_up_required BOOLEAN NOT NULL DEFAULT TRUE,

    diagnosis_status ENUM
    (
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_treatment_days
        CHECK (average_treatment_days >= 0)
);


/*=========================================================
 View Table Structure
=========================================================*/

DESC dim_diagnosis;


/*=========================================================
 Insert Sample Data
=========================================================*/

INSERT INTO dim_diagnosis
(
diagnosis_code,
icd10_code,
diagnosis_name,
diagnosis_category,
disease_type,
severity_level,
description,
treatment_department,
average_treatment_days,
follow_up_required,
diagnosis_status
)
VALUES
	
('DIA001','I10','Essential Hypertension','Cardiology','Chronic','Moderate',
'High blood pressure requiring regular monitoring.',
'Cardiology',30,TRUE,'Active'),

('DIA002','E11','Type 2 Diabetes Mellitus','Endocrinology','Chronic','Moderate',
'High blood sugar caused by insulin resistance.',
'Endocrinology',90,TRUE,'Active'),

('DIA003','J18','Pneumonia','Pulmonology','Acute','High',
'Infection causing inflammation of the lungs.',
'Pulmonology',14,TRUE,'Active'),

('DIA004','M17','Osteoarthritis of Knee','Orthopedics','Chronic','Moderate',
'Degenerative joint disease affecting the knee.',
'Orthopedics',60,TRUE,'Active'),

('DIA005','G43','Migraine','Neurology','Chronic','Moderate',
'Recurrent severe headache disorder.',
'Neurology',30,TRUE,'Active'),

('DIA006','K21','Gastroesophageal Reflux Disease','Gastroenterology','Chronic','Low',
'Acid reflux causing heartburn.',
'Gastroenterology',21,TRUE,'Active'),

('DIA007','N18','Chronic Kidney Disease','Nephrology','Chronic','High',
'Progressive loss of kidney function.',
'Nephrology',180,TRUE,'Active'),

('DIA008','L20','Atopic Dermatitis','Dermatology','Chronic','Low',
'Chronic inflammatory skin condition.',
'Dermatology',30,TRUE,'Active'),

('DIA009','A09','Acute Gastroenteritis','Infectious Disease','Infectious','Moderate',
'Intestinal infection causing diarrhea and vomiting.',
'General Medicine',7,FALSE,'Active'),

('DIA010','U07.1','COVID-19','Infectious Disease','Infectious','Critical',
'Coronavirus disease caused by SARS-CoV-2.',
'General Medicine',14,TRUE,'Active');


/*=========================================================
 Display Data
=========================================================*/

SELECT * FROM dim_diagnosis;

/*=========================================================
 Show All Tables
=========================================================*/

SHOW TABLES;


/*=========================================================
 View Structure of Each Table
=========================================================*/

DESC dim_department;
DESC dim_insurance;
DESC dim_payment_mode;
DESC dim_ward;
DESC dim_bed;
DESC dim_doctor;
DESC dim_patient;
DESC dim_date;
DESC dim_medicine;
DESC dim_lab_test;
DESC dim_diagnosis;

/*=========================================================
 Display All Records from Each Table
=========================================================*/

SELECT * FROM dim_department;

SELECT * FROM dim_insurance;

SELECT * FROM dim_payment_mode;

SELECT * FROM dim_ward;

SELECT * FROM dim_bed;

SELECT * FROM dim_doctor;

SELECT * FROM dim_patient;

SELECT * FROM dim_date;

SELECT * FROM dim_medicine;

SELECT * FROM dim_lab_test;

SELECT * FROM dim_diagnosis;