SPOOL C:\BD2\Project3Q2.txt
SELECT to_char(sysdate, 'DD Month YYYY Day HH:MI:SS') FROM dual;

-- Question 2

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE p3question2(inv IN NUMBER) AS
  i_desc VARCHAR2(40);
  iv_price NUMBER(8,2);
  iv_color VARCHAR2(40);
  iv_qoh NUMBER (8,2);
  iv_value NUMBER (8,2);

BEGIN
  SELECT i.item_desc, iv.inv_price, iv.color, iv.inv_qoh, iv.inv_price*iv.inv_qoh
  INTO   i_desc, iv_price, iv_color, iv_qoh, iv_value
  FROM   inventory iv, item i
  WHERE iv.inv_id = inv
  AND i.item_id = iv.item_id;
  
  DBMS_OUTPUT.PUT_LINE('The inventory number '|| inv || ' has the item ' || i_desc ||
  ', the price is $'|| iv_price ||', the color is ' || iv_color || ', the quantity 
  on hand is ' || iv_qoh || ' and the value is $' || iv_value);
  
EXCEPTION
   WHEN NO_DATA_FOUND THEN
 DBMS_OUTPUT.PUT_LINE('Inventory number '|| inv ||
           ' does not exist!'); 
   WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Something is wrong, try again!');
END;
/
EXEC p3question2(1)
EXEC p3question2(2)
EXEC p3question2(3)

SPOOL OFF;
