# ASSIGNMENT: Exploring SQL Window Functions _ Tasks & Queries
# COURSE: Database Development with PL/SQL
# GROUP: LEGACY FUNCTION FOUNDERS
## Members: 
- GUHIRWA Christian [26750]  
- ISHIME Emmanuel []

## Lecture: MANIRAGUHA Eric

---

## Step 1: Set Up the Database Schema

### Create Tables
The following SQL statements create the necessary tables for the assignment:

```sql
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
```
### Insert Data
The following SQL statements populate the tables with sample data:

```sql
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
```

## Step 2: Complete the Window Functions Tasks
### Task 1: Compare Values with Previous or Next Records
This query compares employee salaries with the previous and next records within the same department:

```sql
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
```
#### Explanation:
1. `LAG(salary)`:
    - Retrieves the salary of the previous employee in the same department when ordered by salary.
    - For the first employee in each department, LAG(salary) returns NULL.

2. `LEAD()`: 
    - retrieves the salary of the next employee in the same     department.
    - For the last employee in each department, LEAD(salary) returns NULL.
3. The `CASE` statement: 
    - If the current salary is greater than the previous salary (`LAG(salary)`), the result is HIGHER.
    - If the current salary is less than the previous salary, the result is `LOWER`.
    - If the current salary is equal to the previous salary, the result is `EQUAL`.
    - If there is no previous record (`LAG(salary)` is `NULL`), the result is `FIRST IN GROUP`.

4. `Ordering`:
    - The `ORDER BY department, salary` ensures that employees are grouped by department and sorted by salary within each department.

### Task 2: Ranking Data within a Category
This query ranks employees within each department by salary:

```sql
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
```

#### Explanation:
Key Concepts:
1. `RANK()`:
    - Assigns a rank to each record within a partition (e.g., department) based on the specified order (e.g., salary descending).
    - If there are ties (records with the same value), they receive the same rank, but the next rank is skipped (leaving a gap).
2. `DENSE_RANK()`:
    - Similar to `RANK()`, but it does not leave gaps in the ranking sequence when there are ties.
    - Tied records receive the same rank, and the next rank continues sequentially.

3. Differences Between `RANK()` and `DENSE_RANK()`:
    - **Handling Ties**:
        - Both `RANK()` and `DENSE_RANK()` assign the same rank to tied records.
        - However, `RANK()` skips the next rank after a tie, while `DENSE_RANK()` continues sequentially.
    - **Example with Ties**: For the `Marketing` department:
        -  `Robert` has the highest salary and is ranked `1` by both `RANK()` and `DENSE_RANK()`.
        - `David` and `Jessica` have the same salary (`58000`):
            - `RANK()` assigns them both rank `2`, but the next rank is `4` (skipping `3`).
            - `DENSE_RANK()` assigns them both rank `2`, and the next rank is `3` (no gaps).
3. The `PARTITION BY department` clause ensures ranking is done separately within each department.

### Task 3: Identifying Top Records
This query fetches the top 3 sales per product category:

```sql
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
```

#### Explanation:
- `DENSE_RANK()`:
    - The `DENSE_RANK()` function assigns ranks based on the `amount` in descending order. **ForExample**
The highest amount `(3600.00)` gets rank `1`, 
The next highest amount `(3300.00)` gets rank `2`, 
The third highest amount `(3000.00)` gets rank `3` in `Electronics product category` and the ranking continue in other categories basing on the amount.

- A Common Table Expression (CTE) named `RankedSales` ranks all sales within each product category using `DENSE_RANK()`.
- The `WHERE RS.sales_rank <= 3` clause filters the top 3 sales in each category.
- The query joins with the `EMPLOYEES` table to display employee names.

Ranking Employee Salaries by Department
```sql
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
```
#### Explaination:
1. `RANK()`:
    - Assigns a rank to each employee within their department based on their salary in descending order.
    - If two employees have the same salary, they receive the same rank, but the next rank is skipped (leaving a gap).
2. `DENSE_RANK()`:
    - Similar to `RANK()`, but it does not leave gaps in the ranking sequence when there are ties.
    - Tied employees receive the same rank, and the next rank continues sequentially.
3. `PARTITION BY department`:
    - Ensures that the ranking is calculated separately for each department.
4. `ORDER BY salary DESC`:
    - Ensures that employees are ranked from the highest to the lowest salary within each department.
    
### Task 4: Finding the Earliest Records
This query retrieves the first 2 employees to join each department:

```sql
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
```

#### Explanation:

- A CTE named `RankedEmployees` assigns a row number to each employee within their department, ordered by hire date.
- The `ROW_NUMBER()` function ensures unique sequential numbering.
- The `WHERE date_rank <= 2` clause filters the first 2 employees in each department.

### Task 5: Aggregation with Window Functions
This query calculates the maximum sales amount by category and overall:

```sql
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
```

#### Explanation:

- `MAX(S.amount) OVER (PARTITION BY S.product_category)` calculates the maximum sales amount within each product category.
- `MAX(S.amount) OVER ()` calculates the overall maximum sales amount across all records.
- The empty `OVER ()` clause applies the window function to the entire result set.

