# ASSIGNMENT: Exploring SQL Window Functions _ Tasks & Queries
# COURSE: Database Development with PL/SQL
# GROUP: LEGACY FUNCTION FOUNDERS
## Members: 
- GUHIRWA Christian [26750]  
- ISHIME Emmanuel [26424]

## Lecture: MANIRAGUHA Eric

---

## Step 1: Set Up the Database Schema

### Create Tables
The following SQL statements create the necessary tables for the assignment:

Salaes Region Table
![alt text](/img/Sales-Regions_Table.png)

Employees Table
![alt text](/img/Employees_Table.png)

Sales Table
![alt text](/img/Sales_Table.png)

### Insert Data
The following SQL statements populate the tables with sample data:

Insert data into SALES_REGIONS

![alt text](/img/Sales_Data.png)


Insert data into EMPLOYEES

![alt text](/img/Employees_Data.png)


Insert data into SALES
![alt text](/img/Sales_Data.png)

## Step 2: Complete the Window Functions Tasks
### Task 1: Compare Values with Previous or Next Records
-- This query compares employee salaries with the previous and next records within the same department:
![alt text](/img/Task1.png)

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
-- This query ranks employees within each department by salary:
![alt text](/img/Task2.png)

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
-- This query fetches the top 3 sales per product category:
![alt text](/img/Task3.png)

#### Explanation:
- `DENSE_RANK()`:
    - The `DENSE_RANK()` function assigns ranks based on the `amount` in descending order. **ForExample**
The highest amount `(3600.00)` gets rank `1`, 
The next highest amount `(3300.00)` gets rank `2`, 
The third highest amount `(3000.00)` gets rank `3` in `Electronics product category` and the ranking continue in other categories basing on the amount.

- A Common Table Expression (CTE) named `RankedSales` ranks all sales within each product category using `DENSE_RANK()`.
- The `WHERE RS.sales_rank <= 3` clause filters the top 3 sales in each category.
- The query joins with the `EMPLOYEES` table to display employee names.

-- Ranking Employee Salaries by Department
![alt text](/img/Task3%20cont.png)

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
-- This query retrieves the first 2 employees to join each department:
![alt text](/img/Task4.png)

#### Explanation:

- A CTE named `RankedEmployees` assigns a row number to each employee within their department, ordered by hire date.
- The `ROW_NUMBER()` function ensures unique sequential numbering.
- The `WHERE date_rank <= 2` clause filters the first 2 employees in each department.

### Task 5: Aggregation with Window Functions
-- This query calculates the maximum sales amount by category and overall:
![alt text](/img/Task5.png)

#### Explanation:

- `MAX(S.amount) OVER (PARTITION BY S.product_category)` calculates the maximum sales amount within each product category.
- `MAX(S.amount) OVER ()` calculates the overall maximum sales amount across all records.
- The empty `OVER ()` clause applies the window function to the entire result set.


