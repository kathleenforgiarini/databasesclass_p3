SPOOL C:\BD2\Project3Q4.txt
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS') FROM dual;

-- Question 4
SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION find_c_sk_cert (in_c_id IN NUMBER, in_s_id IN NUMBER, in_cert IN VARCHAR2)
	RETURN NUMBER AS
    exists_c_sk_cert NUMBER;
	temp_c_id NUMBER;
	temp_s_id NUMBER;
	temp_cert VARCHAR2(5);

	BEGIN
		SELECT c_id, skill_id, certification
		INTO temp_c_id, temp_s_id, temp_cert
		FROM consultant_skill
		WHERE c_id = in_c_id AND skill_id = in_s_id AND certification = in_cert;

		exists_c_sk_cert := 1;

		RETURN exists_c_sk_cert;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		exists_c_sk_cert := 0;
		RETURN exists_c_sk_cert;
	END;
/

CREATE OR REPLACE FUNCTION find_c_sk (in_c_id IN NUMBER, in_s_id IN NUMBER)
	RETURN NUMBER AS
    exists_c_sk NUMBER;
	temp_c_id NUMBER;
	temp_s_id VARCHAR2(40);

	BEGIN
		SELECT c_id, skill_id
		INTO temp_c_id, temp_s_id
		FROM consultant_skill
		WHERE skill_id = in_s_id AND c_id = in_c_id;

		exists_c_sk := 1;

		RETURN exists_c_sk;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		exists_c_sk := 0;
		RETURN exists_c_sk;

	END;
/


CREATE OR REPLACE FUNCTION find_sk (in_s_id IN NUMBER)
	RETURN NUMBER AS
    exists_sk NUMBER;
	temp_s_id NUMBER;

	BEGIN
		SELECT skill_id
		INTO temp_s_id
		FROM skill
		WHERE skill_id = in_s_id;

		exists_sk := 1;
		RETURN exists_sk;

		EXCEPTION
		WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Skill ' || in_s_id || ' do not exist.');
		exists_sk := 0;
		RETURN exists_sk;

	END;
/


CREATE OR REPLACE FUNCTION print (in_c_id IN NUMBER, in_skill_id IN NUMBER, in_certification IN VARCHAR2)
	RETURN NUMBER AS
		print NUMBER;
		t_c_last VARCHAR2(40);
		t_c_first VARCHAR2(40);
		t_skill_description VARCHAR2(40);
		t_certification VARCHAR2(40);

		BEGIN

		SELECT c_last, c_first, skill_description, certification
		INTO t_c_last, t_c_first, t_skill_description, t_certification
		FROM consultant c, consultant_skill cs, skill s
		WHERE in_c_id = c.c_id AND in_skill_id = s.skill_id AND c.c_id = cs.c_id AND 
		certification = in_certification AND cs.skill_id = s.skill_id;

		DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || t_c_first || '.');
		DBMS_OUTPUT.PUT_LINE('Consultant last name: ' ||t_c_last|| '.');
		DBMS_OUTPUT.PUT_LINE('Skill Description: ' ||t_skill_description|| '.');
		DBMS_OUTPUT.PUT_LINE('Certification: '|| t_certification || '.');

		RETURN null;

		END;
/


CREATE OR REPLACE PROCEDURE p3question4 (in_c_id IN NUMBER, in_skill_id IN NUMBER, in_certification IN VARCHAR2) AS

	tst_1 NUMBER;
	tst_2 NUMBER;
	tst_3 NUMBER;
	prt NUMBER;

	BEGIN

		tst_1 := find_c_sk_cert(in_c_id, in_skill_id, in_certification);		 		

		IF tst_1 = 1 THEN
			prt := print(in_c_id,in_skill_id,in_certification);

		ELSIF tst_1 = 0 THEN
			tst_2 := find_c_sk(in_c_id, in_skill_id);

			IF tst_2 = 1 THEN
				UPDATE consultant_skill SET certification = in_certification
				WHERE c_id = in_c_id AND skill_id = in_skill_id;
				COMMIT;
				prt := print(in_c_id,in_skill_id,in_certification);

			ELSIF tst_2 = 0 THEN
				tst_3 := find_sk(in_skill_id);

				IF tst_3 = 1 THEN
					INSERT INTO consultant_skill(c_id,skill_id,certification)
					VALUES (in_c_id,in_skill_id,in_certification);
					COMMIT;
					prt := print(in_c_id,in_skill_id,in_certification);

					ELSIF tst_3 = 0 THEN
					DBMS_OUTPUT.PUT_LINE('Try again.');
				END IF;
			END IF;
		END IF;
	
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Consultant number ' || in_c_id || ' do not exist.');
	DBMS_OUTPUT.PUT_LINE('Try again.');

	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('There is something wrong.');
	DBMS_OUTPUT.PUT_LINE('Try again.');
	
	END;
/


EXEC p3question4(100,1,'N')
EXEC p3question4(100,1,'Y')
EXEC p3question4(100,100,'N')

SPOOL OFF;
