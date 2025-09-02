/*
    <함수 FUNCTION>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개 값을 읽어들여 N개의 결과값 반환(매 행마다 함수 실행)
    - 그룹 함수 : N개 값을 읽어들여 1개의 결과값 반환(그룹별로 함수 실행)
    
    >> SELECT절에 단일행 함수와 그룹함수를 함께 사용 불가
    
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/
------------------------------------- 단일행 함수 -------------------------------
--==============================================================================
--                                   <문자처리 함수>
--==============================================================================
/*
    * LENGTH / LENGTNB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열') : 해당 문자열의 글자수 반환
    LENGTNB(컬럼|'문자열') : 해당 문자열의 BYTE수 반환
        - 한글 : XE버전일 때 => 1글자당 3BYTE(김, ㄱ, ㅠ -> 1글자에 해당)
                EE버전일 때 => 1글자당 2BYTE
        - 그외 : 1글자당 1BYTE
*/
SELECT LENGTH('오라클')||'글자', LENGTHB('오라클')||'byte'
FROM DUAL;  -- 오라클에서 제공하는 가상테이블

SELECT LENGTH('oracle')||'글자', LENGTHB('oracle')||'byte'
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
        EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정문자의 시작위치(INDEX)를 찾아 반환(반환형 : NUMBER)
        - ORACLE에서는 INDEX는 1부터 시작, 찾을 문자가 없으면 0반환
        
      INSTR(컬럼|'문자열', '찾고자하는 문자', [찾을위치의 시작값, [순번]])
        - 찾을위치의 시작값
          > 1 : 앞에서부터 찾기(기본값)
          > -1 : 뒤에서 부터
*/

SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL;
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL;

-- EMPLOYEE테이블에서 EMAIL의 '_'의 INDEX번호와 '@' INDEX번호 찾기
SELECT EMAIL, INSTR(EMAIL, '_',1,1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출하여 반환(반환형 : CHARCTER)
      
      SUBSTR('문자열', POSITION, [LENGTH])
       - POSITION : 문자열을 추출할 시작위치 INDEX
       - LENGTH : 추출할 문자의 갯수(생락시 맨마지막까지 추출)
*/

SELECT SUBSTR('ORACLEHTMLCSS', 7) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', 1, 6) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -7, 4) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3) FROM DUAL;
SELECT SUBSTR('ORACLEHTMLCSS', -3, 3) FROM DUAL;

-- EMPLOYEE테이블에서 주민번호의 성별만 추출하여 사원명, 주민번호, 성별을 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 여자사원들만 사원번호, 사원명, 성별 조회
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
-- WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2','4');


-- EMPLOYEE테이블에서 남자사원들만 사원번호, 사원명, 성별 조회, 사원명의 오름차순 정렬로
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 8, 1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1','3')
ORDER BY 2;

-- EMPLOYEE테이블에서 EMAIL에서 아이디만 추출하여 사원명, 이메일, 아이디(@이전까지 추출)조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) 아이디
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때(반환형 : CHARCTER)
    
      LPAD / RPAD('문자열', 최종적으로반환할문자의길이, [덧붙이고자하는문자])
      문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼의 문자열 반환
*/
-- 20길이 중 EMAIL컬럼값은 오른쪽 정렬하고 나머지부분은 공백(왼쪽)으로 채움
SELECT EMP_NAME, LPAD(EMAIL, 20)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 사원명, 주민번호 조회(123456-1******의 형식으로 출력) 
-- 우선 주민번호 추출
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8)
FROM EMPLOYEE;
-- 주민번호 뒤에 * 붙여주기
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정문자를 제거한 나머지 반환(반환형 : CHARCTER)
    * TRIM : 문자열의 앞/뒤 양쪽에 지정한 문자들을 제거한 나머지 반환
    
      LTRIM/RTRIM('문자열', [제거하고자하는 문자]) => 제거하고자하는 문자를 생략하면 공백제거
      TRIM([LEADING|TRAILING|BOTH]제거하고자하는문자들 FROM '문자열']) => 제거하고자하는 문자는 1개만 가능
*/

SELECT LTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT', 'JAVA') FROM DUAL;
SELECT LTRIM('JAVAJAVASCRIPT', 'JAV') FROM DUAL;
SELECT LTRIM('BACBAACFABCD', 'ABC') FROM DUAL;
SELECT LTRIM('283980KLSK323', '0123456789') FROM DUAL;

