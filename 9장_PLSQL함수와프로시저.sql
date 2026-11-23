DECLARE
    vn_base_num NUMBER := 3;
BEGIN
    FOR i IN REVERSE 9..1
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || '*' || i || '= ' || vn_base_num * i);
    END LOOP;
END;
/

CREATE OR REPLACE FUNCTION my_initcap (ps_string VARCHAR2)
    RETURN VARCHAR2
IS
    vs_temp   VARCHAR2(1000) := LOWER(ps_string);
    vs_result VARCHAR2(1000) := '';
BEGIN
    IF ps_string IS NULL THEN
        RETURN NULL;
    END IF;

    FOR i IN 1..LENGTH(ps_string)
    LOOP
        IF i = 1 OR SUBSTR(vs_temp, i - 1, 1) = ' ' THEN
            vs_result := vs_result || UPPER(SUBSTR(vs_temp, i, 1));
        ELSE
            vs_result := vs_result || SUBSTR(vs_temp, i, 1);
        END IF;
    END LOOP;

    RETURN vs_result;
END;
/

SELECT my_initcap('hello WORLD oracle sql') AS 결과 FROM DUAL;

CREATE OR REPLACE FUNCTION my_last_day (ps_date VARCHAR2)
    RETURN VARCHAR2
IS
    vd_date DATE;
BEGIN
    vd_date := TO_DATE(REPLACE(ps_date, '-', ''), 'YYYYMMDD');
    RETURN TO_CHAR(LAST_DAY(vd_date), 'YYYY-MM-DD');
END;
/

-- 실행 테스트
SELECT my_last_day('2026-02-15') AS 결과1,
       my_last_day('20261123')   AS 결과2
  FROM DUAL;
  
CREATE TABLE ch09_dept (
    DEPARTMENT_ID   NUMBER,
    DEPARTMENT_NAME VARCHAR2(100),
    LEVELS          NUMBER
);

CREATE OR REPLACE PROCEDURE my_hier_dept_proc
IS
BEGIN
    DELETE FROM ch09_dept;

    INSERT INTO ch09_dept (department_id, department_name, levels)
    SELECT department_id,
           LPAD(' ', 3 * (LEVEL - 1)) || department_name,
           LEVEL
      FROM departments
     START WITH parent_id IS NULL
   CONNECT BY PRIOR department_id = parent_id;

    COMMIT;
END;
/

EXEC my_hier_dept_proc;
SELECT * FROM ch09_dept;

CREATE OR REPLACE PROCEDURE my_new_job_proc2
( p_job_id    IN JOBS.JOB_ID%TYPE,
  p_job_title IN JOBS.JOB_TITLE%TYPE,
  p_min_sal   IN JOBS.MIN_SALARY%TYPE,
  p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
BEGIN
    MERGE INTO jobs a
    USING ( SELECT p_job_id AS job_id FROM DUAL ) b
       ON ( a.job_id = b.job_id )
     WHEN MATCHED THEN
          UPDATE SET a.job_title   = p_job_title,
                     a.min_salary  = p_min_sal,
                     a.max_salary  = p_max_sal,
                     a.update_date = SYSDATE
     WHEN NOT MATCHED THEN
          INSERT ( a.job_id, a.job_title, a.min_salary, a.max_salary, a.create_date, a.update_date )
          VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE );

    COMMIT;
END;
/

EXEC my_new_job_proc2('SM_JOB1', 'Sample Job 1', 1000, 5000);
SELECT * FROM jobs WHERE job_id = 'SM_JOB1';

CREATE TABLE ch09_departments AS
SELECT DEPARTMENT_ID, DEPARTMENT_NAME, PARENT_ID
  FROM DEPARTMENTS;

CREATE OR REPLACE PROCEDURE my_dept_manage_proc
( p_dept_id   IN ch09_departments.department_id%TYPE,
  p_dept_name IN ch09_departments.department_name%TYPE,
  p_parent_id IN ch09_departments.parent_id%TYPE,
  p_flag      IN VARCHAR2 )
IS
    vn_emp_cnt NUMBER := 0;
BEGIN
    IF LOWER(p_flag) = 'upsert' THEN
        MERGE INTO ch09_departments a
        USING ( SELECT p_dept_id AS department_id FROM DUAL ) b
           ON ( a.department_id = b.department_id )
         WHEN MATCHED THEN
              UPDATE SET a.department_name = p_dept_name,
                         a.parent_id       = p_parent_id
         WHEN NOT MATCHED THEN
              INSERT ( a.department_id, a.department_name, a.parent_id )
              VALUES ( p_dept_id, p_dept_name, p_parent_id );

        COMMIT;

    ELSIF LOWER(p_flag) = 'delete' THEN
        SELECT COUNT(*)
          INTO vn_emp_cnt
          FROM employees
         WHERE department_id = p_dept_id;

        IF vn_emp_cnt > 0 THEN
            DBMS_OUTPUT.PUT_LINE('경고: 해당 부서(' || p_dept_id || ')에 소속된 사원이 ' || vn_emp_cnt || '명 존재하여 삭제할 수 없습니다.');
            RETURN;
        END IF;

        DELETE FROM ch09_departments
         WHERE department_id = p_dept_id;

        COMMIT;
    END IF;
END;
/

VAR v_out VARCHAR2(4000);

DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);

    -- 1) 신규 부서 999 upsert
    my_dept_manage_proc(999, '신규테스트부', 10, 'upsert');

    -- 2) 사원이 존재하는 50번 부서 delete 시도 (경고 메시지 발생)
    my_dept_manage_proc(50, NULL, NULL, 'delete');

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/

PRINT v_out;
SELECT * FROM ch09_departments WHERE department_id IN (50, 999);