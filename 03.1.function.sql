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










