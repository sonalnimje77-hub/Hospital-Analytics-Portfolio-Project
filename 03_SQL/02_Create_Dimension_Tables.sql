/*==============================================================================
 Hospital Analytics Portfolio Project
 File: 02_Create_Dimension_Tables.sql
 MySQL 8.0 - Dimension tables, sample data, verification
==============================================================================*/
USE hospital_analytics_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_lab_test;
DROP TABLE IF EXISTS dim_medicine;
DROP TABLE IF EXISTS dim_diagnosis;
DROP TABLE IF EXISTS dim_patient;
DROP TABLE IF EXISTS dim_doctor;
DROP TABLE IF EXISTS dim_bed;
DROP TABLE IF EXISTS dim_ward;
DROP TABLE IF EXISTS dim_payment_mode;
DROP TABLE IF EXISTS dim_insurance;
DROP TABLE IF EXISTS dim_department;
SET FOREIGN_KEY_CHECKS = 1;

/* 1. Department */
CREATE TABLE dim_department (
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
    department_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_department_floor CHECK (floor_number >= 0),
    CONSTRAINT chk_department_rooms CHECK (total_rooms >= 0),
    CONSTRAINT chk_department_beds CHECK (total_beds >= 0),
    CONSTRAINT chk_department_fee CHECK (consultation_fee >= 0)
) ENGINE=InnoDB;

INSERT INTO dim_department
(department_code,department_name,department_type,floor_number,building_name,extension_number,head_of_department,consultation_fee,operating_hours,is_emergency_department,total_rooms,total_beds,department_status)
VALUES
('DEP001','General Medicine','Clinical',1,'Main Building','101','Dr. Rajesh Sharma',500.00,'09:00 AM - 05:00 PM',FALSE,20,60,'Active'),
('DEP002','Cardiology','Clinical',2,'Main Building','102','Dr. Anjali Mehta',1200.00,'09:00 AM - 05:00 PM',FALSE,12,30,'Active'),
('DEP003','Neurology','Clinical',3,'Main Building','103','Dr. Vivek Verma',1500.00,'09:00 AM - 05:00 PM',FALSE,10,24,'Active'),
('DEP004','Orthopedics','Clinical',2,'Main Building','104','Dr. Neha Kulkarni',1000.00,'09:00 AM - 06:00 PM',FALSE,14,35,'Active'),
('DEP005','Emergency Medicine','Emergency',0,'Emergency Block','105','Dr. Amit Singh',800.00,'24 Hours',TRUE,18,40,'Active'),
('DEP006','Pediatrics','Clinical',4,'Main Building','106','Dr. Priya Deshmukh',700.00,'09:00 AM - 05:00 PM',FALSE,10,25,'Active'),
('DEP007','Radiology','Diagnostic',1,'Diagnostic Block','107','Dr. Rohan Patil',900.00,'08:00 AM - 08:00 PM',FALSE,8,0,'Active'),
('DEP008','Pathology','Diagnostic',1,'Diagnostic Block','108','Dr. Sneha Joshi',600.00,'08:00 AM - 08:00 PM',FALSE,6,0,'Active'),
('DEP009','Critical Care','Clinical',5,'Critical Care Block','109','Dr. Sandeep Rao',1800.00,'24 Hours',FALSE,12,30,'Active'),
('DEP010','Anesthesiology','Clinical',3,'Main Building','110','Dr. Kavita Patil',1100.00,'24 Hours',FALSE,6,0,'Active'),
('DEP011','Dermatology','Clinical',4,'Main Building','111','Dr. Nitin Shah',650.00,'10:00 AM - 06:00 PM',FALSE,6,0,'Active'),
('DEP012','ENT','Clinical',4,'Main Building','112','Dr. Pooja Rao',650.00,'09:00 AM - 05:00 PM',FALSE,6,0,'Active'),
('DEP013','Ophthalmology','Clinical',4,'Main Building','113','Dr. Meenal Joshi',700.00,'09:00 AM - 05:00 PM',FALSE,5,0,'Active'),
('DEP014','Gynecology','Clinical',5,'Main Building','114','Dr. Asha Gupta',900.00,'09:00 AM - 05:00 PM',FALSE,10,25,'Active'),
('DEP015','Urology','Clinical',5,'Main Building','115','Dr. Karan Malhotra',1000.00,'09:00 AM - 05:00 PM',FALSE,6,12,'Active'),
('DEP016','Oncology','Clinical',6,'Specialty Block','116','Dr. Sunita Rao',1600.00,'09:00 AM - 05:00 PM',FALSE,10,20,'Active'),
('DEP017','Nephrology','Clinical',6,'Specialty Block','117','Dr. Arjun Kapoor',1300.00,'09:00 AM - 05:00 PM',FALSE,6,15,'Active'),
('DEP018','Gastroenterology','Clinical',6,'Specialty Block','118','Dr. Manish Jain',1400.00,'09:00 AM - 05:00 PM',FALSE,6,15,'Active');

