SPOOL C:\BD2\Project3Q3.txt
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS') FROM dual;

-- Question 3

CREATE OR REPLACE FUNCTION find_age(date1 IN DATE)
	RETURN NUMBER AS
		age NUMBER;
	BEGIN
		age := FLOOR((SYSDATE - TO_DATE(date1))/365.25);
	RETURN age;
END;
/

SELECT find_age('28-07-99') FROM dual;

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE p3question3(st_id IN NUMBER) AS
  s_name VARCHAR2(40);
  s_birth DATE;
  s_age NUMBER(8,2);

BEGIN
  SELECT s_first || ' ' || s_last, s_dob, find_age(s_dob)
  INTO   s_name, s_birth, s_age
  FROM   student
  WHERE s_id = st_id;
  
  DBMS_OUTPUT.PUT_LINE('The student number '|| st_id || ' is ' || s_name ||
  ', the birthday is '|| s_birth ||', the age is ' || s_age);
  
EXCEPTION
   WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('Student number '|| st_id ||
           ' does not exist!'); 
   WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Something is wrong, try again!');
END;
/
EXEC p3question3(1)
EXEC p3question3(2)
EXEC p3question3(3)

SPOOL OFF;