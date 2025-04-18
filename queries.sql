-- Create SALES_REGIONS table
CREATE TABLE SALES_REGIONS (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(50) NOT NULL
);

-- Create EMPLOYEES table 
CREATE TABLE EMPLOYEES (
    emp_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    region_id NUMBER,
    department VARCHAR2(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_region FOREIGN KEY (region_id) REFERENCES SALES_REGIONS(region_id)
);

-- Create SALES table
CREATE TABLE SALES (
    sale_id NUMBER PRIMARY KEY,
    emp_id NUMBER,
    sale_date DATE NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    product_category VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_employee FOREIGN KEY (emp_id) REFERENCES EMPLOYEES(emp_id)
);

-- Insert data into SALES_REGIONS
INSERT INTO SALES_REGIONS VALUES (1, 'North');
INSERT INTO SALES_REGIONS VALUES (2, 'South');
INSERT INTO SALES_REGIONS VALUES (3, 'East');
INSERT INTO SALES_REGIONS VALUES (4, 'West');
INSERT INTO SALES_REGIONS VALUES (5, 'Kigali');

-- Insert data into EMPLOYEES
INSERT INTO EMPLOYEES VALUES (101, 'Christian', 'GUHIRWA', 1, 'Sales', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 55000);
INSERT INTO EMPLOYEES VALUES (102, 'Sarah', 'MUTONI', 1, 'Sales', TO_DATE('2020-03-20', 'YYYY-MM-DD'), 56000);
INSERT INTO EMPLOYEES VALUES (103, 'Michael', 'HAKUZIYAREMYE', 2, 'Sales', TO_DATE('2020-02-10', 'YYYY-MM-DD'), 54000);
INSERT INTO EMPLOYEES VALUES (104, 'Emily', 'BAYISENGE', 2, 'Sales', TO_DATE('2021-01-05', 'YYYY-MM-DD'), 52000);
INSERT INTO EMPLOYEES VALUES (105, 'David', 'GISA', 3, 'Marketing', TO_DATE('2020-05-12', 'YYYY-MM-DD'), 58000);
INSERT INTO EMPLOYEES VALUES (106, 'Jessica', 'IRADUKUNDA', 3, 'Marketing', TO_DATE('2020-06-23', 'YYYY-MM-DD'), 57000);
INSERT INTO EMPLOYEES VALUES (107, 'Robert', 'NZAMUKUNDA', 4, 'Marketing', TO_DATE('2021-03-15', 'YYYY-MM-DD'), 59000);
INSERT INTO EMPLOYEES VALUES (108, 'Lisa', 'INEZA', 4, 'IT', TO_DATE('2020-08-05', 'YYYY-MM-DD'), 62000);
INSERT INTO EMPLOYEES VALUES (109, 'Daniel', 'NZASABAMUNGU', 5, 'IT', TO_DATE('2020-09-17', 'YYYY-MM-DD'), 63000);
INSERT INTO EMPLOYEES VALUES (110, 'Jennifer', 'UKUNDWA', 5, 'IT', TO_DATE('2020-11-30', 'YYYY-MM-DD'), 61000);

-- Insert data into SALES
INSERT INTO SALES VALUES (1001, 101, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 1500.00, 'Electronics');
INSERT INTO SALES VALUES (1002, 102, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 2000.00, 'Furniture');
INSERT INTO SALES VALUES (1003, 103, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 1800.00, 'Electronics');
INSERT INTO SALES VALUES (1004, 104, TO_DATE('2023-01-25', 'YYYY-MM-DD'), 2200.00, 'Appliances');
INSERT INTO SALES VALUES (1005, 101, TO_DATE('2023-02-05', 'YYYY-MM-DD'), 1700.00, 'Electronics');
INSERT INTO SALES VALUES (1006, 102, TO_DATE('2023-02-10', 'YYYY-MM-DD'), 2100.00, 'Furniture');
INSERT INTO SALES VALUES (1007, 103, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 1900.00, 'Appliances');
INSERT INTO SALES VALUES (1008, 104, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 2300.00, 'Electronics');
INSERT INTO SALES VALUES (1009, 105, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 2500.00, 'Furniture');
INSERT INTO SALES VALUES (1010, 106, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 2700.00, 'Appliances');
INSERT INTO SALES VALUES (1011, 107, TO_DATE('2023-03-10', 'YYYY-MM-DD'), 2400.00, 'Electronics');
INSERT INTO SALES VALUES (1012, 108, TO_DATE('2023-03-15', 'YYYY-MM-DD'), 2600.00, 'Furniture');
INSERT INTO SALES VALUES (1013, 109, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 2800.00, 'Appliances');
INSERT INTO SALES VALUES (1014, 110, TO_DATE('2023-03-25', 'YYYY-MM-DD'), 3000.00, 'Electronics');
INSERT INTO SALES VALUES (1015, 101, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 3200.00, 'Furniture');
INSERT INTO SALES VALUES (1016, 102, TO_DATE('2023-04-05', 'YYYY-MM-DD'), 3100.00, 'Appliances');
INSERT INTO SALES VALUES (1017, 103, TO_DATE('2023-04-10', 'YYYY-MM-DD'), 3300.00, 'Electronics');
INSERT INTO SALES VALUES (1018, 104, TO_DATE('2023-04-15', 'YYYY-MM-DD'), 3400.00, 'Furniture');
INSERT INTO SALES VALUES (1019, 105, TO_DATE('2023-04-20', 'YYYY-MM-DD'), 3500.00, 'Appliances');
INSERT INTO SALES VALUES (1020, 106, TO_DATE('2023-04-25', 'YYYY-MM-DD'), 3600.00, 'Electronics');


-- This query compares employee salaries with the previous and next records within the same department:
SELECT 
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary) AS previous_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary) AS next_salary,
    CASE 
        WHEN salary > LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'LOWER'
        WHEN salary = LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'EQUAL'
        ELSE 'FIRST IN GROUP'
    END AS comparison_to_previous
