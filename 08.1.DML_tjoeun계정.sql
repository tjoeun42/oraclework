/*
    * DML(DATA MAINPULATION LANGUAGE) : 데이터 조작언어
      테이블의 값을 검색(SELECT), 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
*/
--==============================================================================
/*
    1. INSERT
       테이블에 새로운 행을 추가하는 구문
       
       [표현식]
       1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3 ...);
          테이블에 모든 컬럼에 대한 값을 직접 넣어 한 행을 넣고자 할 때 사용
          컬럼 순서를 지켜 VALUES에 값을 나열해야 됨
          
          부족하게 값을 넣었을 때 => NOT ENOUGH VALUE 오류
          값을 더 많이 넣었을 떼 => TOO MANY VALUES 오류
*/
INSERT INTO EMPLOYEE VALUES(300, '이하늘', '020412-1234567', 'lee@google.com',
                        '01048393745', 'D2', 'J5', 3500000, 0.15, 200, sysdate,
                        null, default);

--------------------------------------------------------------------------------
/*
        2) INSERT INTO 테이블명(컬럼명, 컬럼명, ..) VALUES(값, 값, ..)
           테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 사용
           그래도 한 행단위로 추가되기 때문에 선택이 안된 컬럼은 기본적으로 NULL이 들어감
           단, 기본값(DEFAULT)가 지정되어 있으면 NULL아닌 기본값이 들어감
           => NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 데이터를 넣어줘야 됨
*/
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE) 
               VALUES(301, '최다니엘', '961125-2134768', 'J3', SYSDATE);
               
INSERT 
  INTO EMPLOYEE
        (
           EMP_ID
         , EMP_NAME
         , EMP_NO
         , JOB_CODE
         , HIRE_DATE
        )
 VALUES
        (
           302
         , '강이찬'
         , '970513-2637465'
         , 'J5'
         , SYSDATE
        );

--------------------------------------------------------------------------------
/*
        3) INSERT INTO 테이블명 (서버쿼리);
           VALUES로 값을 직접 명시하는 대신 서브쿼리로 
           조회된 결과값을 모두 INSERT함(여러행 INSERT가능)
*/
-- 테이블 생성
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(35)
);

-- 전체 사원들의 사번, 이름, 부서명을 조회하여 EMP_01테이블에 넣기
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

INSERT INTO EMP_01
    (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
       FROM EMPLOYEE
       LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));

--------------------------------------------------------------------------------
/*
        4) INSERT ALL
           두개 이상의 테이블에 각각 INSERT할 때
           이때 사용되는 서브쿼리가 동일한 경우
           
           [표현식]
           INSERT ALL
           INTO 테이블명1 VALUES(컬럼명, 컬럼명,...)
           INTO 테이블명2 VALUES(컬럼명, 컬럼명,...)
              서브쿼리;
*/
-- 테스트할 테이블 2개 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
     FROM EMPLOYEE
    WHERE 1=0; 

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
     FROM EMPLOYEE
    WHERE 1=0; 

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수번호 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D1';
 
INSERT ALL
  INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
  INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
          FROM EMPLOYEE
         WHERE DEPT_CODE = 'D1';

--------------------------------------------------------------------------------
/*
        5) 조건을 사용하여 INSERT 가능
        
        [표현식]
        INSERT ALL
        WHEN 조건1 THEN
            INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
        WHEN 조건2 THEN
            INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
        서브쿼리;    
*/
-- 2000년도 이전에 입사한 직원들을 담을 테이블 생성
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
     FROM EMPLOYEE
    WHERE 1=0;

-- 2000년도 이후에 입사한 직원들을 담을 테이블 생성
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
     FROM EMPLOYEE
    WHERE 1=0;

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)    
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
  FROM EMPLOYEE;
  
