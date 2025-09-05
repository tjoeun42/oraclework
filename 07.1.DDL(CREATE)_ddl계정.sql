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

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--------------------------------------------------------------------------------
/*
    <제약 조건 CONSTRAINTS>
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다
      : 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
      1) 개체 무결성 제약 조건 : NOT NULL, UNIQUE, PRIMARY KEY 조건 위배
      2) 참조 무결성 제약 조건 : FOREIGN KEY(외래키) 조건 위배
      
    * 종류 : NOT NULL, UNIQUE, PRIMARY KEY, CHECK(조건), FOREIGN KEY  
    
    * 제약조건을 부여하는 방식 2가지
      1) 컬럼 레벨 방식 : 컬럼명 자료형 옆에 기술
      2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 수 마지막에 기술
*/


/*
    * NOT NULL 제약조건
     : 해당 컬럼에 반드시 값이 존재해야만 할 경우(즉, 해당 컬럼에 절대 NULL이 들어와서는 안되는 경우)
       삽입 / 수정시 NULL값을 허용하지 않도록 제한
     
      ** 주의사항 : 오로지 컬럼레벨 방식 밖에 안됨
*/
-- 컬럼 레벨 방식 
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass01', '임지아', '여', null, null);
INSERT INTO MEM_NOTNULL VALUES(2, 'user02', null, '백승민', '남', null, 'abc@google.com');
-- NOT NULL 제약조건 위반으로 오류 발생

INSERT INTO MEM_NOTNULL VALUES(2, 'user01', 'pas02', '백승민', '남', null, 'abc@google.com');
-- ID가 중복되어도 잘 추가됨

--------------------------------------------------------------------------------
/*
    * UNIQUE 제약 조건
      해당 컬럼에 중복된 값이 들어가서는 안 되는 경우
      컬럼값에 중복값을 제한하는 제약조건
      삽입 / 수정시 기존에 있는 데이터 중 중복값이 있을 경우 오류 발생
*/
-- 컬럼 레벨 방식
CREATE TABLE MEM_UNIQUE (
    MEM_NO NUMBER NOT NULL UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

-- 테이블 레벨 방식
-- MEM_UNIQUE2  => MEM_ID에 UNIQUE
CREATE TABLE MEM_UNIQUE2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_ID)
);
INSERT INTO MEM_UNIQUE2 VALUES(1, 'user01', 'pass01', '강하영',null,null,null); 
INSERT INTO MEM_UNIQUE2 VALUES(2, 'user01', 'pass02', '백승민',null,null,null);
-- UNIQUE 제약조건 위배 되므로 INSERT 실패


-- MEM_UNIQUE3  => MEM_ID에 UNIQUE, MEM_NO에 UNIQUE
CREATE TABLE MEM_UNIQUE3 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),
    UNIQUE (MEM_ID)
);
INSERT INTO MEM_UNIQUE3 VALUES(1, 'user01', 'pass01', '강하영',null,null,null);
INSERT INTO MEM_UNIQUE3 VALUES(2, 'user01', 'pass02', '백승민',null,null,null);
-- MEM_ID의 UNIQUE제약조건 위배
INSERT INTO MEM_UNIQUE3 VALUES(1, 'user02', 'pass02', '백승민',null,null,null);
-- MEM_NO의 UNIQUE제약조건 위배


-- MEM_UNIQUE4  => MEM_ID와 MEM_NO에(조합으로) UNIQUE
CREATE TABLE MEM_UNIQUE4 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO, MEM_ID)
);

INSERT INTO MEM_UNIQUE4 VALUES(1, 'user01', 'pass01', '강하영',null,null,null);
INSERT INTO MEM_UNIQUE4 VALUES(2, 'user01', 'pass02', '백승민',null,null,null);
INSERT INTO MEM_UNIQUE4 VALUES(2, 'user02', 'pass03', '이시우',null,null,null);
INSERT INTO MEM_UNIQUE4 VALUES(2, 'user02', 'pass04', '김강철',null,null,null);

--------------------------------------------------------------------------------
/*
    * 제약 조건 부여시 제약조건명까지 지어주는 방법
    
    >> 컬럼 레벨 방식
       CRATE TABLE 테이블명 (
            컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
            컬럼명 자료형
            ...
       );
       
    >> 테이블 레벨 방식
       CRATE TABLE 테이블명(
            컬럼명 자료형,
            컬럼명 자료형,
            ...
            [CONSTRAINT 제약조건명] 제약조건 (컬럼)
       );
*/