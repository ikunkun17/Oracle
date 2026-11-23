SET SERVEROUTPUT ON SIZE 100000;

VAR v_out VARCHAR2(4000);

DECLARE
    vn_base_num NUMBER := 3;
    v_line      VARCHAR2(32767);
    v_status    INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    FOR i IN 1..9
    LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base_num || ' * ' || i || ' = ' || vn_base_num * i);
    END LOOP;

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/

PRINT v_out;

    VAR v_out VARCHAR2(4000);
    
    DECLARE
        vs_emp_name employees.emp_name%TYPE;
        vs_email    employees.email%TYPE;
        v_line      VARCHAR2(32767);
        v_status    INTEGER;
    BEGIN
        DBMS_OUTPUT.ENABLE(100000);
    
        SELECT emp_name, email
          INTO vs_emp_name, vs_email
          FROM employees
         WHERE employee_id = 201;
    
        DBMS_OUTPUT.PUT_LINE('사원명: ' || vs_emp_name || ', 이메일: ' || vs_email);
    
        LOOP
            DBMS_OUTPUT.GET_LINE(v_line, v_status);
            EXIT WHEN v_status != 0;
            :v_out := :v_out || v_line || CHR(10);
        END LOOP;
    END;
    /
    
    PRINT v_out;
    
VAR v_out VARCHAR2(4000);

DECLARE
    vn_max_emp_id employees.employee_id%TYPE;
    v_line        VARCHAR2(32767);
    v_status      INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);

    SELECT MAX(employee_id)
      INTO vn_max_emp_id
      FROM employees;

    INSERT INTO employees (employee_id, emp_name, email, hire_date, department_id)
    VALUES (vn_max_emp_id + 1, 'Harrison Ford', 'HARRIS', SYSDATE, 50);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('신규 등록 사원번호: ' || (vn_max_emp_id + 1));

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/

PRINT v_out;

SELECT employee_id, emp_name, email, hire_date, department_id
  FROM employees
 WHERE emp_name = 'Harrison Ford';