SELECT RTRIM('     TJOEUN     ') || '컴퓨터아카데미' FROM DUAL;
SELECT RTRIM('BACBADHAFABCB', 'ABC') FROM DUAL;

-- 기본값은 BOTH로 양쪽의 문자들을 제거
SELECT TRIM(BOTH 'A' FROM 'AAADKS78AAA') FROM DUAL;
SELECT TRIM('A' FROM 'AAADKS78AAA') FROM DUAL;
SELECT TRIM(LEADING 'A' FROM 'AAADKS78AAA') FROM DUAL;   --> LTRIM과 같음
SELECT TRIM(TRAILING 'A' FROM 'AAADKS78AAA') FROM DUAL;  --> RTRIM과 같음

----------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 첫글자만 대문자로 변환
      
      LOWER / UPPER / INITCAP('문자열')
*/
SELECT LOWER('Java Javascript Oracle') FROM DUAL;
SELECT UPPER('Java Javascript Oracle') FROM DUAL;
SELECT initcap('java javascript oracle') FROM DUAL;

----------------------------------------------------------------------------
/*
    * CONCAT : 문자열 2개를 전달받아 하나로 합쳐진 결과 반환
    
      CONCAT('문자열','문자열')
*/
SELECT CONCAT('Oracle','오라클') FROM DUAL;
SELECT 'Oracle' || '오라클' FROM DUAL;

SELECT CONCAT('Oracle','오라클', '02-123-4567', '강남구') FROM DUAL;
-- 오라클 낮은 버전에서는 문자열 2개밖에 안됨

----------------------------------------------------------------------------
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
      REPLACE('문자열', '기존문자열', '바꿀문자열')
*/
SELECT REPLACE('ORACLE 공부중', 'ORACLE', '오라클') FROM DUAL;

-- EMPLOYEE테이블에서 사원명, 기존EMAIL, 변경한 이메일(aie.or.kr -> tjoeun.co.kr)하여 조회
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'aie.or.kr', 'tjoeun.co.kr')
  FROM EMPLOYEE;

--==============================================================================
--                                   <숫자처리 함수>
--==============================================================================
/*
    * ABS : 숫자의 절대값
    
      ABS(NUMER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

----------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지값
    
      MOD(NUMBER, NUMBER)
*/
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 2) FROM DUAL;  -- 잘 사용안함

----------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과 반환
    
      ROUND(NUMER, [위치])
        - 위치 생략시 위치는 0(즉, 정수로 반올림)
*/
SELECT ROUND(12345.67) FROM DUAL;
SELECT ROUND(123.323) FROM DUAL;

SELECT ROUND(1234.5678, 2) FROM DUAL;
SELECT ROUND(1234.56, 4) FROM DUAL;

SELECT ROUND(1234.567, -2) FROM DUAL;

----------------------------------------------------------------------------
/*
    * CEIL : 무조건 올림
    
      CEIL(NUMBER)
*/
SELECT CEIL(145.278) FROM DUAL;
SELECT CEIL(-145.278) FROM DUAL;

----------------------------------------------------------------------------
/*
    * FLOOR : 무조건 내림
    
      FLOOR(NUMBER)
*/
SELECT FLOOR(145.278) FROM DUAL;
SELECT FLOOR(-145.278) FROM DUAL;

----------------------------------------------------------------------------
/*
    * TRUNC : 위치지정 가능한 버림처리 함수
    
      TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.789) FROM DUAL;
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.789) FROM DUAL;
SELECT TRUNC(-123.789, -2) FROM DUAL;

--==============================================================================
--                                   <날짜처리 함수>
--==============================================================================
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

----------------------------------------------------------------------------
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수 반환
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) 근무일수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') 근무개월수
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' 근무개월수
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큰 개월수를 더해 그 날짜를 반환
*/
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

-- EMPLOYEE테이블에서 사원명, 입사일, 정직원이된 날짜(입사일로부터 6개월 수습) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원이된 날짜"
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * NEXT_DAY(DATE, 요일(문자|숫자)) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM DUAL;

-- 1:일요일, 2:월요일 ...
SELECT SYSDATE, NEXT_DAY(SYSDATE, 2) FROM DUAL;

-- 오류 : 현재언어가 KOREA이기 때문
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'MONDAY') FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

