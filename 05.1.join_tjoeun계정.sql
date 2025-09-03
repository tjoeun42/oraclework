/*
    <join>
    두개이상의 테이블에서 데이터를 조회하고자 할 때 사용
    조회결과는 하나의 결과물(RESULT SET)로 나옴
    
    관계형데이터베이스는 최소한의 데이터로 각각 테이블에 담고 있음
    (중복을 최소화하기 위해 최대한 나누어서 관리)
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 "관계"를 맺는 방법
    
    JOIN은 크게 "오라클전용구문"과 "ANSI구문" (ANSI == 미국국립표준협회)
    
                                [JOIN 용어 정리]
---------------------------------------------------------------------------
            오라클 전용 구문         |           ANSI 구문
---------------------------------------------------------------------------
                등가조인             |   내부조인(INNER JOIN) => JOIN USING/ON
                (EQUAL JOIN)        |   자연조인(NATURAL JOIN) => JOIN USING
---------------------------------------------------------------------------
                포괄조인             |   왼쪽 외부 조인(LEFT OUTER JOIN)
                (LEFT OUTER)        |   오른쪽 외부 조인(RIGHT OUTER JOIN) 
                (RIGHT OUTER)       |   전체 외부 조인(FULL OUTER JOIN)
---------------------------------------------------------------------------
            자체조인(SELF JOIN)      |                  JOIN ON
        비등가조인(NON EQUAL JOIN)   |   
---------------------------------------------------------------------------
    카테시안 곱(CARTESIAN PRODUCT)    |          교차조인(CROSS JOIN)
*/
-- 전체  사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_TITLE
FROM DEPARTMENT;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 전체  사원들의 사번, 사원명, 직급코드, 직급명을 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

----------------------------------------------------------------------
/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
       연결시키는 컬럼의 값이 "일치하는 행들만" 조인되어 조회(=일치하는 값이 없는 행은 조회에서 제외)  
*/
--  >> 오라클 전용 구문
--     FROM절에 조회하고자하는 테이블들을 나열(, 구분자로)
--     WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시

--  1) 연결할 두 컬럼명이 다른경우(EMPLOYEE: DEPT_CODE / DEPARTMENT: DEPT_ID)
--     전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT;
--  DEPARTMENT 행당 23명씩 TOTAL 207명 검색

--  JOIN시 반드시 WHERE절에 매칭되는 컬럼명을 써준다
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID; 

--  2) 연결할 두 컬럼명이 같은경우(EMPLOYEE: JOB_CODE / JOB: JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE JOB_CODE = JOB_CODE;
 -- 모호하게 지정된 열
 
-- 해결방법 1) 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법 2) 테이블명에 별칭을 부여하여 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE;


--  >> ANSI 구문
--     FROM절에 기준이 되는 테이블을 하나 기술
--     JOIN절에 같이 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
--         > JOIN USING, JOIN ON 

--  1) 연결할 두 컬럼명이 다른경우(EMPLOYEE: DEPT_CODE / DEPARTMENT: DEPT_ID)
--     전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--  2) 연결할 두 컬럼명이 같은경우(EMPLOYEE: JOB_CODE / JOB: JOB_CODE)
-- 전체 사원들의 사번, 사원명, 직급코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB ON (JOB_CODE = JOB_CODE);    
  -- 모호하게 지정된 열 오류

-- 해결방법 1) 테이블명 또는 별칭을 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법 2) JOIN USING 구문을 사용하는 방법(두컬럼명이 일치할 때만 사용 가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE);

-- [참고 사항]
-- NATURAL JOIN : 공통된 컬럼을 자동으로 매칭시켜줌
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
NATURAL JOIN JOB;

/*
-- 연결 컬럼명이 다른 경우(DEPARTMENT행당 23명씩 TOTAL 207행 나옴)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
  FROM EMPLOYEE
NATURAL JOIN DEPARTMENT;
*/

-- 3) 추가적인 조건도 제시 가능
-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여를 조회
--  >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '대리';

--  >> ANSI 구문
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'; 

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름,  부서명, 보너스 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 2. DEPARTMENT과 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--  >> 오라클 전용 구문

--  >> ANSI 구문






