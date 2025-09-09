/*
    < TCL : TRANSACTION CONTROL LANGUAGE >
    트랜젝션 제어언어
    
    * 트랜잭션
      - 데이터베이스의 논리적 연산단위
      - 데이터의 변경사항(DML)들을 하나의 트랜젝션에 묶어서 처리
        DML문 한개를 수행 할 때 트랜젝션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                              트랜잭션이 없다면 트랜잭션을 만들어서 묶어서 처리
        COMMIT하기전까지의 변경사항을 하나의 트랙잭션에 담게 됨
      - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE 
      
    > COMMIT : 트랜잭션 종료 처리 후 확정
               한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미(그 후에 트랜잭션은 사라짐) 
    > ROLLBACK : 트랜잭션 취소
                 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소) 한 후 마지막 COMMIT시점으로 돌아감 
    > SAVEPOINT : 임시저장
                  현재 시점에 해당 포인트명으로 임시저장점을 정의해두는것
                  ROLLBACK 진행시 전체 변경사항들을 다 삭제하는게 아니라 일부만 롤백가능  
*/
-- 사번이 301번인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 301;

-- 사번이 218번인 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 218;

ROLLBACK;  -- 트랜잭션에 들어있던 301번과 218번의 삭제가 취소 됨(트랜잭션이 사라짐)

--------------------------------------------------------------------------------
-- 사번이 200번이 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 200;

SELECT * FROM EMP_01 ORDER BY EMP_ID;

INSERT INTO EMP_01
VALUES (400, '김자격', '총무부'); 

COMMIT;

ROLLBACK;

--------------------------------------------------------------------------------
-- 217, 216, 214 사원 지움
DELETE FROM EMP_01
WHERE EMP_ID IN (217, 216, 214);

-- 임시 저장점 만들기
SAVEPOINT SP;

SELECT *
FROM EMP_01;

INSERT INTO EMP_01
VALUES(401, '박세종' , '인사관리부');

ROLLBACK TO SP;

COMMIT;

SELECT *
FROM EMP_01 ORDER BY EMP_ID;

-----------------------------------------------------------
/*
    * 자동 COMMIT되는 경우
      - 정상 종료
      - DCL과 DDL명령문이 수행된 경우
    
    * 자동 ROLLBACK되는 경우
      - 비정상 종료
      - 전원이 꺼짐. 정전, 컴퓨터 DOWN
*/
-- 사번이 301번과 400번 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (301, 400);

DELETE FROM EMP_01
WHERE EMP_ID = 300;

-- DDL문
CREATE TABLE TEST (
    TID NUMBER
);  -- 트랜잭션의 모든 내용은 자동 COMMIT됨

ROLLBACK; -- 소용없음