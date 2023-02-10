SPOOL C:\BD2\Project3Q1.txt
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS') FROM dual;

-- Question 1

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE p3question1(empnumber IN NUMBER) AS
  dname VARCHAR2(40);
  e_name VARCHAR2(40);
  esal NUMBER(8,2);
  ecomm NUMBER (8,2);
  esaltotal NUMBER (8,2);
BEGIN
  SELECT ename, dept.dname, sal*12, comm
  INTO   e_name, dname, esal, ecomm
  FROM   emp, dept
  WHERE  empno = empnumber 
  AND emp.deptno = dept.deptno;
  
  IF (ecomm <> 0) THEN
    esaltotal := esal + ecomm;

  ELSE 
  esaltotal := esal;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Employee number '|| empnumber || ' is ' || e_name ||
  '. He/she works in the department '|| dname ||', earning $' || esaltotal || ' a year.');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('Employee number '|| empnumber ||
           ' does not exist!'); 
   WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Something is wrong, try again!');
END;
/
EXEC p3question1(788)
EXEC p3question1(7788)
EXEC p3question1(7499)

SPOOL OFF;