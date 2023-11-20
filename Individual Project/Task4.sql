DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Processes;
DROP TABLE IF EXISTS Job;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Maintain_assembly;
DROP TABLE IF EXISTS Maintain_process;
DROP TABLE IF EXISTS Maintain_department;
DROP TABLE IF EXISTS Assigns;
DROP TABLE IF EXISTS Manufacture;
DROP TABLE IF EXISTS Supervised;
DROP TABLE IF EXISTS Fit_Job;
DROP TABLE IF EXISTS Paint_Job; 
DROP TABLE IF EXISTS Cut_Job;
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS Cut;
DROP TABLE IF EXISTS Paint;
DROP TABLE IF EXISTS Fit;
DROP TABLE IF EXISTS Department_Account;
DROP TABLE IF EXISTS Assembly_Account;
DROP TABLE IF EXISTS Process_Account;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Assemblies;

------------------------------------------Table Creation------------------------------------------

CREATE TABLE Account(
    account_num INT PRIMARY KEY,
    date_account_established DATE
);
CREATE NONCLUSTERED INDEX idx_account_num ON Account (account_num);

CREATE TABLE Assembly_Account (
    account_num INT PRIMARY KEY,
    cost_details_1 DECIMAL,
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);

CREATE TABLE Process_Account (
    account_num INT PRIMARY KEY,
    cost_details_3 DECIMAL,
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);

CREATE TABLE Department_Account (
    account_num INT PRIMARY KEY,
    cost_details_2 DECIMAL,
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);

CREATE TABLE Transactions (
    transaction_num INT PRIMARY KEY,
    sup_cost DECIMAL,
    account_num INT,
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);
CREATE NONCLUSTERED INDEX idx_transactions_transaction_num ON Transactions (transaction_num);
CREATE INDEX idx_transactions_account_num ON Transactions (account_num);

CREATE TABLE Customer (
    customer_name VARCHAR(255) PRIMARY KEY,
    customer_address VARCHAR(255),
    category INT check (category between 1 and 10)
);
CREATE INDEX idx_customer_name ON Customer (customer_name);
CREATE INDEX idx_customer_category ON Customer (category);

CREATE TABLE Assemblies (
    assembly_id INT PRIMARY KEY,
    date_ordered DATE,
    assembly_details VARCHAR(255)
);
CREATE INDEX idx_assembly_id ON Assemblies (assembly_id);

CREATE TABLE Processes(
    process_id INT PRIMARY KEY,
    process_data VARCHAR(255)
);

CREATE TABLE Department(
    department_num INT PRIMARY KEY,
    department_data VARCHAR(255)
);

CREATE TABLE Job (
    job_no INT PRIMARY KEY,
    job_commenced_date DATE,
    job_completed_date DATE,
);
CREATE INDEX idx_job_no ON Job (job_no);
CREATE INDEX idx_job_job_completed_date ON Job (job_completed_date);

CREATE TABLE Supervised(
    process_id INT PRIMARY KEY,
    department_num INT
    FOREIGN KEY (department_num) REFERENCES Department(department_num),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id)
);
CREATE INDEX idx_supervised_department_num ON Supervised (department_num);

CREATE TABLE Manufacture (
    assembly_id INT ,
    process_id INT,
    PRIMARY KEY (assembly_id, process_id),
    FOREIGN KEY (assembly_id) REFERENCES Assemblies(assembly_id),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id)
);
CREATE INDEX idx_manufacture_assembly_id ON Manufacture (assembly_id);

CREATE TABLE Orders (
    assembly_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    FOREIGN KEY (assembly_id) REFERENCES Assemblies(assembly_id),
    FOREIGN KEY (customer_name) REFERENCES Customer(customer_name)
);
CREATE INDEX idx_orders_customer_name ON Orders (customer_name);

CREATE TABLE Assigns (
    assembly_id INT,
    process_id INT ,
    job_no INT,
    PRIMARY KEY (assembly_id, process_id),
    FOREIGN KEY (assembly_id) REFERENCES Assemblies(assembly_id),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id),
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);
CREATE INDEX idx_assigns_assembly_id ON Assigns (assembly_id);
CREATE INDEX idx_assigns_process_id ON Assigns (process_id);

CREATE TABLE Fit (
    process_id INT PRIMARY KEY,
    fit_type VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id)
);

CREATE TABLE Paint (
    process_id INT PRIMARY KEY,
    paint_type VARCHAR(255),
    painting_method VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id)
);

CREATE TABLE Cut (
    process_id INT PRIMARY KEY,
    cutting_type VARCHAR(255),
    machine_type VARCHAR(255),
    FOREIGN KEY (process_id) REFERENCES Processes(process_id)
);

CREATE TABLE Cut_Job (
    job_no INT PRIMARY KEY,
    machine_type_used VARCHAR(255),
    time_machine_used DECIMAL,
    material_used VARCHAR(255),
    labour_time DECIMAL,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Paint_Job (
    job_no INT PRIMARY KEY,
    color VARCHAR(255),
    volume DECIMAL,
    labour_time DECIMAL,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Fit_Job (
    job_no INT PRIMARY KEY,
    labour_time DECIMAL,
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Records (
    transaction_num INT PRIMARY KEY,
    job_no INT,
    FOREIGN KEY (transaction_num) REFERENCES Transactions(transaction_num),
    FOREIGN KEY (job_no) REFERENCES Job(job_no)
);

CREATE TABLE Maintain_Assembly (
    assembly_id INT PRIMARY KEY,
    account_num INT,
    FOREIGN KEY (assembly_id) REFERENCES Assemblies(assembly_id),
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);
CREATE INDEX idx_maintain_assembly_assembly_id ON Maintain_Assembly (assembly_id);

CREATE TABLE Maintain_Process (
    process_id INT PRIMARY KEY,
    account_num INT,
    FOREIGN KEY (process_id) REFERENCES Processes(process_id),
    FOREIGN KEY (process_id) REFERENCES Account(account_num)
);

CREATE TABLE Maintain_Department (
    department_num INT PRIMARY KEY,
    account_num INT,
    FOREIGN KEY (department_num) REFERENCES Department(department_num),
    FOREIGN KEY (account_num) REFERENCES Account(account_num)
);
































