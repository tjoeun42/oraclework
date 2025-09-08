/*
    * ALTER
      객체를 변경하는 구문
      
      [표현식]
      ALTER TABLE 테이블명 변경할내용;
      
      - 변경할 내용
        1) 컬럼 추가 / 수정 / 삭제
        2) 제약조건 추가 / 삭제 (수정불가 -> 삭제하고 다시 새로추가)
        3) 컬럼명 / 제약조건명 / 테이블명 변경
*/
--========================================================================
/*
    1. 컬럼 추가 / 수정 /삭제
       1) 컬럼 추가( ADD)
       
       [표현법]
       ADD 컬럼명 데이터타입 [DEFAULT 기본값]
*/
-- DEPT_COPY테이블에 CNAME(VARCHAR2(20))컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

-- DEPT_COPY테이블에 LNAME(VARCHAR2(20)) DEFAULT는 한국으로 컬럼 추가
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
--> 새로운 컬럼이 만들어지고 DEFAULT의 값으로 채워짐

--------------------------------------------------------------------------------
/*
    2) 컬럼의 이름 또는 데이터타입 수정 (MODIFY)
    
    [표현법]
    - 데이터타입 수정
      MODIFY 컬럼명 바꾸고자하는데이터타입
      
    - DEFAULT값 수정
      MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값
*/

-- DEPT_COPY테이블의 DEPT_ID의 데이터의 BYTE를 CHAR(3)으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

-- DEPT_COPY테이블의 DEPT_ID의 데이터타입을 NUMBER으로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
-- 오류 : 컬럼에 영문이 있음. 또한 컬럼의 데이터 타입을 변경할 때는 해당 컬럼의 값을 모두 지워야 변경가능함

-- DEPT_COPY테이블의 DEPT_TITLE의 데이터의 BYTE를 10BYTE로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
-- 오류 : 컬럼의 데이터값이 10BYTE가 넘는 데이터가 존재

-- DEPT_COPY테이블의 DEPT_TITLE컬럼을 VARCHAR2(40)로 변경
-- DEPT_COPY테이블의 LOCATION_ID컬럼을 VARCHAR2(2)로 변경
-- DEPT_COPY테이블의 LNAME의 DEFAULT값을 '미국'으로 변경

-- 다중 변경 가능
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';
    
--------------------------------------------------------------------------------
/*
    3) 컬럼 삭제
    
    [표현법]
    DROP COLUMN 컬럼명
*/

CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

-- DEPT_COPY2테이블에서 DEPT_ID컬럼 삭제
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

-- 컬럼 삭제는 다중 삭제 안됨
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME; 

ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME; -- 오류발생
--> 최소 한개의 컬럼은 존재해야됨

--========================================================================
/*
    2. 제약조건 추가 / 삭제
       1) 제약조건 추가
          ALTER TABLE 테이블명 추가(변경)할내용
            - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
            - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]
            - UNIQUE : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
            - CHECK : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한 조건식)
            - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
            
          --> 제약조건명을 지정하려면 : CONSTRAINT 제약조건명 제약조건
       2) 제약조건 삭제
          DROP CONSTRAINT 제약조건
          MODIFY 컬럼명 NULL | NOT NULL      
*/
-- DEPT_COPY테이블에서 DEPT_ID에 PRIMARY KEY 제약조건 추가
-- DEPT_COPY테이블에서 DEPT_TITLE의 값이 유일한 값이어야하는 제약조건 추가
-- DEPT_COPY테이블에서 LNAME의 값이 NULL을 가질수 없다

ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY (DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 제약조건 DCOPY_PK 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY MODIFY LNAME NULL;

--========================================================================
/*
    3. 컬럼명 / 제약조건명 / 테이블명 변경
       1) 컬럼명 변경
          [표현법]
          RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
*/
-- DEPT_COPY테이블의 DEPT_TITLE을 DEPT_NAME으로 컬럼명 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

/*
       2) 제약조건명 변경
          [표현법]
          RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
*/
-- DEPT_COPY테이블의 DCOPY_UQ제약조건명을 DCOPY_UNIQUE로 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT DCOPY_UQ TO DCOPY_UNIQUE;

/*
       3) 테이블명 변경
          [표현법]
          RENAME [기존테이블명] TO 바꿀테이블명
*/
ALTER TABLE DEPT_COPY RENAME TO DEPT_CHANGE;

--========================================================================
/*
    4. 테이블 삭제
*/
DROP TABLE DEPT_CHANGE;

/*
    - 테이블 삭제시 외래키의 부모테이블은 삭제 안됨
      그래도 삭제하고 싶다면
      * 방법1 : 자식테이블 먼저 삭제한 후 부모테이블 삭제
      * 방법2 : 부모테이블만 삭제하는데 제약조건을 같이 삭제
                DROP TABLE 부모테이블명 CASCADE CONSTRAINT;
*/