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
