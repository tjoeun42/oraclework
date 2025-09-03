/*
    <서브쿼리(SUBQUERY)>
    - 하나의 SQL문 안에 포함된 또다른 SELECT문
    - 메인 SQL문을 보조하기 위한 쿼리문
*/
-- 간단한 서브쿼리 예1
-- 박정보 사원과 같은 부서에 속한 사원들 사원명 조회
--  1) 먼저 박정보 사원의 부서코드조회
SELECT DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '박정보';
 
--  2) 부서코드가 'D9'인 사원들의 사원명 조회
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9'; 

-- 위의 단계를 하나의 쿼리문으로
SELECT EMP_NAME, DEPT_CODE
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '박정보');

-- 간단한 서브쿼리 예2
-- 전 직원의 평균급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 급여 조회

-- 1) 전직원의 평균급여
SELECT AVG(SALARY)
  FROM EMPLOYEE;
  
-- 2) 급여가 3047663이상인 사원들의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE
 WHERE SALARY >= 3047663; 

-- 위의 단계를 하나의 쿼리문으로
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE
 WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE);

----------------------------------------------------------------------------
/*
    * 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라 구분
      
      - 단일행 서브쿼리 : 서브쿼리를 수행한 결과값이 오로지 1개일 때(1행 1열)
      - 다중행 서브쿼리 : 서브쿼리를 수행한 결과값이 여러행일 때(여러행 1열)
      - 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러열일 때(1행 여러열)
      - 다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러행 여러열일 때(여러행 여러열)
      
      >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/


/*
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
       서브쿼리를 수행한 결과값이 오로지 1개일 때(1행 1열)
       일반 비교연산자 사용가능
       =, !=, >, < ...
*/
-- 1) 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY < (SELECT AVG(SALARY)
                   FROM EMPLOYEE);
                   
-- 2) 최저 급여를 받는 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE
 WHERE SALARY = (SELECT MIN(SALARY)
                   FROM EMPLOYEE);

-- 3) 박정보사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '박정보'); 

-- JOIN
-- 4) 박정보 사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서명, 급여 조회
--   >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
  FROM EMPLOYEE, DEPARTMENT
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '박정보')
   AND DEPT_CODE = DEPT_ID;              

--   >> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '박정보'); 

-- 5) 왕정보사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회. 단, 왕정보는 제외
--   >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '왕정보')
   AND DEPT_CODE = DEPT_ID
   AND EMP_NAME != '왕정보';
                     
--   >> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '왕정보')
   AND EMP_NAME != '왕정보';
   
-- GROUP BY
-- 6) 부서별 급여합이 가장 큰 부서의 부서코드, 급여합 조회
SELECT DEPT_CODE, SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
 HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                         FROM EMPLOYEE
                        GROUP BY DEPT_CODE);

-------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
       서브쿼리를 수행한 결과값이 여러행일 때(여러행 1열)
       
       - IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
       - > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
                        (여러개의 결과값 중에서 가장 작은값보다 클 경우)
       - < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
                        (여러개의 결과값 중에서 가장 큰값보다 작을 경우)
       - ALL : 서브쿼리의 값들중 가장 큰값보다 더 큰값을 얻어올 때
                        
      * 비교대상 > ANY (값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
*/
-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
----- 1.1 조정연 또는 전지연이 어떤 직급인지 조회
SELECT JOB_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME IN ('조정연', '전지연');

----- 1.2 J3, J7의 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN ('J3','J7');
 
-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN (SELECT JOB_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME IN ('조정연', '전지연'));

-- 2) 대리 직급임에도 과장 직급의 급여들 중 최소 급여보다 많이 받는 사원의 사번, 사원명, 직급명, 급여 조회
----- 2.1 과장 직급인 사원들 급여 조회
SELECT SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '과장';      -- 급여 : 3760000, 2200000, 2500000
 
----- 2.2 직급이 대리이면서 위의 급여 목록의 값들 중 하나라도 큰 사원의 사번, 사원명, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY (3760000, 2200000, 2500000);

-- 위의 쿼리문을 하나로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY (SELECT SALARY
                       FROM EMPLOYEE
                       JOIN JOB USING(JOB_CODE)
                      WHERE JOB_NAME = '과장');

-- 단일행 쿼리로도 가능
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > (SELECT MIN(SALARY)
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                  WHERE JOB_NAME = '과장');

-- 3) 차장 직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 사원명, 직급, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '차장'
   AND SALARY < ANY (SELECT SALARY
                       FROM EMPLOYEE
                       JOIN JOB USING(JOB_CODE)
                      WHERE JOB_NAME = '과장');

-- 4) 과장 직급임에도 차장직급의 사원들의 모든 급여보다 더 많이 받는 사원들의 사번, 사원명, 직급명, 급여조회
-- ALL : 서브쿼리의 값들중 가장 큰값보다 더 큰값을 얻어올 때
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '과장'
   AND SALARY > ALL(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING(JOB_CODE)
                     WHERE JOB_NAME = '차장');


-------------------------------------------------------------------------------
/*
    3. 다중열 서브쿼리
       서브쿼리를 수행한 결과값이 여러열일 때(1행 여러열) 
*/
-- 1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '장정보')
   AND JOB_CODE = (SELECT JOB_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '장정보');

-- >> 다중열 서브쿼리로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '장정보');

-- 지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수사번 조회