----------------------------------------------------------------------------
/*
    * LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환해주는 함수
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- EMPLOYEE테이블에서 사원명, 입사일, 입사한달의 마지막 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;

----------------------------------------------------------------------------
/*
    * EXTRACT : 특정날짜로 부터 년도|월|일 값을 추출하여 반환하는 함수(반환형 : NUMBER)
    
      EXTRACT(YEAR FROM DATE) : 년도 추출
      EXTRACT(MONTH FROM DATE) : 월만 추출
      EXTRACT(DAY FROM DATE) : 일만 추출
*/
-- EMPLOYEE테이블에서 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
    EXTRACT(MONTH FROM HIRE_DATE) 입사월,
    EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일;

--==============================================================================
--                                   <형변환 함수>
--==============================================================================
/*
    * TO_CHAR : 숫자 또는 날짜 타입의 값을 문자타입으로 변환시켜주는 함수
                반환결과를 특정 형식에 맞춰 출력할 수도 있음
      TO_CHAR(숫자|날짜, [포맷])
*/

-------------------------------- 숫자타입 -> 문자타입 ----------------------------
/*
    9: 해당 자리의 숫자를 의미
       - 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0으로 표시
    0: 해당 자리의 숫자를 의미
       - 값이 없을 경우 0으로 표시하면 숫자의 길이를 고정적으로 표시할 때 주로 사용
    FM: 해당 자리값이 없을 경우 자리차지하지 않음
*/
SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234, '999999') FROM DUAL;  -- 6칸 확보, 왼쪽정렬, 빈칸공백
SELECT TO_CHAR(1234, '000000') FROM DUAL;  -- 6칸 확보, 왼쪽정렬, 빈칸0으로 채움
SELECT TO_CHAR(1234, 'L99999') FROM DUAL;   -- 현재 설정된 나라(LOCAL)의 화폐단위(빈칸공백) : 오른쪽정렬

SELECT TO_CHAR(1234, 'L99,999') FROM DUAL;

SELECT EMP_NAME, 
        TO_CHAR(SALARY, 'L99,999,999'), 
        TO_CHAR(SALARY*12, 'L999,999,999') 년봉
FROM EMPLOYEE;

SELECT TO_CHAR(123.456, 'FM999990.999'),
        TO_CHAR(1234.45, 'FM9990.999'),
        TO_CHAR(0.1000, 'FM9990.999'),
        TO_CHAR(0.1000, 'FM9999.999')
FROM DUAL;

SELECT TO_CHAR(123.456, '999990.999'),
        TO_CHAR(123.45, '9990.999'),
        TO_CHAR(0.1000, '9990.999'),
        TO_CHAR(0.1000, '9999.999')
FROM DUAL;

-------------------------------- 날짜타입 -> 문자타입 ----------------------------
-- 시간
SELECT TO_CHAR(SYSDATE, 'AM') KOREA,
        TO_CHAR(SYSDATE, 'PM', 'NLS_DATE_LANGUAGE=AMERICAN') AMERICAN
FROM DUAL;          -- 'AM','PM' 무엇을 쓰든 상관없음

SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;   -- HH : 12시간 형식
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;      
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL;    -- HH24 : 24시간 형식

-- 날짜
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM DUAL;    -- 월요일
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DY') FROM DUAL;     -- 월
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;         -- 9월, 2025

-- 2025년 09월 01일 월요일 출력
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" DAY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'DL') FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일 조회(출력형식 : 25-09-01)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD')
FROM EMPLOYEE;

SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'DL')
FROM EMPLOYEE;

-- 년도
/*
    YY : 현재세기가 앞에 붙는다
    RR : 50년을 기준으로 50보다 작으면 현재세기, 크거나 같으면 이전세기가 붙는다

    예제)
    RR일때
    050101 -> 2005
    780101 -> 1978
    
    YY일때
    050101 -> 2005
    780101 -> 2078
*/
SELECT TO_CHAR(SYSDATE, 'YYYY'),
        TO_CHAR(SYSDATE, 'YY'),
        TO_CHAR(SYSDATE, 'RRRR'),
        TO_CHAR(SYSDATE, 'RR'),
        TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월
SELECT TO_CHAR(SYSDATE, 'MM'),
        TO_CHAR(SYSDATE, 'MON'),
        TO_CHAR(SYSDATE, 'MONTH'),
        TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

SELECT TO_CHAR(SYSDATE, 'MM'),
        TO_CHAR(SYSDATE, 'MON'),
        TO_CHAR(SYSDATE, 'MONTH'),
        TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

