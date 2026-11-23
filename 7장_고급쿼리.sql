SELECT department_id,
       SUBSTR(SYS_CONNECT_BY_PATH(emp_name, ','), 2) AS empnames
  FROM ( SELECT department_id,
                emp_name,
                ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY emp_name) AS rnum,
                COUNT(*) OVER (PARTITION BY department_id) AS cnt
           FROM employees
          WHERE department_id IS NOT NULL )
 WHERE rnum = cnt
 START WITH rnum = 1
CONNECT BY PRIOR department_id = department_id
       AND PRIOR rnum = rnum - 1
 ORDER BY department_id;
 
SELECT employee_id,
       emp_name,
       hire_date,
       LEAD(hire_date, 1) OVER (ORDER BY hire_date) AS retire_date
  FROM employees
 WHERE job_id = 'SH_CLERK'
 ORDER BY hire_date;

WITH basis AS (
    SELECT TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - b.cust_year_of_birth) / 10) * 10 AS age_band,
           a.amount_sold
      FROM sales a,
           customers b
     WHERE a.cust_id = b.cust_id
       AND a.sales_month = '200112'
)
SELECT age_band || '대' AS 연령대,
       SUM(amount_sold) AS 매출금액
  FROM basis
 GROUP BY age_band
 ORDER BY age_band;
 
WITH basis AS (
    SELECT a.sales_month,
           c.country_region,
           SUM(a.amount_sold) AS amt
      FROM sales a,
           customers b,
           countries c
     WHERE a.cust_id = b.cust_id
       AND b.country_id = c.country_id
     GROUP BY a.sales_month, c.country_region
),
ranked AS (
    SELECT sales_month,
           country_region,
           amt,
           ROW_NUMBER() OVER (PARTITION BY sales_month ORDER BY amt ASC) AS rnum
      FROM basis
)
SELECT sales_month AS 매출월,
       country_region AS "지역(대륙)",
       amt AS 매출금액
  FROM ranked
 WHERE rnum = 1
 ORDER BY sales_month;
 
WITH basis AS (
    SELECT region,
           gubun,
           SUM(CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END) AS amt_201111,
           SUM(CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END) AS amt_201112,
           SUM(CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END) AS amt_201210,
           SUM(CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END) AS amt_201211,
           SUM(CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END) AS amt_201212,
           SUM(CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END) AS amt_201310,
           SUM(CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END) AS amt_201311
      FROM kor_loan_status
     GROUP BY region, gubun
)
SELECT region AS 지역,
       gubun AS 대출종류,
       amt_201111 || '( ' || NVL(ROUND(amt_201111 / NULLIF(SUM(amt_201111) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201111",
       amt_201112 || '( ' || NVL(ROUND(amt_201112 / NULLIF(SUM(amt_201112) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201112",
       amt_201210 || '( ' || NVL(ROUND(amt_201210 / NULLIF(SUM(amt_201210) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201210",
       amt_201211 || '( ' || NVL(ROUND(amt_201211 / NULLIF(SUM(amt_201211) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201211",
       amt_201212 || '( ' || NVL(ROUND(amt_201212 / NULLIF(SUM(amt_201212) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201212",
       amt_201310 || '( ' || NVL(ROUND(amt_201310 / NULLIF(SUM(amt_201310) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201310",
       amt_201311 || '( ' || NVL(ROUND(amt_201311 / NULLIF(SUM(amt_201311) OVER (PARTITION BY region), 0) * 100), 0) || '% )' AS "201311"
  FROM basis
 ORDER BY region, gubun;