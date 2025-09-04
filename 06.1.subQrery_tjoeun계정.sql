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
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
  FROM EMPLOYEE
 WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                   FROM EMPLOYEE
                                  WHERE EMP_NAME = '지정보');

-------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
        서브쿼리를 수행한 결과값이 여러행 여러열일 때(여러행 여러열)
*/
-- 1. 각 직급별 최소급여 금액을 받는 사원의 사번, 사원명, 직급코드, 급여조회
--    1.1 각 직급별 최소급여 금액과 직급코드 조회
SELECT JOB_CODE, MIN(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;  

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 GROUP BY JOB_CODE = 'J1' AND SALARY = 8000000
       OR JOB_CODE = 'J2' AND SALARY = 3700000
            ... ;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) = ('J1', 8000000)
    OR (JOB_CODE, SALARY) = ('J2', 3700000)
        ...;
        
-- 서브쿼리로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                               GROUP BY JOB_CODE); 
                               
-- 2. 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                                 FROM EMPLOYEE
                                GROUP BY DEPT_CODE);


-------------------------------------------------------------------------------
/*
    5. 인라인 뷰(INLINE VIEW)
       FROM절에 서브쿼리를 작성
       
       서브쿼리를 수행할 결과를 마치 테이블처럼 사용
*/
-- 사원들의 사번, 사원명, 보너스를 포함한 연봉(별칭부여), 부서코드 조회
--  => 연봉에 NULL이 나오지 않게 조회
--  단, 보너스포함 연봉이 4000만원이상인 사원들만 조회

-- SELECT EMP_ID, EMP_NAME, (SALARY + (SALARY*NVL(BONUS, 0)))*12 "연봉(보너스포함)", DEPT_CODE
SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS, 1)*12 연봉, DEPT_CODE
  FROM EMPLOYEE;
 WHERE SALARY*NVL(1+BONUS, 1)*12 >= 40000000;
 
-- WHERE절에 별칭으로 사용하고 싶으면 INLINE VIEW사용
SELECT *
  FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS, 1)*12 연봉, DEPT_CODE
          FROM EMPLOYEE);  -- 테이블처럼 사용
  
SELECT *
  FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS, 1)*12 연봉, DEPT_CODE
          FROM EMPLOYEE)
 WHERE 연봉 >= 40000000;

SELECT EMP_NAME, 연봉, DEPT_CODE
  FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS, 1)*12 연봉, DEPT_CODE
          FROM EMPLOYEE)
 WHERE 연봉 >= 40000000;
 
SELECT EMP_NAME, 연봉, DEPT_CODE, PHONE
  FROM (SELECT EMP_ID, EMP_NAME, SALARY*NVL(1+BONUS, 1)*12 연봉, DEPT_CODE
          FROM EMPLOYEE)
 WHERE 연봉 >= 40000000;   -- 오류 : FROM뒤의 테이블에는 PHONE라는 컬럼이 없어서

-- >> 인라인 뷰는 주로 TOP-N분석(상위 몇위만 가져오기)

-- 전 직원 중 급여가 가장 높은 상위 5명만 조회
--   * ROWNUM : 오라클에서 제공해주는 컬럼. 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
  FROM EMPLOYEE;
  
-- 급여의 내림차순 정렬로 조회
SELECT ROWNUM, EMP_NAME, SALARY
  FROM EMPLOYEE
 ORDER BY SALARY DESC;
-- 수행순서 : FROM -> SELECT -> ORDER 
 
-- FROM -> SELECT -> ORDER -> ROWNUM
SELECT *
  FROM (SELECT EMP_NAME, SALARY
          FROM EMPLOYEE
         ORDER BY SALARY DESC);

SELECT ROWNUM, EMP_NAME, SALARY
  FROM (SELECT EMP_NAME, SALARY
          FROM EMPLOYEE
         ORDER BY SALARY DESC);
         
SELECT ROWNUM, *
  FROM (SELECT EMP_NAME, SALARY
          FROM EMPLOYEE
         ORDER BY SALARY DESC);  -- 오류 

-- 테이블에 별칭 부여      
SELECT ROWNUM, E.*
  FROM (SELECT EMP_NAME, SALARY
          FROM EMPLOYEE
         ORDER BY SALARY DESC) E
 WHERE ROWNUM <= 5;

-- 가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
  FROM (SELECT *
          FROM EMPLOYEE
         ORDER BY HIRE_DATE DESC)
 WHERE ROWNUM <= 5;

-- 각 부서별 평균급여가 높은 3개의 부서의 부서코드, 평균급여 조회
SELECT *
  FROM (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
          FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY 2 DESC)
 WHERE ROWNUM <= 3;

-------------------------------------------------------------------------------
/*
    6. WITH
        서브쿼리에 이름을 붙여주고 인라인뷰로 사용시 서브쿼리의 이름으로 FROM절에 기술
        한번의 SQL문장에서만 유효
        
      - 장점
        가독성이 좋다
        같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피할수 있음
        실행속도도 빨라짐
*/
WITH TOPN_SAL AS (SELECT DEPT_CODE, CEIL(AVG(SALARY)) 평균급여
                    FROM EMPLOYEE
                   GROUP BY DEPT_CODE
                   ORDER BY 2 DESC)
/*
SELECT DEPT_CODE, 평균급여
  FROM TOPN_SAL
 WHERE ROWNUM <= 3;
*/
SELECT *
  FROM TOPN_SAL
 WHERE ROWNUM <= 3;

-------------------------------------------------------------------------------
/*
    <순위 매기는 함수>
    * RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
      : SELECT절에서만 사용
      - RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                                EX) 공동1위가 2명이면 그 다음 순위는 3위
      - DENSE_RANK() OVER(정렬기준) : 동일한 순위 이후의 등수는 무조건 1증가한 등수
                                EX) 공동1위가 2명이면 그 다음 순위는 2위                        
*/
-- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위를 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE;
-- 공동 19위 2명, 그 뒤 순위는 21위

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE; 
-- 공동 19위 2명, 그 뒤 순위는 20위

-- 급여가 상위 5위인 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) 순위
  FROM EMPLOYEE
 WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; 






  
  
