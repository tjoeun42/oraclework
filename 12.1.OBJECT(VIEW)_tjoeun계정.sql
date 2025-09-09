/*
    < VIEW >
    SELECT문을 저장해둘 수 있는 객체
    (자주 쓰는 긴 SELECT문을 저장해두면 매번 긴 SELECT문을 다시 기술할 필요 없음)
    임시테이블 같은 존재(실제 데이터가 담겨있는거 아님 => 논리적인 테이블)
*/
-- '한국'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '한국'; 
  
-- '러시아'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회  
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '러시아';   

-- '일본'에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '일본';    
  
--------------------------------------------------------------------------------
/*
    1. VIEW 생성 방법
    
    [표현법]
    CREATE VIEW 뷰명
    AS 서브쿼리;
*/
CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING (NATIONAL_CODE);

-- == 아래와 같은 맥락
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
         FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
         JOIN NATIONAL USING (NATIONAL_CODE));

-- 한국, 러시아, 일본에서 근무하는 사원
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '한국';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '러시아';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';
 
--------------------------------------------------------------------------------
/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어있는 경우에는 반드시 별칭 부여
*/
-- 전 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수를 조회할 수 있는 SELECT문을 뷰(VW_EMP_JOB)로 정의
-- CREATE OR REPLACE VIEW 뷰명  => 같은 이름 뷰가 존재하면 뷰를 갱신(덮어쓰기), 뷰가 없으면 생성
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
-- 오류 : 열의 별명과 함께 지정해야 합니다 

CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여') 성별,
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
 
-- 아래와 같은 방식으로도 별칭 부여 가능 
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 사원명, 직급명, 성별, 근무년수) 
AS SELECT EMP_ID, EMP_NAME, JOB_NAME,
          DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);
     
-- 여성 사원의 사원명, 직급명 조회
SELECT 사원명, 직급명
  FROM VW_EMP_JOB
 WHERE 성별 = '여';
 
-- 근무년수가 20년 이상인 사원의 모든 컬럼 조회
SELECT *
  FROM VW_EMP_JOB
 WHERE 근무년수 >= 20; 
 
--------------------------------------------------------------------------------
/*
    * 뷰 삭제
      DROP VIEW 뷰명;
*/

DROP VIEW VW_EMP_JOB; 

--------------------------------------------------------------------------------
/*
    * VIEW에서 DML사용가능
      생성된 뷰를 이용하여 DML(INSERT, UPDATE, DELETE)사용가능
      뷰를 통해서 조작하게 되면 실제 데이터가 담겨있는 테이블에 반영됨
*/
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
     FROM JOB;
     
-- 뷰를 통해서 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴');
COMMIT;

-- 뷰를 통해서 UPDATE
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 뷰를 통해서 DELETE
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J8';
