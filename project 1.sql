-- Create the Payroll Database

CREATE DATABASE payroll;
USE payroll;

-- 1. Roles Table:
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(100)
);

-- Insert roles into the Roles table
INSERT INTO roles (role_name) VALUES ('Manager'),('accountant'),('Software Engineer'),
('Marketing Specialist'),('Data Analyst'),('Consultant');

select * from roles;


-- 2. Departments Table:
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100)
);

-- Insert departments into the Departments table


INSERT INTO departments (department_name) VALUES ('HR'), ('IT'),('FINANANCE'),
('Sales'),('Operations'),('Production');

select * from departments;


-- 3. Employees Table:


CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    hire_date DATE,
    role_id INT,
    department_id INT,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


-- 3.1 Insert an Employee:


INSERT INTO employees (first_name, last_name, email, phone, hire_date, role_id, department_id)
VALUES ('John', 'Doe', 'john.doe@example.com', '555-1234', '2025-02-28', 1, 2),
 ('Alice', 'Smith', 'alice.smith@example.com', '555-5678', '2025-03-01', 2, 1),
('Bob', 'Johnson', 'bob.johnson@example.com', '555-6789', '2025-03-02',3,5),
('Charlie', 'Brown', 'charlie.brown@example.com', '555-7890', '2025-03-03',3,4),
('Varsha', 'Anandan', 'varsha@gmail.com', '555-7890', '2025-03-03',3,3);

select * from employees;


-- 4. Salaries Table:


CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    base_salary DECIMAL(10, 2),
    bonus DECIMAL(10, 2) DEFAULT 0.00,
    deductions DECIMAL(10, 2) DEFAULT 0.00,
    total_salary DECIMAL(10, 2) AS (base_salary + bonus - deductions) STORED,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 4.1 Add Salary Information:


INSERT INTO salaries (employee_id, base_salary, bonus, deductions)
VALUES (1, 5000.00, 500.00, 100.00),(2,8000.00,800.00,100.00),(3, 7000.00, 700.00, 150.00),
(4, 6500.00, 600.00, 200.00),(5, 7500.00, 750.00, 120.00);

select * from salaries;

-- 5. Leaves Table:


CREATE TABLE leaves (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    leave_type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    status ENUM('Approved', 'Pending', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 5.1 Record Leave Request:


INSERT INTO leaves (employee_id, leave_type, start_date, end_date, status)
VALUES (1, 'Sick', '2025-03-01', '2025-03-03', 'Pending'),
(2,'Casual','2025-03-08','2025-03-01','approved'),
(3, 'Vacation', '2025-03-10', '2025-03-15', 'Pending'),
(4, 'Maternity', '2025-04-01', '2025-04-30', 'Approved'),
(5, 'Sick', '2025-03-08', '2025-03-10', 'Rejected');

select * from leaves;

-- 6. Payments Table:


CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    payment_date DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 6.1 Make a Payment:


INSERT INTO payments (employee_id, payment_date, amount, payment_method)
VALUES (1, '2025-02-28', 5400.00, 'Bank Transfer'),(2,'2025-03-29',9000.00,'cash'),
(3, '2025-03-05', 6300.00, 'Bank Transfer'),(4, '2025-03-10', 7800.00, 'Cheque'),
(5, '2025-03-15', 6400.00, 'Bank Transfer');

select * from payments;

-- 7. Taxes Table:


CREATE TABLE taxes (
    tax_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    tax_amount DECIMAL(10, 2),
    tax_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- 7.1 Generate Tax Deductions:


INSERT INTO taxes (employee_id, tax_amount, tax_date)
VALUES (1, 400.00, '2025-02-28'),(2,500.00,'2025-03-29'),(3, 350.00, '2025-03-05'),
(4, 600.00, '2025-03-10'),(5, 450.00, '2025-03-15');

select * from taxes;

-- 8. Query to fetch details:
SELECT e.first_name, e.last_name, s.base_salary, s.bonus, s.deductions, s.total_salary, t.tax_amount
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
LEFT JOIN taxes t ON e.employee_id = t.employee_id
WHERE e.employee_id between 1 and 5;


-- Employee CRUD Operations: Create, read, update, delete employee records.

-- CREATE
INSERT INTO employees (first_name, last_name, email, phone, hire_date, role_id, department_id)
VALUES ('Radha', 'Krishnan', 'radha@example.com', '555-5678', '2025-03-01', 5, 1);

-- READ
SELECT * FROM employees;
SELECT * FROM employees WHERE employee_id = 6;

-- UPDATE 
UPDATE employees
SET phone = '555-9999', status = 'Inactive'
WHERE employee_id = 6;
SELECT * FROM EMPLOYEES;



-- DELETE 
SET SQL_SAFE_UPDATES = 0;
delete from leaves where employee_id = 5;
select * from leaves;

-- Leave Management: Employees can apply for leaves, and HR can approve or reject them.

-- Apply for Leave

INSERT INTO leaves (employee_id, leave_type, start_date, end_date, status)
VALUES (6, 'Vacation', '2025-04-10', '2025-04-15', 'Pending');
SELECT * FROM LEAVES;

-- Approve/Reject Leave
 
 UPDATE leaves
SET status = 'Rejected'
WHERE leave_id = 6;
SELECT * FROM LEAVES;


-- View Employee Leave Records

SELECT * FROM leaves WHERE employee_id = 6;


-- Payroll Calculation: The system can automatically calculate total salaries based on base salary,
--  bonus, and deductions.

-- 3. Payroll Calculation

INSERT INTO salaries (employee_id, base_salary, bonus, deductions) VALUES
(6, 7900.00, 750.00, 120.00);

SELECT e.first_name, e.last_name, s.base_salary, s.bonus, s.deductions, s.total_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
WHERE e.employee_id between 1 and 6;


-- 4. Tax Management

-- Deduct Tax for an Employee

INSERT INTO taxes (employee_id, tax_amount, tax_date)
VALUES (6, 300.00, '2025-03-31');
SELECT * FROM TAXES;

-- Retrieve Tax Details


SELECT e.first_name, e.last_name, t.tax_amount, t.tax_date
FROM employees e
INNER JOIN taxes t ON e.employee_id = t.employee_id
WHERE e.employee_id BETWEEN 1 AND 6;

 -- 5.  Pay Slip Generation
  
 SELECT e.first_name, e.last_name, s.base_salary, s.bonus, s.deductions, s.total_salary,
 t.tax_amount,(s.total_salary - IFNULL(t.tax_amount, 0)) AS net_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
LEFT JOIN taxes t ON e.employee_id = t.employee_id
WHERE e.employee_id between 1 and 6;

-- 6. Reports


-- Payroll Summary Report

SELECT e.employee_id, e.first_name, e.last_name, d.department_name, 
s.base_salary, s.bonus, s.deductions, s.total_salary
FROM employees e
INNER JOIN salaries s ON e.employee_id = s.employee_id
INNER JOIN departments d ON e.department_id = d.department_id;



-- Tax Summary Report

SELECT e.employee_id, e.first_name, e.last_name, SUM(t.tax_amount) AS total_tax
FROM employees e
INNER JOIN taxes t ON e.employee_id = t.employee_id
GROUP BY e.employee_id;

-- Leave Summary Report

SELECT e.employee_id, e.first_name, e.last_name, COUNT(l.leave_id) AS total_leaves
FROM employees e
INNER JOIN leaves l ON e.employee_id = l.employee_id
WHERE l.status = 'Approved'
GROUP BY e.employee_id;






