-- 일
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 년을 기준으로 몇일째
        TO_CHAR(SYSDATE, 'DD'), -- 월을 기준으로 몇일째
        TO_CHAR(SYSDATE, 'D')   -- 일주일을 기준으로 몇일째(일요일이 1일)
FROM DUAL;

-- 요일
SELECT TO_CHAR(SYSDATE, 'DAY'),
        TO_CHAR(SYSDATE, 'DY')
FROM DUAL;

--------------------------- 숫자 또는 문자타입 -> 날짜타입 ------------------------
/*
    * TO_DATE : 숫자 또는 문자타입을 날짜타입으로 변환
    
      TO_DATE(숫자|문자, [포맷])
*/
SELECT TO_DATE(20100901) FROM DUAL;
SELECT TO_DATE(100901) FROM DUAL;

SELECT TO_DATE(010901) FROM DUAL;       -- 숫자는 앞이 0일때 0을 제거하므로 오류
SELECT TO_DATE('010901') FROM DUAL;     -- 0이 앞에 붙으면 문자열로 넣어준다

SELECT TO_DATE('041028 103000', 'YYMMDD HHMISS') FROM DUAL;
-- SELECT TO_DATE('041028 143000', 'YYMMDD HHMISS') FROM DUAL;  -- 오류 : 오전 오후로 14시는 없음
SELECT TO_DATE('041028 143000', 'YYMMDD HH24MISS') FROM DUAL;

SELECT TO_CHAR(TO_DATE('041028 103000', 'YYMMDD HHMISS'), 'YY-MM-DD HH:MI:SS') FROM DUAL;

SELECT TO_DATE('040725', 'YYMMDD') FROM DUAL;   -- 현재세기
SELECT TO_DATE('970725', 'YYMMDD') FROM DUAL;   -- 현재세기
SELECT TO_CHAR(TO_DATE('970725', 'YYMMDD'), 'YYYY-MM-DD') FROM DUAL;

SELECT TO_DATE('040725', 'RRMMDD') FROM DUAL;   -- 현재세기
SELECT TO_DATE('970725', 'RRMMDD') FROM DUAL;   -- 이전세기
SELECT TO_CHAR(TO_DATE('970725', 'RRMMDD'), 'RRRR-MM-DD') FROM DUAL;

-------------------------------- 문자타입 -> 숫자타입 ----------------------------
/*
    * TO_NUMBER : 문자 타입의 데이털를 숫자타입으로 변환
    
      TO_NUMBER(문자, [포맷])
*/
SELECT TO_NUMBER('0123401234') FROM DUAL;
SELECT '1000000' + '550000' FROM DUAL;      -- 자동 형변환(숫자로)
-- SELECT '1,000,000' + '550,000' FROM DUAL;   -- 오류 숫자이외의 컴마(,) 특수기호가 있으면 자동형변환안됨
SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000','999,999') FROM DUAL;

--==============================================================================
--                                   <NULL처리 함수>
--==============================================================================
/*
    * NVL(컬럼, 해당컬럼값이 NULL일때 반환할 값)
*/
SELECT EMP_NAME, NVL(BONUS, 0)
  FROM EMPLOYEE;
  
-- 전사원의 이름, 보너스포함 연봉
SELECT EMP_NAME, (SALARY + (SALARY*NVL(BONUS,0)))*12
FROM EMPLOYEE;

-- 전사원의 사원명, 부서코드조회(만약 부서코드가 NULL이면 '부서없음'으로 출력)
SELECT EMP_NAME, NVL(DEPT_CODE, '부서없음')
  FROM EMPLOYEE;
  
-------------------------------------------------------------------------------
/*    
    * NVL2(컬럼, 반환값1, 반환값2)
      - 컬럼값이 존재하면 반환값1
      - 컬럼값이 없으면 반환값2
*/
-- EMPLOYEE에서 사원명, 급여, 보너스, 성과급(보너스를 받는사람은 50%, 보너스를 못받는사람은 10%)
SELECT EMP_NAME, SALARY, BONUS, SALARY * NVL2(BONUS, 0.5, 0.1) 성과급
FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 부서(부서에 속해있으면 '부서있음', 부서에 속하지 않으면 '부서없음')
SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음', '부서없음')
  FROM EMPLOYEE;

-------------------------------------------------------------------------------
/*    
    * NULLIF(비교대상1, 비교대상2)
      - 2개의 값이 일치하면 NULL반환
      - 2개의 값이 다르면 비교대상1 값을 반환
*/
SELECT NULLIF('123','123') FROM DUAL;
SELECT NULLIF('123','456') FROM DUAL;

