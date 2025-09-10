/*
    <PL/SQL>
    오라클 자체에 내장되어 있는 절차적 언어
    SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여 SQL의 단점을 보완
    다수의 SQL문을 한번에 실행 가능(BLOCK 구조)
    
    * PL/SQL구조
      - [선언부 (DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
      - 실행부 (EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
      - [예외처리부 (EXCEPTION SECTION)] : EXCEPTION으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 둘 수 있는 부분
*/
-- ** 화면에 출력하려면 반드시 ON으로 켜줘야 됨
SET SERVEROUTPUT ON;

BEGIN
    -- System.out.println("Hello oracle") -> 자바
    DBMS_OUTPUT.PUT_LINE('Hello Oracle');
END;
/

/*
    1. DECLARE 선언부
       변수나 상수를 선언하는 공간(선언과 동시에 초기화도 가능)
       일반타입 변수, 레퍼런스 변수, ROW타입 변수
       
       1) 일반타입 변수 선언 및 초기화
          [표현식]
          변수명 [CONSTANT] 자료형 [:= 값]
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := 700;
    ENAME := '배정남';
    
    DBMS_OUTPUT.PUT_LINE(EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

------------------------------------------------------------------------
/*
    2) 레퍼런스 변수
       어떤테이블의 어떤 컬럼의 데이터타입을 참조하여 그타입으로 지정
       
       [표현법]
       변수명 테이블명.컬럼명%TYPE;
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '400';
    ENAME := '유하늘';
    SAL := 3000000;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/


DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    -- 사번이 200번인 사원의 사번, 사원명, 급여 조회하여 각 변수에 대입
    SELECT EMP_ID, EMP_NAME, SALARY
      INTO EID, ENAME, SAL
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
     DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
     DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
     DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/

-- 문제
/*
    레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY),
             DEPARTMENT(DEPT_TITLE)을 참조하도록 설정
    
    사용자가 입력 사번의 사번, 사원명, 직급코드, 급여, 부서명 조회한 후 각 변수에 담아 출력
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
      INTO EID, ENAME, JCODE, SAL, DTITLE
      FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
     WHERE EMP_ID = &사번;
     
     DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || JCODE || ', ' ||SAL || ', ' ||DTITLE);
END;
/

------------------------------------------------------------------------
/*
    3) ROW타입 변수
       테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
       
       [표현법]
       변수명 테이블명%ROWTYPE;
*/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
     DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
     DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
     -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || E.BONUS);
     -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, '없음'));  -- 오류 : 타입이 안맞아서
     DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS, 0));
END;
/

-- 오류
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT EMP_NAME, SALARY, BONUS  -- 무조건 *을 사용
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
     
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || E.BONUS);
END;
/

--==============================================================================
/*
    2. BEGIN 실행부
    
        <조건문>
        1) 단일 IF문
           IF 조건식 THEN 실행내용 END IF;
*/
-- 사번을 입력받은 후 해당 사원의 사번, 사원명, 급여, 보너스율(%)출력
-- 단, 보너스를 받지않는사원은 보너스율 출력전에 '보너스를 받지않는 사원입니다'출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
      INTO EID, ENAME, SAL, BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
     
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    END IF;  
    
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
END;
/

--   2) IF-ELSE문
--      IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;   
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
      INTO EID, ENAME, SAL, BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
     
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
    
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS*100 || '%');
    END IF;  
END;
/

-- 문제
/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
    참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반 변수 : TEAM(소속)
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
          단) NCODE값이 KO일 경우 => TEAM변수에 '국내팀'
              NCODE값이 KO가 아니면 => TEAM변수에 '해외팀'
              
    출력 : 사번, 이름, 부서명, 소속 출력          
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE; 
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE; 
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
      INTO EID, ENAME, DTITLE, NCODE
      FROM EMPLOYEE
      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
     WHERE EMP_ID = '&사번';
     
     IF NCODE = 'KO'
        THEN TEAM := '국내팀';
     ELSE
        TEAM := '해외팀';
     END IF;
     
     DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
     DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
     DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);
     DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);
END;
/

/*
        3) IF-ELSE문
            IF 조건식1 THEN 실행내용1;
            ELSIF 조건식2 THEN 실행내용2;
            ELSIF 조건식3 THEN 실행내용3;
            ELSE 실행내용4;
            END IF; 
*/

-- 사용자로 부터 점수를 입력받아 학점 출력
-- 변수 2개 필요. (점수, 학점)
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;

    -- 당신의 점수는 ??점이고 ,학점은 ?학점입니다.
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '학점입니다');
END;
/

-- 문제
/*
    사용자에게 입력받은 사번의 급여를 조회하여 SAL변수에 입력하고
    - 500만원 이상이면 '고급'
    - 300만원 이상 500만원 미만이면 '중급'
    - 300만원 미만이면 '초급'
    
    출력 : 해당 사원의 급여 등급은 ??입니다
*/

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
      INTO SAL
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
     
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다');
END;
/