--==============================================================================
/*
    2. UPDATE
       테이블에 기록되어 있는 기존의 데이터를 수정하는 구문
       
       [표현식]
       UPDATE 테이블명
       SET 컬럼명 = 바꿀값,
           컬럼명 = 바꿀값,
           ...
       [WHERE 조건];   --> 주의 : 조건을 생략하면 전체 모든 행의 데이터가 변경됨.    
*/
-- DEPARTMENT테이블 복사본 만들기(데이터까지)
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9 부서의 부서명을 '전략기획팀'으로 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';
-- 전체 데이터가 모두 변경됨

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- EMPLOYEE테이블의 컬럼 EMP_ID, EMP_NAME, SALARY, BOUNS으로 복사본 만들기
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
     FROM EMPLOYEE;

-- 박정보 사원의 급여를 4백만원으로 변경
UPDATE EMP_SALARY
SET SALARY = 4000000
WHERE EMP_NAME = '박정보';

-- 김정보 사원의 급여를 7백만원으로, 보너스를 0.2로 변경
UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '김정보';    

-- 전체 사원의 급여를 기존급여에 10%인상한 금액으로 변경
UPDATE EMP_SALARY
SET SALARY = SALARY * 1.1;

------------------------------------------------------------------------
/*
    * UPDATE시 서브쿼리 사용 가능
      UPDATE 테이블명
      SET 컬럼명 = (서브쿼리)
      WHERE 조건;
*/
-- 왕정보 사원의 급여와 보너스를 장정보 사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
                FROM EMP_SALARY
               WHERE EMP_NAME = '장정보'  
              ),
    BONUS = (SELECT BONUS
                FROM EMP_SALARY
               WHERE EMP_NAME = '장정보'  
             )
WHERE EMP_NAME = '왕정보';

-- 다중열 서브쿼리로도 가능
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                         FROM EMP_SALARY
                        WHERE EMP_NAME = '장정보'  
                       )
WHERE EMP_NAME = '왕정보';

-- 홍정보, 최하보, 문정보, 이하늘, 강정보 사원의 급여와 보너스를 유하보의 급여와 보너스가 같도록 변경
UPDATE EMP_SALARY
SET(SALARY, BONUS) = (SELECT SALARY, BONUS
                        FROM EMP_SALARY
                       WHERE EMP_NAME = '유하보')
WHERE EMP_NAME IN ('홍정보', '최하보', '문정보', '이하늘', '강정보');

-- ASIA 지역에서 근무하는 사원들의 보너스를 0.3으로 변경하기
SELECT EMP_ID
  FROM EMP_SALARY
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
 WHERE LOCAL_NAME LIKE 'ASIA%'; 
 
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                  FROM EMP_SALARY
                  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');

-------------------------------------------------------------------------
-- UPDATE시에도 제약조건에 위배되면 안됨
-- 사번이 200번인 사원의 이름을 NULL
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200;     --> NOT NULL 위배

-- DEPARTMENT테이블의 DEPT_ID가 D9인 부서의 LOCAITON_ID를 L7 변경
UPDATE DEPARTMENT
SET LOCATION_ID = 'L7'
WHERE DEPT_ID = 'D9';      --> FOREIGN KEY 위배

COMMIT;
--==============================================================================
/*
    3. DELETE
       테이블에 기록된 데이터를 삭제하는 구문 (행단위로 삭제됨)
       
       [표현식]
       DELETE FROM 테이블
       [WHERE 조건];      --> WHERE절이 없으면 전체 행 삭제
       
       ** 특히 삭제시에은 조건절을 반드시 넣어줘야됨
*/
-- 오정보 사원의 데이터를 삭제하기
DELETE FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '오정보';

ROLLBACK;

-- 최다니엘 삭제
DELETE FROM EMPLOYEE
WHERE EMP_NAME = '최다니엘';

-- DEPARTMENT테이블에서 DEPT_ID가 D1인 부서 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';       --> FOREIGN KEY 제약조건 위반


DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

ROLLBACK;

-----------------------------------------------------------------------
/*
    * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문
        - DELETE보다 수행속도가 빠름
        - 별도의 조건 제시 불가, ROLLBACK도 불가
        
      TRUNCATE TABEL 테이블명;  
*/
TRUNCATE TABLE EMP_SALARY;

ROLLBACK;