--==============================================================================
--                                   <선택 함수>
--==============================================================================
/*
    * DECODE(비교하고자하는 대상(컬럼|산술연사|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ...)
    
    * 프로그램의 SWITCH와 같음
      SWITCH(비교대상) {
        CASE 비교값1:
            결과값1;
        CASE 비교값2:
            결과값2;
        ...
        DEFALUT :
            결과값N;
      }
*/

-- EMPLOYEE테이블에서 사번, 사원명, 주민번호, 성별
SELECT EMP_ID, EMP_NAME, EMP_NO, 
       DECODE(SUBSTR(EMP_NO, 8, 1), 
                '1', '남', 
                '2', '여', 
                '3', '남',
                     '여') 성별
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 사원명, 직급코드, 급여, 각 직급별로 인상한 급여 조회
    -- J7인 사원은 급여를 10% 인상
    -- J6인 사원은 급여를 15% 인상
    -- J5인 사원은 급여를 20% 인상
    -- 이외 모든 사원은 급여를 5%인상
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY,
        DECODE(JOB_CODE, 'J7', SALARY*1.1,
                         'J6', SALARY*1.15,
                         'J5', SALARY*1.2,
                               SALARY*1.05) "인상된 급여"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * CASE WHEN THEN
      END
      
      CASE WHEN 조건식1 THEN 결과값1
           WHEN 조건식2 THEN 결과값2
           ...
           ELSE 결과값N
      END
      
      * 프로그램의 if-else와 동일
        if(조건식1)
            결과값1
        else if(조건식2)
            결과값2
        ...
        else
            결과값N
*/
-- EMPLOYEE테이블에서 사원명, 급여, 급여에 따른 등급
   -- 고급 : 5백만원 이상 인 사원
   -- 중급 : 5백만원 미만 ~ 3백만원 이상 인 사원
   -- 초급 : 3백만원 미만 인 모든 사원
SELECT EMP_NAME, SALARY,
        CASE WHEN SALARY >= 5000000 THEN '고급'
             WHEN SALARY >= 3000000 THEN '중급'
             ELSE '초급'
        END 등급
FROM EMPLOYEE;

--==============================================================================
--                                   <그룹 함수>
--==============================================================================
/*
    * SUM(컬럼(NUMBER타입)) : 해당 컬럼값들의 총 합계를 구해 반환하는 함수
*/
-- EMPLOYEE테이블에서 전 사원의 급여의 합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 남자 사원의 급여의 합
SELECT SUM(SALARY) "남자 사원의 총급여"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN('1', '3');
-- WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','3','남') = '남'
-- WHERE DECODE(SUBSTR(EMP_NO, 8, 1), '1','남','2','여','3','남','여') = '남'

-- EMPLOYEE테이블에서 부서코드가 'D5'인 사원의 총 연봉(보너스포함)의 합 조회
SELECT SUM(SALARY*NVL(BONUS,0) + SALARY)*12
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- EMPLOYEE테이블에서 전 사원의 급여의 합(출력: \111,111,111)
SELECT TO_CHAR(SUM(SALARY), 'L999,999,999') "총 급여액"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * AVG(컬럼(NUMBER타입)) : 해당 컬럼값들의 평균 반환
*/
-- EMPLOYEE테이블에서 전 사원의 급여의 평균 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

SELECT ROUND(AVG(SALARY), 2)
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * MIN(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 작은값 반환
    * MAX(컬럼(모든타입)) : 해당 컬럼 값들 중 가장 큰값 반환
*/
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;

SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    * COUNT(*|컬럼|DISTINCT컬럼) : 행의 갯수 반환
    
      - COUNT(*) : 조회된 결과의 모든 행의 갯수 반환
      - COUNT(컬럼) : 제시한 컬럼의 NULL값을 제외한 행의 갯수 반환
      - COUNT(DISTINCT 컬럼) : 해당 컬럼값에서 중복을 제거한 행의 갯수 반환
*/
-- EMPLOYEE테이블에서 전체 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 여자 사원의 수
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN('2', '4');

-- EMPLOYEE테이블에서 보너스를 받는 사원의 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 부서배치를 받은 사원의 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- EMPLOYEE테이블에서 현재 사원이 총 몇개의 부서에 분포되어있는지 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;