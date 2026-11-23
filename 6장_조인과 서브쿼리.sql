SELECT a.employee_id AS 사번,
       a.emp_name AS 사원명,
       c.job_title AS job명칭,
       b.start_date AS job시작일자,
       b.end_date AS job종료일자,
       d.department_name AS job수행부서명
  FROM employees a,
       job_history b,
       jobs c,
       departments d
 WHERE a.employee_id = b.employee_id
   AND b.job_id = c.job_id
   AND b.department_id = d.department_id
   AND a.employee_id = 101;
   
SELECT a.department_id, a.department_name
  FROM departments a
 INNER JOIN employees b
    ON (a.department_id = b.department_id)
 WHERE b.salary > 3000
 ORDER BY a.department_name;
 
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE a.department_id IN ( SELECT b.department_id
                              FROM job_history b );
                              
SELECT sale.years AS 연도,
       sale.max_sold AS 최대매출액,
       d1.emp_name AS 최대매출사원,
       sale.min_sold AS 최소매출액,
       d2.emp_name AS 최소매출사원
  FROM ( SELECT years,
                MAX(amount_sold) AS max_sold,
                MIN(amount_sold) AS min_sold
           FROM ( SELECT SUBSTR(a.sales_month, 1, 4) AS years,
                         a.employee_id,
                         SUM(a.amount_sold) AS amount_sold
                    FROM sales a,
                         customers b,
                         countries c
                   WHERE a.cust_id = b.cust_id
                     AND b.country_id = c.country_id
                     AND c.country_name = 'Italy'
                   GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id )
          GROUP BY years ) sale,
       ( SELECT SUBSTR(a.sales_month, 1, 4) AS years,
                a.employee_id,
                SUM(a.amount_sold) AS amount_sold
           FROM sales a,
                customers b,
                countries c
          WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND c.country_name = 'Italy'
          GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id ) emp1,
       ( SELECT SUBSTR(a.sales_month, 1, 4) AS years,
                a.employee_id,
                SUM(a.amount_sold) AS amount_sold
           FROM sales a,
                customers b,
                countries c
          WHERE a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND c.country_name = 'Italy'
          GROUP BY SUBSTR(a.sales_month, 1, 4), a.employee_id ) emp2,
       employees d1,
       employees d2
 WHERE sale.years = emp1.years
   AND sale.max_sold = emp1.amount_sold
   AND emp1.employee_id = d1.employee_id
   AND sale.years = emp2.years
   AND sale.min_sold = emp2.amount_sold
   AND emp2.employee_id = d2.employee_id
 ORDER BY sale.years;