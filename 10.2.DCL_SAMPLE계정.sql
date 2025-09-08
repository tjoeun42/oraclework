create table test (
    test_id number,
    test_name varchar2(20)
);
insert into test values(1, '이하늘');

----------------------------------------------------------------------
SELECT *
FROM TJOEUN.EMPLOYEE;

INSERT INTO TJOEUN.DEPARTMENT
VALUES('D0','회계부','L2');
COMMIT;

SELECT *
FROM TJOEUN.DEPARTMENT;