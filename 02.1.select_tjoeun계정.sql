/*
    * DML : 데이터 조작언어
      테이블에 값을 검색(SELECT), 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
      - SELECT, INSERT, UPDATE, DELETE
*/
--=============================================================================
/*
    (')홑따옴표 : 문자열을 감싸주는 기호
    (")쌍따옴표 : 컬럼명등을 감싸주는 기호
*/

/*
    <SELECT>
    데이터를 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는컬럼명, 컬럼명, .... 
    FROM 테이블명;
*/
-- EMPLOYEE테이블의 모든 컬럼(*) 조회
SELECT *
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- JOB테이블의 모든 컬럼 조회
SELECT *
FROM JOB;

------------------- 실습문제----------------------
--1. JOB테이블에 직급명만 조회
SELECT JOB_NAME FROM JOB;

--2. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;

--3. DEPARTMENT 테이블의 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_NAME FROM DEPARTMENT;

--4. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술연사>
    SELECT절 컬럼명 작성하는 부분에 산술연산을 기술(연산결과가 조회됨)
*/
-- EMPLOYEE테이블에서 사원명, 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉((급여*BONUS + 급여)*12 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, (SALARY + SALARY*BONUS)*12
FROM EMPLOYEE;

-- DATE끼리도 연산 가능 : 결과값은 일 단위
-- 오늘 날짜 : SYSDATE

-- EMPLOYEE테이블에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    <컬럼명에 별칭 지정하기>
    산술연산시 컬럼명이 산술에 들어간 수식 그대로 됨. 별칭으로 컬럼명을 바꿔줄 때
    
    [표현법]
    컬럼명 별칭 / 컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
    
    ** 반드시 별칭에 쌍따옴표(")가 들어가야 하는 경우
       : 별칭에 띄어쓰기, 특수기호가 들어간 경우
*/

-- EMPLOYEE테이블에서 사원명, 급여, 보너스, 연봉, 보너스가포함된연봉((급여*BONUS + 급여)*12 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY*12 연봉, (SALARY + SALARY*BONUS)*12 "총 소득"
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", (SALARY + SALARY*BONUS)*12 "총 소득"
FROM EMPLOYEE;
-- 별칭 앞에 AS는 넣어도 되고 안넣어도 됨

----------------------------------------------------------------------------
/*
    <리터럴>
    임의로 지정한 문자열(' ')
    
    SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터 처럼 조회가능
    조회된 RESULT SET의 모든 행에 반복적으로 출력
*/
-- EMPLOYEE테이블에서 사번, 사원명, 급여, 원 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있음
*/

-- EMPLOYEE테이블에서 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- 컬럼값과 리터럴 연결
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다'
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    <DISTINCT>
    컬럼의 중복된 값들을 한번씩만 표시하고자 할 때
*/
-- EMPLOYEE테이블에서 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 부서코드 중복제거 조회
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- *유의 사항 : DISTINCT는 SELECT절에서 딱 한번만 기술 가능
SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE  
FROM EMPLOYEE;                                  -- 불가

SELECT DISTINCT JOB_CODE, DEPT_CODE  
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    <WHERE 절>
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
    이때 WHERE절에 조건식을 제시하게 됨
    조건식에는 다양한 연산자 사용가능
    
    [표현법]
    SELECT 컬럼명, 컬럼명, 산술연산, ...
    FORM 테이블명
    WHERE 조건식;
    
    > 조건식에는 비교연산자 사용가능
      대소 비교 : >, <, >=, <= 
      같은지 비교 : =
      같지않은지 비교 : !=, ^=, <>
*/
-- EMPLOYEE테이블에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE테이블에서 부서코드가 'D1'아 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
-- WHERE DEPT_CODE != 'D1';
-- WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE테이블에서 급여가 400만원 이상인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE테이블에서 재직중인 사원의 사번, 이름, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
FROM EMPLOYEE
WHERE ENT_YN = 'N';

---------------------------- 실습문제-----------------------------
--1. EMPLOYEE테이블에서 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12 연봉
FROM EMPLOYEE
WHERE SALARY >= 3000000;

--2. EMPLOYEE테이블에서 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY*12 연봉, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;

--3. EMPLOYEE테이블에서 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

----------------------------------------------------------------------------
/*
    <논리 연산자>
    여러개의 조건을 제시하고자 할 때 사용
    
    AND (~이면서, 그리고)
    OR (~이거나, 또는)
*/
-- EMPLOYEE테이블에서 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- EMPLOYEE테이블에서 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000; 

-- EMPLOYEE테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
-- WHERE 3500000 <= SALARY <= 6000000 오류
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

----------------------------------------------------------------------------
/*
    <BETWEEN AND>
    조건식에서 사용되는 구문
    ~이상 ~이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상컬럼 BETWEEN 하한값 AND 상한값
    -> 해당 컬럼값이 하한값 이상이고 상한값 이하인 경우 조회
*/
-- EMPLOYEE테이블에서 급여가 350만원 이상 600만원 이하인 사원들의 사번, 사원명, 급여조회
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 위와 반대인 상황
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY < 3500000 OR SALARY > 6000000;

-- 위를 BETWEEN으로
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;
--  NOT : 논리부정연산자
--        컬럼명 앞 또는 BETWEEN앞에 기입 가능

-- EMPLOYEE테이블에서 입사일이 90-01-01 ~ 01-01-01 인 사원의 모든 컬럼 조회








