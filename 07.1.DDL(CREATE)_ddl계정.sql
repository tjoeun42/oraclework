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
CREATE TABLE MEM_UNIQUE5 (
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE (MEM_ID)
);

INSERT INTO MEM_UNIQUE5 VALUES(1, 'user01', 'pass01', '배지민',null,null,null);
INSERT INTO MEM_UNIQUE5 VALUES(2, 'user01', 'pass01', '강하영',null,null,null);

INSERT INTO MEM_UNIQUE5 VALUES(3, 'user03', 'pass03', '김하윤', 'ㄴ',null,null);
--  성별이 남, 여 둘 중 하나만 유효한 데이터로 하고 싶을 때

--------------------------------------------------------------------------------
/*
    * CHECK(조건식) 제약조건
      해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해 둘 수 있다.
      해당 조건에 만족하는 데이터값만 입력하도록 할 수 있다
*/

CREATE TABLE MEM_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    -- GENDER CHAR(3) CHECK(GENDER IN ('남', '여'))  -- 컬럼 레벨 방식
    PHONE VARCHAR(13),
    EMAIL VARCHAR(50),
    UNIQUE (MEM_ID),
    CHECK(GENDER IN ('남' ,'여'))     -- 테이블 레벨 방식
);

INSERT INTO MEM_CHECK VALUES(1, 'user01', 'pass01', '배지민', '여', null,null);
INSERT INTO MEM_CHECK VALUES(2, 'user02', 'pass02', '한유준', 'ㄴ', null,null); -- CHECK제약조건 위반
INSERT INTO MEM_CHECK VALUES(2, 'user02', 'pass02', '한유준', NULL, null,null); -- INSERT 됨

--------------------------------------------------------------------------------
/*
    * PRIMARY KEY(기본키) 제약조건
      테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
      EX) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장번호
      
      - PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건을 의미
        >> 대체적으로 검색, 삭제, 수정 등에 기본키의 컬럼값을 이용함
        
        ** 주의사항 : 한 테이블당 오로지 1개만 설정가능
*/

CREATE TABLE MEM_PRIKEY(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,  -- 컬럼 레벨 방식
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
    -- , PRIMARY KEY(MEM_NO)   -- 테이블 레벨 방식
    -- , CONSTRAINT MEMNO_PK PRIMARY KEY (MEM_NO)  -- 테이블레벨방식 제약조건 이름 부여
);

INSERT INTO MEM_PRIKEY VALUES(1, 'user01', 'pass01', '배지민', '여', null,null);
INSERT INTO MEM_PRIKEY VALUES(1, 'user02', 'pass02', '한유준', '남', null,null); 
INSERT INTO MEM_PRIKEY VALUES(2, 'user02', 'pass02', '한유준', NULL, null,null);

--------------------------------------------------------------------------------
/*
    * 복합키
      : 기본키에 2개 이상의 컬럼을 묶어서 사용
      
    - 복합키의 사용 예(한 회원이 어떤 상품을 찜했는지 데이터를 보관하는 테이블)
      회원번호,  상품
         1,      A
         1,      B
         1,      A      -- 부적합
         2,      A
         2,      B
         2,      B      -- 부적합
*/

CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, 'B', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);   -- 복합키 오류

--------------------------------------------------------------------------------
-- 회원 등급에 대한 데이터를 보관하는 테이블
CREATE TABLE MEM_GRADE (
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER     -- 회원등급을 보관할 컬럼
);

INSERT INTO MEM VALUES(1, 'user01', 'pass01', '박강남', '남', null, null, 10);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '유희영', '여', null, null, null);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '송나들', '남', null, null, 50);
-- 유효한 회원등급이 아님에도 insert됨

