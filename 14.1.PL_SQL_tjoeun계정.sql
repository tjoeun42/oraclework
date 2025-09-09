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