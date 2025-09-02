/*
    <GROUP BY>
    그룹기준을 제시할 수 있는 구문(해당 그룹기준별로 여러 그룹을 묶을수 있음)
    여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
*/
-- 전 사원을 하나의 그룹으로 묶어서 총급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 각 부서별 총 급여합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 사원 수
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 위의 2개를 한번에 조회
SELECT DEPT_CODE, COUNT(*) 인원수, SUM(SALARY) "급여의 총합"
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 직급별 사원수와 급여의 합
SELECT JOB_CODE, COUNT(*) 인원수, SUM(SALARY) "급여의 총합"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 각 직급별 총사원수, 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여 조회
SELECT JOB_CODE, COUNT(*) "총 사원수", COUNT(BONUS) "보너스를 받는 사원수",
        SUM(SALARY) 급여합, ROUND(AVG(SALARY)) 평균급여, 
        MIN(SALARY) 최저급여, MAX(SALARY) 최고급여
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 남,여별 사원수
-- DECODE()함수는 오라클에서만 사용하는 함수
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남','2','여','3', '남','여') 성별, COUNT(*) "성별 인원수"
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 모든 DB다 사용
SELECT CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
            WHEN SUBSTR(EMP_NO, 8, 1) = '3' THEN '남'
            ELSE '여'
       END 성별,
       COUNT(*) "성별 인원수"
FROM EMPLOYEE
GROUP BY CASE WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남'
            WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여'
            WHEN SUBSTR(EMP_NO, 8, 1) = '3' THEN '남'
            ELSE '여'
       END;
       
-- GROUP BY절에 여러 컬럼 기술 가능
SELECT DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE;

--------------------------------------------------------------------------------
/*
    <HAVING절>
    그룹에 대한 조건을 제시할 때 사용되는 구문(주로 그룹함수식을 가지고 조건을 제시할 때 사용)
*/
-- 각 부서별 급여 조회(부서코드, 평균급여)
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별 평균급여가 300만원 이상인 부서들만 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING ROUND(AVG(SALARY)) >= 3000000;

/*
    <SELECT문 실행 순서>
    FROM
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    ORDER BY
    
    FROM
    ON : 조인 조건 확인
    JOIN
    WHERE
    GROUP BY
    HAVING
    SELECT
    DISTINCT
    ORDER BY
*/
---------------------------- 실습문제------------------------------
--1. 직급별 총 급여합(단, 직급별 급여합이 1000만원 이상인 직급만 조회) 직급코드, 급여합 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

--------------------------------------------------------------------------------
/*
    <집계함수>
    그룹별 산출된 결과값에 중간집계를 계산해주는 함수
    
    ROLLUP, CUBE
    => GROUP BY절에 기술하는 함수
    
    - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
    - CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고도 중간집계를 냄
*/
-- 각 직급별 급여합
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- 마지막 행에 전체 총 급여합까지 조회
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;
-- 그룹기준의 컬럼이 하나일 때는 CUBE, ROLLUP차이가 없음

-- CUBE, ROLLUP의 차이점을 보려면 그룹기준의 컬럼이 2개는 있어야 됨
-- ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

-- CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내고, 컬럼2를 가지고도 중간집계를 냄
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

--------------------------------------------------------------------------------
/*
    <집합연산자>
    여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
    
    - UNION : OR | 합집합(두 쿼리문을 수행한 결과값을 더한 후 중복되는 값은 한번만 더해지도록)
    - INTERSECT : AND | 교집합(두 쿼리문을 수행한 결과 중복된 값만)
    - UNION ALL : 합집합 + 교집합(중복되는 값은 2번 표현됨)
    - MINUS : 차집합(선행결과값에서 후행결과값을 뺀 나머지)
*/
-------------------------------- 1. UNION ----------------------------
-- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회
-- 부서코드가 D5인 사원
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';     -- 6명

-- 급여가 300만원 초과인 사원들
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;     -- 8명

-- UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- OR절로도 가능
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;

-------------------------------- 2. INTERSECT ----------------------------
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND절로도 가능
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

-------------------------------- 3. UNION ALL ----------------------------
-- 부서코드가 D5이면서 급여가 300만원 초과인 사원들 조회(중복되는 행은 2번출력)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-------------------------------- 4. MINUS ----------------------------
-- 부서코드가 D5이면서 급여가 300만원 이하인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND로도 가능
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;  -- 300만원보다 작거나 같다로 바꾸어줌