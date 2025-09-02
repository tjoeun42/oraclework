-- 한줄 주석 (ctrl + /)

/*
    여러줄 주석
    alt + shift + c
*/

-- 실행 단축키 : 한줄 실행 -> 커서를 그 줄에 놓고 ctrl + enter
--              여러행을 실행 -> 실행하고 싶은 줄을 블럭으로 잡고 ctrl + enter

-- 사용자 계정 조회
select * from dba_users;

-- 사용자 생성
-- 오라클 12버전부터 일반사용자는 c##으로 시작하는 이름을 가져야 함 

-- create user user1 identified by '1234';
create user c##user1 identified by 1234;

-- c##을 회피하는 방법
alter SESSION set "_oracle_script" = true;
create user user1 identified by 1234;

-- 사용자 계정 생성(관리자계정에서만 생성가능)
-- 계정명은 대소문자를 가리지 않음
-- [표현법] create user 계정명 identified by 비밀번호;
create user tjoeun identified by 1234;

-- 권한생성
-- [표현법] grant 권한1, 권한2, ... to 계정명;
grant CONNECT, RESOURCE to tjoeun;

-- 만약 RESOURCE로 테이블이 생성이 안되면
grant create table to tjoeun;
-- 만약 SEQUENCE가 생성이 안되면
grant create SEQUENCE to tjoeun;

-- 용량에 제한 없이 테이블스테이스 할당하는 경우
alter user tjoeun default TABLESPACE users quota unlimited on users;
-- or
alter user tjoeun quota unlimited on users;

-- 특정 용량만큼 테이블스테이스 할당하는 경우
alter user tjoeun quota 30M on users;

-- 일반적으로 사용자를 생성하려면
alter SESSION set "_oracle_script" = true;
create user 계정명 identified by 비밀번호;
grant CONNECT, RESOURCE to 계정명;
alter user 계정명 quota unlimited on users;

-- user 삭제
drop user ji CASCADE;  -- 테이블이 있을때는 cascade를 붙여준다

-- WORKBOOK 사용자를 생성
alter SESSION set "_oracle_script" = true;
create user workbook identified by 1234;
grant CONNECT, RESOURCE to workbook;
alter user workbook quota unlimited on users;

-- SCOTT 사용자를 생성
alter SESSION set "_oracle_script" = true;
create user scott identified by 1234;
grant CONNECT, RESOURCE to scott;
alter user scott quota unlimited on users;



