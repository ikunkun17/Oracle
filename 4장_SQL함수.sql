SELECT employee_id,
       emp_name,
       phone_number AS 기존번호,
       LPAD(SUBSTR(phone_number, 4), 13, '(02)') AS 변경번호
  FROM employees
 ORDER BY employee_id;
 
SELECT employee_id AS 사원번호,
       emp_name AS 사원명,
       hire_date AS 입사일자,
       TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS 근속년수
  FROM employees
 WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) >= 10
 ORDER BY 근속년수 DESC;
 

SELECT cust_id,
       cust_name,
       cust_main_phone_number AS 기존번호,
       REPLACE(cust_main_phone_number, '-', '/') AS 변경번호
  FROM customers;
  
SELECT cust_id,
       cust_name,
       cust_main_phone_number AS 기존번호,
       TRANSLATE(cust_main_phone_number, '0123456789-', 'ABCDEFGHIJK') AS 암호화번호
  FROM customers;

SELECT cust_id,
       cust_name,
       cust_year_of_birth,
       DECODE(TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10),
              3, '30대',
              4, '40대',
              5, '50대',
              '기타') AS 연령대
  FROM customers;
  
SELECT cust_id,
       cust_name,
       cust_year_of_birth,
       CASE WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) < 1  THEN '10대 미만'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 1  THEN '10대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 2  THEN '20대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 3  THEN '30대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 4  THEN '40대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 5  THEN '50대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 6  THEN '60대'
            WHEN TRUNC((TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - cust_year_of_birth) / 10) = 7  THEN '70대'
            ELSE '80대 이상'
       END AS 연령대
  FROM customers;