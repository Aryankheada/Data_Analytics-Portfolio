
CREATE DATABASE IF NOT EXISTS clinical_trial_analytics;
USE clinical_trial_analytics;

CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    city VARCHAR(100),
    country VARCHAR(100),
    smoker_status VARCHAR(20),
    alcohol_use VARCHAR(20),
    comorbidity VARCHAR(255),
    enrollment_date DATE
);

CREATE TABLE drugs (
    drug_id INT PRIMARY KEY,
    drug_name VARCHAR(100),
    drug_class VARCHAR(100),
    manufacturer VARCHAR(100),
    dose_strength VARCHAR(50),
    route VARCHAR(50),
    approval_status VARCHAR(50)
);

CREATE TABLE clinical_trials (
    trial_id INT PRIMARY KEY,
    trial_name VARCHAR(150),
    phase VARCHAR(20),
    drug_id INT,
    indication VARCHAR(100),
    start_date DATE,
    end_date DATE,
    trial_status VARCHAR(50),
    target_enrollment INT,
    actual_enrollment INT,
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id)
);

CREATE TABLE trial_sites (
    site_id INT PRIMARY KEY,
    site_name VARCHAR(100),
    hospital_name VARCHAR(150),
    city VARCHAR(100),
    country VARCHAR(100),
    principal_investigator VARCHAR(100),
    trial_id INT,
    FOREIGN KEY (trial_id) REFERENCES clinical_trials(trial_id)
);

CREATE TABLE investigators (
    investigator_id INT PRIMARY KEY,
    investigator_name VARCHAR(100),
    specialization VARCHAR(100),
    experience_years INT,
    site_id INT,
    FOREIGN KEY (site_id) REFERENCES trial_sites(site_id)
);

CREATE TABLE patient_trial_enrollment (
    enrollment_id INT PRIMARY KEY,
    patient_id INT,
    trial_id INT,
    site_id INT,
    enrollment_status VARCHAR(50),
    completion_status VARCHAR(50),
    dropout_reason VARCHAR(255),
    enrollment_date DATE,
    completion_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (trial_id) REFERENCES clinical_trials(trial_id),
    FOREIGN KEY (site_id) REFERENCES trial_sites(site_id)
);

CREATE TABLE adverse_events (
    event_id INT PRIMARY KEY,
    patient_id INT,
    trial_id INT,
    drug_id INT,
    event_name VARCHAR(100),
    event_severity VARCHAR(50),
    serious_event BOOLEAN,
    hospitalized BOOLEAN,
    death BOOLEAN,
    event_date DATE,
    causality VARCHAR(50),
    report_delay_days INT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (trial_id) REFERENCES clinical_trials(trial_id),
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id)
);

CREATE TABLE lab_results (
    lab_result_id INT PRIMARY KEY,
    patient_id INT,
    trial_id INT,
    test_name VARCHAR(100),
    baseline_value DECIMAL(10,2),
    followup_value DECIMAL(10,2),
    improvement_score DECIMAL(10,2),
    test_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (trial_id) REFERENCES clinical_trials(trial_id)
);

CREATE TABLE drug_administration (
    administration_id INT PRIMARY KEY,
    patient_id INT,
    drug_id INT,
    dose VARCHAR(50),
    frequency VARCHAR(50),
    duration_days INT,
    start_date DATE,
    end_date DATE,
    adherence_rate DECIMAL(5,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (drug_id) REFERENCES drugs(drug_id)
);

CREATE TABLE regulatory_reports (
    report_id INT PRIMARY KEY,
    trial_id INT,
    site_id INT,
    report_type VARCHAR(100),
    submission_date DATE,
    deadline_date DATE,
    delay_days INT,
    compliance_status VARCHAR(50),
    FOREIGN KEY (trial_id) REFERENCES clinical_trials(trial_id),
    FOREIGN KEY (site_id) REFERENCES trial_sites(site_id)
);
