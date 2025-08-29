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









