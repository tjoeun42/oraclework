/*
    <시퀀스 SEQUENCE>
    자동으로 번호를 발생시켜주는 역할을 하는 객체
    정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글번호, ...
*/

/*
    1. 시퀀스 생성
    
    [표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]            -> 처음 발생시킬 시작값 지정(기본값 1)
    [INCREMENT BY 숫자]             -> 몇씩 증가시킬 것인지(기본값 1)
    [MAXVALUE 숫자]                 -> 최대값 지정
    [MINVALUE 숫자]                 -> 최소값 지정(기본값 1)
    [CYCLE | NOCYCLE]               -> 값 순환 여부 지정(기본값 NOCYCLE)
    [NOCACHE | CACHE 바이트크기]     -> 캐시 메모리 할당(기본값 CACHE 20)
    
    * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                  매번 호출될때마다 새롭게 번호를 생성하는게 아니라
                  캐시메모리에 미리 생성된 값들을 가져다 쓸 수 있음(속도가 빨라짐)
                  접속이 해제되면 => 캐시메모리에 미리 만들어 둔 번호들은 다 날라감
*/
-- 시퀀스 생성
CREATE SEQUENCE SEQ_TEST;

-- 옵션을 넣어 시퀀스 생성
CREATE SEQUENCE SEQ_EMPNO
START WITH 400
INCREMENT BY 5
MAXVALUE 410
NOCYCLE
NOCACHE;

/*
    2. 시퀀스 사용
    
    시퀀스명.CURRVAL : 현재 시퀀스의 값(마지막으로 성공적으로 수행된 NEXTVAL의 값)
    시퀀스명.NEXTVAL : 시퀀스값에 일정값을 증가시켜서 발생된 값
                      현재 시퀀스값에서 INCREMENT BY값 만큼 증가시킨 값
                      = 시퀀스명.CURRVAL + INCREMENT BY 값
*/
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- NEXTVAL를 단 한번도 수행하지 않은 이상 CURRVAL 할 수 없음
-- CURRVAL는 성공적으로 수행된 NEXTVAL의 값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 400
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 400
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 405
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 410

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 오류
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 410

/*
    3. 시퀀스 구조 변경
    
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]
    [MAXVALUE 숫자]
    [MINVALUE 숫자]
    [CYCLE | NOCYCLE]
    [CACHE | NOCACHE]
    
    ** START WITH는 변경 불가
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 500;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;  -- 410 + 10 = 420

-- 4. 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;

--------------------------------------------------------------------------------
-- 사원번호를 SEQUENCE로 생성
CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '김삼순', '051212-1234567', 'J7', SYSDATE);

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL, '이사순', '101212-1234567', 'J4', SYSDATE);