--------------------------------------------------------------------------------
/*
    * FOREIGN KEY(외래키) 제약조건
      다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
      --> 다른 테이블을 참조한다는 표현
      --> 주로 FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성됨
      
      >> 컬럼 레벨 방식
         -- 컬럼명 자료형 REFERENCES 참조할테이블명(참조할컬럼명)
            컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(참조할컬럼명)]

      >> 테이블 레벨 방식
         -- FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명(참조할컬럼명)
            [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]
            
      ==> 참조할 컬럼명을 생략시 참조할테이블의 PRIMARY KEY로 지정된 컬럼으로 매칭      
*/
CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)  -- 컬럼레벨방식
    -- GRADE_ID NUMBER REFERENCES MEM_GRADE  -- 컬럼레벨방식 PRIMARY KEY이면 생략가능

    /* 테이블 레벨 방식  
    GRADE_ID NUMBER,
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE
    */
);
INSERT INTO MEM2 VALUES(1, 'user01', 'pas01', '배정남', '남', null, null, null);
INSERT INTO MEM2 VALUES(2, 'user02', 'pas02', '여정운', '여', null, null, 30);
INSERT INTO MEM2 VALUES(3, 'user03', 'pas03', '김똥개', '남', null, null, 70);
-- MEM_GRADE(부모테이블)  -|-------<-  MEM2(자식테이블)

--> 이때 부모테이블에서 데이터값을 삭제할 경우 문제 발생
/*
    - 자식 테이블이 부모의 데이터값을 사용하지 않고 있으면 삭제 가능
    - 자식 테이블이 부모의 데이터값을 사용하고 있을 때 문제 발생 -> 삭제 불가
*/

-- MEM_GRADE테이블에서 30번 삭제
-- 삭제시 : DELETE FROM 테이블명; --> 테이블안의 모든 데이터 삭제
--         DELETE FROM 테이블명 WHERE 조건;  --> 조건에 맞는 행만 삭제
DELETE FROM MEM_GRADE 
 WHERE GRADE_CODE = 10;  --> 삭제됨
 
DELETE FROM MEM_GRADE 
 WHERE GRADE_CODE = 30; --> 오류: 자식테이블에서 사용하고 있음
 
-- 부모테이블로 부터 무조건 삭제가 안되는 삭제제한 옵션이 걸려있음(기본값)
INSERT INTO MEM_GRADE VALUES(10, '일반회원');

--------------------------------------------------------------------------------
/*
    * 자식테이블 생성시 외래키 제약조선 부여할 때 삭제옵션 지정가능
      - 삭제 옵션 : 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리할 지
      
      > ON DELETE RESTRICTED(기본값) : 삭제 제한 옵션. 자식테이블을 사용하고 있으면 부모테이블의 데이터는 삭제 안됨
      > ON DELETE SET NULL : 부모 데이터 삭제시 자식테이블의 값을 NULL로 변경하고 부모데이터 삭제.
      > ON DELETE CASCADE : 부모 데이터 삭제시 자식테이블도 같이 삭제(행 삭제).
*/
DROP TABLE MEM;
DROP TABLE MEM2;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'user01', 'pas01', '배정남', '남', null, null, 10);
INSERT INTO MEM VALUES(2, 'user02', 'pas02', '여정운', '여', null, null, 20);
INSERT INTO MEM VALUES(3, 'user03', 'pas03', '김똥개', '남', null, null, 30);
INSERT INTO MEM VALUES(4, 'user04', 'pas04', '이똥개', '여', null, null, 10);

DELETE FROM MEM_GRADE
 WHERE GRADE_CODE = 10;
-- 삭제됨 자식데이터값은 NULL

INSERT INTO MEM_GRADE VALUES(10, '일반회원');

CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);

INSERT INTO MEM2 VALUES(1, 'user01', 'pas01', '배정남', '남', null, null, 10);
INSERT INTO MEM2 VALUES(2, 'user02', 'pas02', '여정운', '여', null, null, 20);
INSERT INTO MEM2 VALUES(3, 'user03', 'pas03', '김똥개', '남', null, null, 30);
INSERT INTO MEM2 VALUES(4, 'user04', 'pas04', '이똥개', '여', null, null, 10);

DELETE FROM MEM_GRADE
 WHERE GRADE_CODE = 10;
-- 삭제됨. 자식도 같이 삭제됨 
 
--------------------------------------------------------------------------------
/*
    <DEFAULT 기본값>
    컬럼을 선정하지 INSERT시 NULL이 아닌 기본값을 INSERT 할 때
    
    컬럼명 자료형 DEFAULT 기본값 [제약조건]
    --> 제약조건보다 앞에 기술
*/

CREATE TABLE MEMBER2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE
);
 