FROM EMPLOYEES
ORDER BY department, salary;

-- This query ranks employees within each department by salary:
SELECT 
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_dense_rank
FROM EMPLOYEES
ORDER BY department, salary DESC;

-- This query fetches the top 3 sales per product category:
WITH RankedSales AS (
    SELECT 
        sale_id,
        emp_id,
        product_category,
        amount,
        DENSE_RANK() OVER (PARTITION BY product_category ORDER BY amount DESC) AS sales_rank
    FROM SALES
)
SELECT 
    RS.sale_id,
    E.first_name || ' ' || E.last_name AS employee_name,
    RS.product_category,
    RS.amount,
    RS.sales_rank
FROM RankedSales RS
JOIN EMPLOYEES E ON RS.emp_id = E.emp_id
WHERE RS.sales_rank <= 3
ORDER BY RS.product_category, RS.sales_rank;

-- Ranking Employee Salaries by Department
SELECT 
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_dense_rank
FROM EMPLOYEES
ORDER BY department, salary DESC;

-- This query retrieves the first 2 employees to join each department:
WITH RankedEmployees AS (
    SELECT 
        emp_id,
        first_name,
        last_name,
        department,
        hire_date,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) AS date_rank
    FROM EMPLOYEES
)
SELECT 
    emp_id,
    first_name,
    last_name,
    department,
    hire_date,
    date_rank
FROM RankedEmployees
WHERE date_rank <= 2
ORDER BY department, date_rank;

-- This query calculates the maximum sales amount by category and overall:
SELECT 
    S.sale_id,
    E.first_name || ' ' || E.last_name AS employee_name,
    S.product_category,
    S.amount,
    MAX(S.amount) OVER (PARTITION BY S.product_category) AS max_in_category,
    MAX(S.amount) OVER () AS overall_max
FROM SALES S
JOIN EMPLOYEES E ON S.emp_id = E.emp_id
ORDER BY S.product_category, S.amount DESC;