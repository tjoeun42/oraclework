/*
    <DCL : DATA CONTROL LANGUAGE>
    데이터 제어 언어
    
    * 계정에 시스템권한 또는 객체접근권한등을 부여(GRANT)하거나 회수(REVOKE)하는 구문
      > 시스템 권한 : DB에 접근하는 권한, 객체를 생성할 수 있는 권한
      > 객체 접근 권한 : 특정 객체를 조작할 수 있는 권한
      
    * 시스템 권한의 종류
      - CREATE SESSION : 접속할 수 있는 권한
      - CREATE TABLE : 테이블을 생성할 수 있는 권한
      - CREATE VIEW : 뷰를 생성할 수 있는 권한
      - CREATE SEQUENCE : 시퀀스를 생성할 수 있는 권한
        ...
*/
-- 1. SAMPLE 사용자 계정 생성
ALTER SESSION SET "_oracle_script" = true;
CREATE USER SAMPLE IDENTIFIED BY 1234;
-- 접속시 오류 접속권한 없음

-- 2. 접속권한 부여
GRANT CREATE SESSION TO SAMPLE;
-- sample에 접속하여 테이블 생성시 오류

-- 3. 테이블을 생성할 수 있는 권한
GRANT CREATE TABLE TO SAMPLE;
-- SAMPLE계정에서 테이블은 생성되지만 INSERT는 안됨

-- 4. TABLESPACE 할당
ALTER USER SAMPLE QUOTA UNLIMITED ON USERS;
-- OR
ALTER USER SAMPLE QUOTA 5M ON USERS;

-------------------------------------------------------------------------------
/*
    * 객체 접근 권한 종류
      특정 객체에 접근해 조작할 수 있는 권한
      
      권한 종류
      SELECT        TABLE, VIEW, SEQUENCE
      INSERT        TABLE, VIEW
      UPDATE        TABLE, VIEW
      DELETE        TABLE, VIEW
      ...
      
      [표현식]
      GRANT 권한종류 ON 특정객체 TO 계정명;
      - GRANT 권한종류 ON 권한을 가지고 있는 USER.특정객체 TO 권한을 줄 USER;
*/
-- SAMPLE계정에게 TJOEUN계정의 EMPLOYEE을 SELECT 할 수 있는 권한
GRANT SELECT ON TJOEUN.EMPLOYEE TO SAMPLE;

-- SAMPLE계정에게 TJOEUN계정의 DEPARTMENT테이블에 INSERT할 수 있는 권한
GRANT INSERT ON TJOEUN.DEPARTMENT TO SAMPLE;

GRANT SELECT ON TJOEUN.DEPARTMENT TO SAMPLE;

-------------------------------------------------------------------------------
/*
    * 권한 회수
      REVOKE 회수할권한 ON FROM 계정명;
*/
REVOKE SELECT ON TJOEUN.EMPLOYEE FROM SAMPLE;
REVOKE SELECT ON TJOEUN.DEPARTMENT FROM SAMPLE;
REVOKE INSERT ON TJOEUN.DEPARTMENT FROM SAMPLE;

--==============================================================================
/*
    <ROLE>
    특정 권한들을 하나의 집합으로 모아놓은것
    
    CONNECT : CREATE, SESSION
    RESOURCE : CREATE TABLE, CREATE VIEW, CREATE SEQUENCE ....
    DBA : 시스템 및 객체 관리에 대한 모든 권한을 갖고있는 롤
    
    - 23ai 버전에서 신규의 롤 추가
    DB_DEVELOPER_ROLE : CONNECT + RESOURCE + 기타 개발 관련 권한까지 포함
    
    [표현식]
    GRANT CONNECT, RESOURCE TO 계정명;
    GRANT DB_DEVELOPER_ROLE TO 계정명;
*/

CREATE USER TEST20 IDENTIFIED BY 1234;
GRANT DB_DEVELOPER_ROLE TO TEST20;
ALTER USER TEST20 QUOTA UNLIMITED ON USERS;

-- 테이블 ROLE_SYS_PRIVS에 ROLE이 정의되어 있음
SELECT * FROM ROLE_SYS_PRIVS;

SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE';