CREATE OR REPLACE PROCEDURE my_dep_hier_proc (
    p_parent_id IN departments.parent_id%TYPE DEFAULT NULL,
    p_level     IN NUMBER DEFAULT 1
)
IS
    CURSOR c_dept (cp_parent_id departments.parent_id%TYPE) IS
        SELECT department_id, department_name
          FROM departments
         WHERE (cp_parent_id IS NULL AND parent_id IS NULL)
            OR parent_id = cp_parent_id
         ORDER BY department_id;
BEGIN
    FOR rec IN c_dept(p_parent_id)
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.department_id || ' | ' ||
            LPAD(' ', 3 * (p_level - 1)) || rec.department_name || ' | ' ||
            p_level
        );
        my_dep_hier_proc(rec.department_id, p_level + 1);
    END LOOP;
END;
/

-- 1번 실행 테스트 (SQL Developer 화면 출력용)
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    my_dep_hier_proc;

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
    TYPE emp_email_type IS TABLE OF employees.email%TYPE
        INDEX BY employees.emp_name%TYPE;

    va_emp_email emp_email_type;
    vs_idx       employees.emp_name%TYPE;
    v_line       VARCHAR2(32767);
    v_status     INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);

    FOR rec IN (SELECT emp_name, email FROM employees)
    LOOP
        va_emp_email(rec.emp_name) := rec.email;
    END LOOP;

    vs_idx := va_emp_email.FIRST;
    WHILE vs_idx IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE(vs_idx || ' : ' || va_emp_email(vs_idx));
        vs_idx := va_emp_email.NEXT(vs_idx);
    END LOOP;

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0 OR LENGTH(NVL(:v_out, '')) > 3800;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/

PRINT v_out;


CREATE OR REPLACE TYPE nt_ch11_emp IS TABLE OF VARCHAR2(80);
/

-- 생성 확인용 조회
SELECT type_name, typecode
  FROM user_types
 WHERE type_name = 'NT_CH11_EMP';
 
 

CREATE OR REPLACE PROCEDURE ch11_emp_dept_proc (
    p_dept_id IN departments.department_id%TYPE
)
IS
    TYPE emp_dept_rec IS RECORD (
        employee_id     employees.employee_id%TYPE,
        emp_name        employees.emp_name%TYPE,
        department_name departments.department_name%TYPE
    );

    TYPE emp_dept_nt IS TABLE OF emp_dept_rec;
    vnt_emp_dept emp_dept_nt := emp_dept_nt();
BEGIN
    SELECT a.employee_id,
           a.emp_name,
           b.department_name
      BULK COLLECT INTO vnt_emp_dept
      FROM employees a,
           departments b
     WHERE a.department_id = b.department_id
       AND a.department_id = p_dept_id
     ORDER BY a.employee_id;

    FOR i IN 1..vnt_emp_dept.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            '사원번호: ' || vnt_emp_dept(i).employee_id ||
            ', 사원이름: ' || vnt_emp_dept(i).emp_name ||
            ', 부서이름: ' || vnt_emp_dept(i).department_name
        );
    END LOOP;
END;
/

-- 4번 실행 테스트 (30번 부서 조회)
VAR v_out VARCHAR2(4000);
DECLARE
    v_line   VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.ENABLE(100000);
    ch11_emp_dept_proc(30);

    LOOP
        DBMS_OUTPUT.GET_LINE(v_line, v_status);
        EXIT WHEN v_status != 0;
        :v_out := :v_out || v_line || CHR(10);
    END LOOP;
END;
/
PRINT v_out;