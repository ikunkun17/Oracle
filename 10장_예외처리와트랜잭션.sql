CREATE TABLE ch10_departments
AS
SELECT department_id, department_name
  FROM departments;

ALTER TABLE ch10_departments ADD CONSTRAINTS pk_ch10_departments PRIMARY KEY (department_id);

CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc
( p_dept_id   IN ch10_departments.department_id%TYPE,
  p_dept_name IN ch10_departments.department_name%TYPE,
  p_flag      IN VARCHAR2 )
IS
BEGIN
    IF UPPER(p_flag) = 'I' THEN
        INSERT INTO ch10_departments (department_id, department_name)
        VALUES (p_dept_id, p_dept_name);
    ELSIF UPPER(p_flag) = 'U' THEN
        UPDATE ch10_departments
           SET department_name = p_dept_name
         WHERE department_id = p_dept_id;
    ELSIF UPPER(p_flag) = 'D' THEN
        DELETE FROM ch10_departments
         WHERE department_id = p_dept_id;
    END IF;

    COMMIT;
END;
/

EXEC ch10_iud_dep_proc (10, '총무기획부', 'I');

CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc
( p_dept_id   IN ch10_departments.department_id%TYPE,
  p_dept_name IN ch10_departments.department_name%TYPE,
  p_flag      IN VARCHAR2 )
IS
BEGIN
    IF UPPER(p_flag) = 'I' THEN
        INSERT INTO ch10_departments (department_id, department_name)
        VALUES (p_dept_id, p_dept_name);
    ELSIF UPPER(p_flag) = 'U' THEN
        UPDATE ch10_departments
           SET department_name = p_dept_name
         WHERE department_id = p_dept_id;
    ELSIF UPPER(p_flag) = 'D' THEN
        DELETE FROM ch10_departments
         WHERE department_id = p_dept_id;
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('시스템 예외 발생: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 3번 실행 테스트 (SQL Developer 화면 출력용)
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    ch10_iud_dep_proc(10, '총무기획부', 'I');

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/
PRINT v_out;

CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc
( p_dept_id   IN ch10_departments.department_id%TYPE,
  p_dept_name IN ch10_departments.department_name%TYPE,
  p_flag      IN VARCHAR2 )
IS
    vn_cnt        NUMBER := 0;
    ex_emp_exists EXCEPTION;
BEGIN
    IF UPPER(p_flag) = 'I' THEN
        INSERT INTO ch10_departments (department_id, department_name)
        VALUES (p_dept_id, p_dept_name);
    ELSIF UPPER(p_flag) = 'U' THEN
        UPDATE ch10_departments
           SET department_name = p_dept_name
         WHERE department_id = p_dept_id;
    ELSIF UPPER(p_flag) = 'D' THEN
        SELECT COUNT(*)
          INTO vn_cnt
          FROM employees
         WHERE department_id = p_dept_id;

        IF vn_cnt > 0 THEN
            RAISE ex_emp_exists;
        END IF;

        DELETE FROM ch10_departments
         WHERE department_id = p_dept_id;
    END IF;

    COMMIT;

EXCEPTION
    WHEN ex_emp_exists THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서(' || p_dept_id || ')에 할당된 사원이 있어 삭제할 수 없습니다.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('시스템 예외 발생: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 4번 실행 테스트 (사원이 있는 50번 부서 삭제 시도)
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    ch10_iud_dep_proc(50, NULL, 'D');

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/
PRINT v_out;

CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc
( p_dept_id   IN ch10_departments.department_id%TYPE,
  p_dept_name IN ch10_departments.department_name%TYPE,
  p_flag      IN VARCHAR2 )
IS
    vn_cnt        NUMBER := 0;
    ex_emp_exists EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_emp_exists, -20000);
BEGIN
    IF UPPER(p_flag) = 'I' THEN
        INSERT INTO ch10_departments (department_id, department_name)
        VALUES (p_dept_id, p_dept_name);
    ELSIF UPPER(p_flag) = 'U' THEN
        UPDATE ch10_departments
           SET department_name = p_dept_name
         WHERE department_id = p_dept_id;
    ELSIF UPPER(p_flag) = 'D' THEN
        SELECT COUNT(*)
          INTO vn_cnt
          FROM employees
         WHERE department_id = p_dept_id;

        IF vn_cnt > 0 THEN
            RAISE ex_emp_exists;
        END IF;

        DELETE FROM ch10_departments
         WHERE department_id = p_dept_id;
    END IF;

    COMMIT;

EXCEPTION
    WHEN ex_emp_exists THEN
        DBMS_OUTPUT.PUT_LINE('예외코드(' || SQLCODE || '): 해당 부서에 할당된 사원이 있어 삭제할 수 없습니다.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('시스템 예외 발생: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 5번 실행 테스트
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    ch10_iud_dep_proc(50, NULL, 'D');

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/
PRINT v_out;

CREATE OR REPLACE PROCEDURE ch10_iud_dep_proc
( p_dept_id   IN ch10_departments.department_id%TYPE,
  p_dept_name IN ch10_departments.department_name%TYPE,
  p_flag      IN VARCHAR2 )
IS
    vn_cnt NUMBER := 0;
BEGIN
    IF UPPER(p_flag) = 'I' THEN
        INSERT INTO ch10_departments (department_id, department_name)
        VALUES (p_dept_id, p_dept_name);
    ELSIF UPPER(p_flag) = 'U' THEN
        UPDATE ch10_departments
           SET department_name = p_dept_name
         WHERE department_id = p_dept_id;
    ELSIF UPPER(p_flag) = 'D' THEN
        SELECT COUNT(*)
          INTO vn_cnt
          FROM employees
         WHERE department_id = p_dept_id;

        IF vn_cnt > 0 THEN
            RAISE_APPLICATION_ERROR(-20000, '해당 부서에 할당된 사원이 있어 삭제할 수 없습니다.');
        END IF;

        DELETE FROM ch10_departments
         WHERE department_id = p_dept_id;
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END;
/

-- 6번 실행 테스트
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    ch10_iud_dep_proc(50, NULL, 'D');

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/
PRINT v_out;