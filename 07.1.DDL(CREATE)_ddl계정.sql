/*
    * DDL(Data Definition Language) : 데이터 정의 언어
      오라클에서 제공하는 객체를 만들고(CREATE), 구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
      즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
      주로 DB관리자, 설계자가 사용함
      
      오라클에서 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX), 
                            패키지(PACKAGE), 트리거(TRIGGER), 프로시져(PROCEDURE), 
                            함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
*/
--==============================================================================
/*
        <CREATE>
        객체를 생성하는 구문
*/
--------------------------------------------------------------------------------
/*
    1. 테이블 생성
       - 테이블 : 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
                 모든 데이터들은 테이블을 통해 저장됨
                 (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
                 
      [표현식]
      CREATE TABLE 테이블명 (
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형,
        ....
      );
      
      * 자료형
        - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기)) -> 반드시 크기지정 해야됨
          > CHAR : 최대 2000BYTE까지 지정 가능
                   고정길이(지정한 크기보다 더 적은값이 들어와도 공백으로 채워서 처음 지정한 크기만큼 고정)
                   고정된 데이터를 넣을 때 사용
          > VARCHAR2 : 최대 4000BYTE까지 지정 가능
                       가변길이(담긴 값에 따라 공간의 크기가 맞춰짐)
                       몇글자가 들어올지 모를 경우 사용
        - 숫자(NUMBER)
        - 날짜(DATE)
*/
-- 회원 정보를 담는 테이블 MEMBER생성
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR(13),
    EMAIL VARCHAR(50),
    MEM_DATE DATE
);

--------------------------------------------------------------------------------
/*
    2. 컬럼에 주석 달기(설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성하였을 경우 수정후 다시 실해하면 됨(덮어쓰기 됨)
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터를 추가시키는 구문
-- INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '김민준', '남', '010-1234-5678', 'kim@naver.com', '25/09/01');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '이서연', '여', null, null, sysdate);