/*
        4) CASE 비교대상자
            WHEN 비교할값1 THEN 실행내용1
            WHEN 비교할값2 THEN 실행내용2
            WHEN 비교할값3 THEN 실행내용3
            ELSE 실행내용4
           END;
           
           JAVA PROGRAM
           SWITCH(변수) {      -> CASE
            CASE 비교할값1 :    -> WHEN
                실행내용1;      -> THEN
            DEFAULT :          -> ELSE     
           }
*/

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT *
      INTO EMP
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
     
     DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사팀'
                WHEN 'D2' THEN '회계팀'
                WHEN 'D3' THEN '마케팅팀'
                WHEN 'D4' THEN '국내영업팀'
                WHEN 'D8' THEN '기술지원팀'
                WHEN 'D9' THEN '총무팀'
                ELSE '해외영업팀'
             END;
    
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은 ' || DNAME || '입니다');
END;
/

--------------------------------------------------------------------------------
/*
    <LOOP>
    1) BASIC LOOP문
    
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        ** 반복문을 빠져나갈 구문;
    END LOOP;
    
    ** 반복문을 빠져나갈 조건문 2가지
    (1) IF 조건식 THEN EXIT; END IF;
    (2) EXIT WHEN 조건식;
*/
-- 1~5까지 1씩 증가하면서 출력
--   (1) IF 조건식 THEN EXIT; END IF;
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        IF I=6 THEN EXIT;
        END IF;
    END LOOP;
END;
/

--    (2) EXIT WHEN 조건식;
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        EXIT WHEN I=6;
    END LOOP;
END;
/

/*
    2) FOR LOOP문
    
    [표현식]
    FOR 변수 IN [REVERSE] 초기값.. 최종값
    LOOP
        반복적으로 실행할 구문;
    END LOOP;    
*/

BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

BEGIN
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/

-- 테이블과 시퀀스를 생성하고, 테이블에 INSERT하는 구문 만들기
DROP TABLE TEST;
DROP SEQUENCE SEQ_TNO;

CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2
START WITH 100
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
END;
/

/*
    3) WHILE LOOP문
    
    [표현식]
    WHILE 반복문이 수행할 조건
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/
DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I<6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
    END LOOP;
END;
/

--------------------------------------------------------------------------------
/*
    3. 예외처리부
       실행 중 발생하는 오류
       
       [표현식]
       EXCEPTION
        WHEN 예외명1 THEN 예외처리구문1;
        WHEN 예외명2 THEN 예외처리구문2;
        WHEN 예외명N THEN 예외처리구문N;
        
       * 시스템 예외(오라클에서 미리 정의해둔 예외)
       - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
       - TOO_MANY_ROWS : SELECT한 결과가 여러행일 경우
       - ZERO_DIVIDE : 0으로 나눌 때
       - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
       ...
*/

-- 사용자로 부터 입력을 받아 나눗셈을 한 결과 출력
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE(RESULT);
EXCEPTION
    -- WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌수 없습니다');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌수 없습니다');
END;
/

-- UNIQUE 제약조건 위배
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&변경할사번'
    WHERE EMP_NAME = '이정하';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다');
END;
/

-- 사수 201번은 1명, 200번은 여러명, 202는 없음
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
      INTO EID, ENAME
      FROM EMPLOYEE
     WHERE MANAGER_ID = '&사수사번';
     
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID); 
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다');
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회 결과가 없습니다');
END;
/

-- 문제
/*
    1. 사원의 연봉(보너스포함)을 구하는 PL/SQL블럭 작성
       > 사용자로부터 EMP_ID를 입력받는 구문으로 작성
       > 출력 : 급여, 이름, 연봉(\23,500,00)
*/
DECLARE
    E EMPLOYEE%ROWTYPE;
    YSALARY NUMBER;
BEGIN
    SELECT *
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = '&사번';
    
    IF(E.BONUS IS NULL)
        THEN YSALARY := E.SALARY * 12;
    ELSE
        YSALARY := E.SALARY * (1+E.BONUS) * 12;
    END IF;

    DBMS_OUTPUT.PUT_LINE(E.SALARY || ', ' || E.EMP_NAME || ', ' ||
                         TO_CHAR(YSALARY, 'L999,999,999'));
END;
/

/*
    2. 구구단의 짝수단만 출력
        1) FOR LOOP
        2) WHILE LOOP
*/
-- 1) FOR LOOP
BEGIN
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN, 2) = 0
            THEN
                DBMS_OUTPUT.PUT_LINE('--- ' || DAN || '단 ---');
                FOR SU IN 1..9
                LOOP
                    DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN*SU);
                END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- 2) WHILE LOOP
DECLARE
    DAN NUMBER := 2;
    SU NUMBER;
BEGIN
    WHILE DAN <= 9
    LOOP
        SU := 1;
        WHILE SU <= 9
            LOOP
               DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || DAN*SU);
               SU := SU+1;
            END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        DAN := DAN+2;
    END LOOP;
END;
/