/* 2. Insurance */
CREATE TABLE dim_insurance (
    insurance_id INT AUTO_INCREMENT PRIMARY KEY,
    insurance_code VARCHAR(20) NOT NULL UNIQUE,
    company_name VARCHAR(150) NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    insurance_type ENUM('Government','Private','Corporate') NOT NULL,
    coverage_percentage DECIMAL(5,2) NOT NULL,
    maximum_claim_amount DECIMAL(12,2) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    website VARCHAR(255) NOT NULL,
    claim_processing_days INT NOT NULL,
    cashless_available BOOLEAN NOT NULL DEFAULT TRUE,
    company_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_company_plan (company_name,plan_name),
    CONSTRAINT chk_ins_coverage CHECK (coverage_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_ins_claim CHECK (maximum_claim_amount >= 0),
    CONSTRAINT chk_ins_days CHECK (claim_processing_days >= 0)
) ENGINE=InnoDB;
INSERT INTO dim_insurance (insurance_code,company_name,plan_name,insurance_type,coverage_percentage,maximum_claim_amount,contact_person,contact_number,email,website,claim_processing_days,cashless_available,company_status) VALUES
('INS001','Star Health Insurance','Gold Care','Private',90,500000,'Rohit Sharma','9876500001','support@starhealth.com','https://www.starhealth.in',7,TRUE,'Active'),
('INS002','HDFC ERGO','Health Suraksha','Private',85,700000,'Anjali Verma','9876500002','support@hdfcergo.com','https://www.hdfcergo.com',10,TRUE,'Active'),
('INS003','ICICI Lombard','Complete Health','Private',80,1000000,'Rahul Patil','9876500003','support@icicilombard.com','https://www.icicilombard.com',8,TRUE,'Active'),
('INS004','New India Assurance','Mediclaim Policy','Government',95,300000,'Sunil Kumar','9876500004','support@newindia.co.in','https://www.newindia.co.in',12,TRUE,'Active'),
('INS005','National Insurance','Family Health Plan','Government',90,400000,'Meena Sharma','9876500005','support@nic.co.in','https://www.nationalinsurance.nic.co.in',15,TRUE,'Active'),
('INS006','Reliance General Insurance','Health Infinity','Private',88,600000,'Amit Joshi','9876500006','support@reliancegeneral.co.in','https://www.reliancegeneral.co.in',9,TRUE,'Active'),
('INS007','Aditya Birla Health','Active Secure','Corporate',92,800000,'Neha Kulkarni','9876500007','support@adityabirlacapital.com','https://www.adityabirlacapital.com',6,TRUE,'Active'),
('INS008','Care Health Insurance','Care Supreme','Private',85,750000,'Sandeep Rao','9876500008','support@careinsurance.com','https://www.careinsurance.com',7,TRUE,'Active'),
('INS009','United India Insurance','Family Medicare','Government',90,500000,'Priya Deshmukh','9876500009','support@uiic.co.in','https://www.uiic.co.in',14,TRUE,'Active'),
('INS010','Tata AIG','Medicare Plus','Corporate',95,1200000,'Vivek Mehta','9876500010','support@tataaig.com','https://www.tataaig.com',5,TRUE,'Active');

/* 3. Payment mode */
CREATE TABLE dim_payment_mode (
    payment_mode_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_code VARCHAR(20) NOT NULL UNIQUE,
    payment_mode_name VARCHAR(50) NOT NULL UNIQUE,
    payment_category ENUM('Cash','Card','Digital','Insurance','Bank') NOT NULL,
    requires_reference BOOLEAN NOT NULL DEFAULT FALSE,
    allows_refund BOOLEAN NOT NULL DEFAULT TRUE,
    processing_fee_percentage DECIMAL(5,2) NOT NULL DEFAULT 0,
    description VARCHAR(255) NOT NULL,
    status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_pay_fee CHECK (processing_fee_percentage >= 0)
) ENGINE=InnoDB;
INSERT INTO dim_payment_mode (payment_code,payment_mode_name,payment_category,requires_reference,allows_refund,processing_fee_percentage,description,status) VALUES
('PAY001','Cash','Cash',FALSE,TRUE,0,'Cash payment at billing counter','Active'),
('PAY002','Credit Card','Card',TRUE,TRUE,2,'Credit card payment','Active'),
('PAY003','Debit Card','Card',TRUE,TRUE,1.5,'Debit card payment','Active'),
('PAY004','UPI','Digital',TRUE,TRUE,0,'UPI digital payment','Active'),
('PAY005','Net Banking','Bank',TRUE,TRUE,.5,'Internet banking payment','Active'),
('PAY006','Insurance Cashless','Insurance',TRUE,FALSE,0,'Cashless insurance payment','Active'),
('PAY007','Insurance Reimbursement','Insurance',TRUE,FALSE,0,'Insurance reimbursement','Active'),
('PAY008','Cheque','Bank',TRUE,TRUE,0,'Account payee cheque','Active'),
('PAY009','Demand Draft','Bank',TRUE,TRUE,0,'Demand draft payment','Active'),
('PAY010','Corporate Billing','Insurance',TRUE,FALSE,0,'Corporate sponsored payment','Active');

/* 4. Ward */
CREATE TABLE dim_ward (
    ward_id INT AUTO_INCREMENT PRIMARY KEY,
    ward_code VARCHAR(20) NOT NULL UNIQUE,
    ward_name VARCHAR(100) NOT NULL UNIQUE,
    ward_type ENUM('General','Semi Private','Private','ICU','NICU','PICU','CCU','Emergency','Operation Theatre') NOT NULL,
    department_id INT NOT NULL,
    floor_number SMALLINT NOT NULL,
    total_beds SMALLINT NOT NULL,
    nurse_in_charge VARCHAR(100) NOT NULL,
    ward_phone VARCHAR(20) NOT NULL,
    ward_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_ward_beds CHECK (total_beds > 0),
    CONSTRAINT fk_ward_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
INSERT INTO dim_ward (ward_code,ward_name,ward_type,department_id,floor_number,total_beds,nurse_in_charge,ward_phone,ward_status) VALUES
('WRD001','General Ward A','General',1,1,30,'Nurse Sunita','0712001001','Active'),
('WRD002','Cardiology Ward','Semi Private',2,2,20,'Nurse Kavita','0712001002','Active'),
('WRD003','Neurology Ward','Private',3,3,12,'Nurse Priya','0712001003','Active'),
('WRD004','Orthopedic Ward','General',4,2,25,'Nurse Neha','0712001004','Active'),
('WRD005','Emergency Ward','Emergency',5,0,20,'Nurse Meena','0712001005','Active'),
('WRD006','Pediatric Ward','General',6,4,20,'Nurse Asha','0712001006','Active'),
('WRD007','ICU A','ICU',9,5,15,'Nurse Ritu','0712001007','Active'),
('WRD008','CCU A','CCU',2,5,10,'Nurse Rekha','0712001008','Active'),
('WRD009','Private Suite A','Private',14,5,10,'Nurse Jyoti','0712001009','Active'),
('WRD010','NICU A','NICU',6,4,10,'Nurse Poonam','0712001010','Active');

/* 5. Bed */
CREATE TABLE dim_bed (
    bed_id INT AUTO_INCREMENT PRIMARY KEY,
    bed_code VARCHAR(20) NOT NULL UNIQUE,
    ward_id INT NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    bed_number VARCHAR(20) NOT NULL,
    bed_type ENUM('General','ICU','Ventilator','Private','Semi Private') NOT NULL,
    daily_charge DECIMAL(10,2) NOT NULL,
    bed_status ENUM('Available','Occupied','Reserved','Maintenance') NOT NULL DEFAULT 'Available',
    oxygen_supported BOOLEAN NOT NULL DEFAULT FALSE,
    ventilator_supported BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_room_bed (room_number,bed_number),
    CONSTRAINT chk_bed_charge CHECK (daily_charge >= 0),
    CONSTRAINT fk_bed_ward FOREIGN KEY (ward_id) REFERENCES dim_ward(ward_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
INSERT INTO dim_bed (bed_code,ward_id,room_number,bed_number,bed_type,daily_charge,bed_status,oxygen_supported,ventilator_supported) VALUES
('BED001',1,'101','B01','General',1500,'Occupied',FALSE,FALSE),
('BED002',1,'101','B02','General',1500,'Available',FALSE,FALSE),
('BED003',2,'201','B01','Semi Private',2500,'Occupied',TRUE,FALSE),
('BED004',2,'201','B02','Semi Private',2500,'Available',TRUE,FALSE),
('BED005',3,'301','B01','Private',4500,'Reserved',TRUE,FALSE),
('BED006',4,'201','B01','General',1800,'Available',FALSE,FALSE),
('BED007',5,'001','B01','General',2000,'Occupied',TRUE,FALSE),
('BED008',7,'501','B01','ICU',6000,'Occupied',TRUE,TRUE),
('BED009',8,'501','B01','ICU',6500,'Available',TRUE,TRUE),
('BED010',9,'601','B01','Private',5000,'Available',TRUE,FALSE),
('BED011',10,'401','B01','General',3500,'Available',TRUE,FALSE);

/* 6. Doctor */
CREATE TABLE dim_doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(150) NOT NULL,
    experience_years INT NOT NULL DEFAULT 0,
    department_id INT NOT NULL,
    consultation_fee DECIMAL(10,2) NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    joining_date DATE NOT NULL,
    shift_type ENUM('Morning','Evening','Night','Rotational') NOT NULL DEFAULT 'Morning',
    employment_type ENUM('Full Time','Part Time','Visiting') NOT NULL DEFAULT 'Full Time',
    doctor_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_doc_exp CHECK (experience_years >= 0),
    CONSTRAINT chk_doc_fee CHECK (consultation_fee >= 0),
    CONSTRAINT fk_doctor_department FOREIGN KEY (department_id) REFERENCES dim_department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
INSERT INTO dim_doctor (doctor_code,first_name,last_name,gender,date_of_birth,specialization,qualification,experience_years,department_id,consultation_fee,phone_number,email,joining_date,shift_type,employment_type,doctor_status) VALUES
('DOC001','Rajesh','Sharma','Male','1978-05-12','General Medicine','MBBS, MD',18,1,500,'9876543201','rajesh.sharma@hospital.com','2012-04-10','Morning','Full Time','Active'),
('DOC002','Anjali','Mehta','Female','1982-09-20','Cardiology','MBBS, DM Cardiology',15,2,1200,'9876543202','anjali.mehta@hospital.com','2015-06-15','Morning','Full Time','Active'),
('DOC003','Vivek','Verma','Male','1975-03-18','Neurology','MBBS, DM Neurology',20,3,1500,'9876543203','vivek.verma@hospital.com','2010-01-20','Morning','Full Time','Active'),
('DOC004','Neha','Kulkarni','Female','1985-11-08','Orthopedics','MBBS, MS Orthopedics',12,4,1000,'9876543204','neha.kulkarni@hospital.com','2016-08-12','Evening','Full Time','Active'),
('DOC005','Amit','Singh','Male','1980-07-14','Emergency Medicine','MBBS, MD Emergency',16,5,800,'9876543205','amit.singh@hospital.com','2013-03-05','Rotational','Full Time','Active'),
('DOC006','Priya','Deshmukh','Female','1988-02-25','Pediatrics','MBBS, MD Pediatrics',10,6,700,'9876543206','priya.deshmukh@hospital.com','2018-09-18','Morning','Full Time','Active'),
('DOC007','Rohan','Patil','Male','1983-12-11','Radiology','MBBS, MD Radiology',13,7,900,'9876543207','rohan.patil@hospital.com','2014-11-01','Evening','Full Time','Active'),
('DOC008','Sneha','Joshi','Female','1986-06-17','Pathology','MBBS, MD Pathology',11,8,600,'9876543208','sneha.joshi@hospital.com','2017-05-22','Morning','Part Time','Active'),
('DOC009','Sandeep','Rao','Male','1979-01-30','Critical Care','MBBS, Critical Care',17,9,1800,'9876543209','sandeep.rao@hospital.com','2011-07-11','Night','Full Time','Active'),
('DOC010','Kavita','Patil','Female','1984-10-09','Anesthesiology','MBBS, MD Anesthesia',14,10,1100,'9876543210','kavita.patil@hospital.com','2014-02-28','Rotational','Full Time','Active');

/* 7. Patient */
CREATE TABLE dim_patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    date_of_birth DATE NOT NULL,
    blood_group ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
    marital_status ENUM('Single','Married','Divorced','Widowed') NOT NULL,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    emergency_contact_name VARCHAR(100) NOT NULL,
    emergency_contact_number VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL,
    patient_status ENUM('Active','Inactive','Deceased') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_patient_postal CHECK (postal_code <> '')
) ENGINE=InnoDB;
INSERT INTO dim_patient (patient_code,first_name,last_name,gender,date_of_birth,blood_group,marital_status,phone_number,email,address,city,state,postal_code,emergency_contact_name,emergency_contact_number,registration_date,patient_status) VALUES
('PAT001','Aarav','Nimje','Male','1992-04-12','O+','Single','9000000001','aarav.nimje@email.com','12 Central Avenue','Nagpur','Maharashtra','440001','Ravi Nimje','9000010001','2024-01-05','Active'),
('PAT002','Sneha','Patil','Female','1988-07-19','A+','Married','9000000002','sneha.patil@email.com','24 Civil Lines','Nagpur','Maharashtra','440001','Rahul Patil','9000010002','2024-01-06','Active'),
('PAT003','Rohan','Joshi','Male','1979-02-21','B+','Married','9000000003','rohan.joshi@email.com','8 Wardha Road','Nagpur','Maharashtra','440015','Neha Joshi','9000010003','2024-01-08','Active'),
('PAT004','Pooja','Sharma','Female','1995-11-03','AB+','Single','9000000004','pooja.sharma@email.com','18 Sitabuldi','Nagpur','Maharashtra','440012','Amit Sharma','9000010004','2024-01-10','Active'),
('PAT005','Vikram','Rao','Male','1968-05-14','O-','Married','9000000005','vikram.rao@email.com','33 Manish Nagar','Nagpur','Maharashtra','440015','Kavita Rao','9000010005','2024-01-12','Active'),
('PAT006','Meena','Deshmukh','Female','2001-08-27','B-','Single','9000000006','meena.deshmukh@email.com','41 Sadar','Nagpur','Maharashtra','440001','Sunita Deshmukh','9000010006','2024-01-15','Active'),
('PAT007','Karan','Gupta','Male','1984-12-09','A-','Married','9000000007','karan.gupta@email.com','7 Dharampeth','Nagpur','Maharashtra','440010','Ritu Gupta','9000010007','2024-01-18','Active'),
('PAT008','Anita','Verma','Female','1972-03-16','O+','Widowed','9000000008','anita.verma@email.com','15 Mihan Road','Nagpur','Maharashtra','441108','Neeraj Verma','9000010008','2024-01-20','Active'),
('PAT009','Suresh','Kale','Male','1990-06-30','AB-','Married','9000000009','suresh.kale@email.com','9 Trimurti Nagar','Nagpur','Maharashtra','440022','Asha Kale','9000010009','2024-01-22','Active'),
('PAT010','Nisha','Kulkarni','Female','1998-10-11','A+','Single','9000000010','nisha.kulkarni@email.com','5 Manewada','Nagpur','Maharashtra','440024','Mohan Kulkarni','9000010010','2024-01-25','Active');

/* 8. Diagnosis */
CREATE TABLE dim_diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_code VARCHAR(20) NOT NULL UNIQUE,
    diagnosis_name VARCHAR(150) NOT NULL UNIQUE,
    diagnosis_category VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    severity_level ENUM('Low','Medium','High','Critical') NOT NULL,
    chronic_condition BOOLEAN NOT NULL DEFAULT FALSE,
    diagnosis_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;
INSERT INTO dim_diagnosis (diagnosis_code,diagnosis_name,diagnosis_category,description,severity_level,chronic_condition,diagnosis_status) VALUES
('DIA001','Hypertension','Cardiovascular','Persistently elevated blood pressure','Medium',TRUE,'Active'),
('DIA002','Type 2 Diabetes','Endocrine','Chronic blood glucose disorder','Medium',TRUE,'Active'),
('DIA003','Common Cold','Respiratory','Viral upper respiratory infection','Low',FALSE,'Active'),
('DIA004','Pneumonia','Respiratory','Lung infection','High',FALSE,'Active'),
('DIA005','Migraine','Neurology','Recurrent headache disorder','Medium',TRUE,'Active'),
('DIA006','Fracture','Orthopedics','Bone injury requiring treatment','High',FALSE,'Active'),
('DIA007','Asthma','Respiratory','Chronic airway condition','Medium',TRUE,'Active'),
('DIA008','Gastritis','Gastroenterology','Inflammation of stomach lining','Low',FALSE,'Active'),
('DIA009','Kidney Stone','Urology','Stone formation in urinary tract','High',FALSE,'Active'),
('DIA010','Coronary Artery Disease','Cardiovascular','Reduced blood flow to heart muscle','Critical',TRUE,'Active');

/* 9. Medicine */
CREATE TABLE dim_medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_code VARCHAR(20) NOT NULL UNIQUE,
    medicine_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150) NOT NULL,
    medicine_category VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(150) NOT NULL,
    dosage_form ENUM('Tablet','Capsule','Syrup','Injection','Cream','Ointment','Drops','Inhaler') NOT NULL,
    strength VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    prescription_required BOOLEAN NOT NULL DEFAULT TRUE,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    medicine_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_med_price CHECK (unit_price >= 0),
    CONSTRAINT chk_med_stock CHECK (stock_quantity >= 0),
    CONSTRAINT chk_med_reorder CHECK (reorder_level >= 0)
) ENGINE=InnoDB;
INSERT INTO dim_medicine (medicine_code,medicine_name,generic_name,medicine_category,manufacturer,dosage_form,strength,unit_price,prescription_required,stock_quantity,reorder_level,medicine_status) VALUES
('MED001','Paracetamol 500','Paracetamol','Analgesic','Sun Pharma','Tablet','500 mg',2.50,TRUE,500,50,'Active'),
('MED002','Amoxicillin 500','Amoxicillin','Antibiotic','Cipla','Capsule','500 mg',8.00,TRUE,300,40,'Active'),
('MED003','Metformin 500','Metformin','Antidiabetic','USV','Tablet','500 mg',3.50,TRUE,400,50,'Active'),
('MED004','Amlodipine 5','Amlodipine','Antihypertensive','Torrent','Tablet','5 mg',2.00,TRUE,450,50,'Active'),
('MED005','Pantoprazole 40','Pantoprazole','Gastrointestinal','Alkem','Tablet','40 mg',4.50,TRUE,350,40,'Active'),
('MED006','Salbutamol Inhaler','Salbutamol','Respiratory','Cipla','Inhaler','100 mcg',120.00,TRUE,80,15,'Active'),
('MED007','Diclofenac Gel','Diclofenac','Analgesic','Novartis','Gel','1%',75.00,FALSE,100,20,'Active'),
('MED008','Ceftriaxone','Ceftriaxone','Antibiotic','Zydus','Injection','1 g',95.00,TRUE,150,20,'Active'),
('MED009','Ondansetron','Ondansetron','Antiemetic','Glenmark','Injection','4 mg',25.00,TRUE,120,20,'Active'),
('MED010','Atorvastatin 20','Atorvastatin','Cardiac','Lupin','Tablet','20 mg',5.00,TRUE,300,40,'Active');

/* 10. Lab test */
CREATE TABLE dim_lab_test (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    test_code VARCHAR(20) NOT NULL UNIQUE,
    test_name VARCHAR(150) NOT NULL UNIQUE,
    test_category VARCHAR(100) NOT NULL,
    specimen_type VARCHAR(100) NOT NULL,
    normal_range VARCHAR(150) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    test_price DECIMAL(10,2) NOT NULL,
    report_time_hours INT NOT NULL,
    fasting_required BOOLEAN NOT NULL DEFAULT FALSE,
    laboratory_department VARCHAR(100) NOT NULL,
    test_status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_lab_price CHECK (test_price >= 0),
    CONSTRAINT chk_lab_time CHECK (report_time_hours >= 0)
) ENGINE=InnoDB;
INSERT INTO dim_lab_test (test_code,test_name,test_category,specimen_type,normal_range,unit,test_price,report_time_hours,fasting_required,laboratory_department,test_status) VALUES
('LAB001','Complete Blood Count','Hematology','Blood','Hemoglobin 12-17','g/dL',350,6,FALSE,'Hematology Laboratory','Active'),
('LAB002','Blood Glucose Fasting','Biochemistry','Blood','70-100','mg/dL',150,4,TRUE,'Biochemistry Laboratory','Active'),
('LAB003','Lipid Profile','Biochemistry','Blood','Total Cholesterol <200','mg/dL',600,8,TRUE,'Biochemistry Laboratory','Active'),
('LAB004','Liver Function Test','Biochemistry','Blood','ALT 7-56','U/L',700,8,FALSE,'Biochemistry Laboratory','Active'),
('LAB005','Kidney Function Test','Biochemistry','Blood','Creatinine 0.6-1.3','mg/dL',650,8,FALSE,'Biochemistry Laboratory','Active'),
('LAB006','Urine Routine','Pathology','Urine','Normal','Report',200,4,FALSE,'Clinical Pathology','Active'),
('LAB007','Thyroid Profile','Hormonal','Blood','TSH 0.4-4.0','mIU/L',500,10,FALSE,'Hormonal Laboratory','Active'),
('LAB008','HbA1c','Biochemistry','Blood','4-5.6','%',450,8,FALSE,'Biochemistry Laboratory','Active'),
('LAB009','Blood Culture','Microbiology','Blood','No Growth','Report',900,72,FALSE,'Microbiology Laboratory','Active'),
('LAB010','Electrolytes','Biochemistry','Blood','Na 135-145','mmol/L',400,6,FALSE,'Biochemistry Laboratory','Active');

/* 11. Date */
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_number INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    day_of_week INT NOT NULL,
    week_number INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter_number INT NOT NULL,
    quarter_name VARCHAR(10) NOT NULL,
    year_number INT NOT NULL,
    is_weekend BOOLEAN NOT NULL DEFAULT FALSE,
    is_month_start BOOLEAN NOT NULL DEFAULT FALSE,
    is_month_end BOOLEAN NOT NULL DEFAULT FALSE,
    is_quarter_start BOOLEAN NOT NULL DEFAULT FALSE,
    is_quarter_end BOOLEAN NOT NULL DEFAULT FALSE,
    is_year_start BOOLEAN NOT NULL DEFAULT FALSE,
    is_year_end BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB;

INSERT INTO dim_date (date_key,full_date,day_number,day_name,day_of_week,week_number,month_number,month_name,quarter_number,quarter_name,year_number,is_weekend,is_month_start,is_month_end,is_quarter_start,is_quarter_end,is_year_start,is_year_end)
WITH RECURSIVE d AS (
    SELECT DATE('2024-01-01') AS dt
    UNION ALL SELECT dt + INTERVAL 1 DAY FROM d WHERE dt < '2024-12-31'
)
SELECT
    DATE_FORMAT(dt,'%Y%m%d')+0,
    dt,
    DAY(dt), DAYNAME(dt), WEEKDAY(dt)+1, WEEK(dt,3), MONTH(dt), MONTHNAME(dt),
    QUARTER(dt), CONCAT('Q',QUARTER(dt)), YEAR(dt),
    WEEKDAY(dt) >= 5,
    DAY(dt)=1,
    DAY(dt)=DAY(LAST_DAY(dt)),
    MONTH(dt) IN (1,4,7,10) AND DAY(dt)=1,
    dt=LAST_DAY(MAKEDATE(YEAR(dt),1)+INTERVAL (QUARTER(dt)*3-1) MONTH),
    dt='2024-01-01', dt='2024-12-31'
FROM d;

/* Verification */
SELECT 'dim_department' table_name, COUNT(*) row_count FROM dim_department
UNION ALL SELECT 'dim_insurance',COUNT(*) FROM dim_insurance
UNION ALL SELECT 'dim_payment_mode',COUNT(*) FROM dim_payment_mode
UNION ALL SELECT 'dim_ward',COUNT(*) FROM dim_ward
UNION ALL SELECT 'dim_bed',COUNT(*) FROM dim_bed
UNION ALL SELECT 'dim_doctor',COUNT(*) FROM dim_doctor
UNION ALL SELECT 'dim_patient',COUNT(*) FROM dim_patient
UNION ALL SELECT 'dim_diagnosis',COUNT(*) FROM dim_diagnosis
UNION ALL SELECT 'dim_medicine',COUNT(*) FROM dim_medicine
UNION ALL SELECT 'dim_lab_test',COUNT(*) FROM dim_lab_test
UNION ALL SELECT 'dim_date',COUNT(*) FROM dim_date;
