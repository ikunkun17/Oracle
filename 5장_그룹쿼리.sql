SELECT TO_CHAR(hire_date, 'YYYY') AS 입사년도,
       COUNT(*) AS 사원수
  FROM employees
 GROUP BY TO_CHAR(hire_date, 'YYYY')
 ORDER BY 입사년도;
 
SELECT period AS 월,
       region AS 지역,
       SUM(loan_jan_amt) AS 대출총잔액
  FROM kor_loan_status
 WHERE period LIKE '2012%'
 GROUP BY period, region
 ORDER BY period, region;
 
SELECT period, gubun, SUM(loan_jan_amt) AS totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%'
 GROUP BY period, gubun
UNION
SELECT period, NULL, SUM(loan_jan_amt) AS totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%'
 GROUP BY period;
 
SELECT period,
       SUM(loan_jan_amt) AS 주택담보대출액,
       0 AS 기타대출액
  FROM kor_loan_status
 WHERE period = '201311'
   AND gubun = '주택담보대출'
 GROUP BY period
UNION ALL
SELECT period,
       0 AS 주택담보대출액,
       SUM(loan_jan_amt) AS 기타대출액
  FROM kor_loan_status
 WHERE period = '201311'
   AND gubun = '기타대출'
 GROUP BY period;
 
SELECT region AS 지역,
       SUM(CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END) AS "201111",
       SUM(CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END) AS "201112",
       SUM(CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END) AS "201210",
       SUM(CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END) AS "201211",
       SUM(CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END) AS "201212",
       SUM(CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END) AS "201310",
       SUM(CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END) AS "201311"
  FROM kor_loan_status
 GROUP BY region
 ORDER BY region;