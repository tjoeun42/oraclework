/*
    <트리거 TRIGGER>
    내가 지정한 테이블에 DML문에 의해 변경사항(이벤트)이 생겼을 때
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
    EX)
    회원탈퇴시 기존 회원테이블에서 삭제후 곧바로 탈퇴회원들만 보관하는 테이블에 자동으로 INSERT
    신고횟수가 일정수를 넘기면 묵시적으로 해당 회원을 블랙리스트 처리
    입출고에 대한 데이터가 기록(INSERT)할 때마다 해당 상품의 재고수량을 매번 수정(UPDATE)해야 될 때
    
    * 트리거의 종류
    - SQL문의 실행시기에 따른 분류
      > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
      > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생되기 후에 트리거 실행
      
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
      > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
      > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때 마다 매번 트리거 실행
                                (FOR EACH ROW 옵션을 기술해야함)
                                > :OLD - 기존컬럼에 들어 있던 데이터
                                > :NEW - 새로 들어온 데이터
                                
    * 트리거의 생성 구문
      [표현식]
      CREATE [OR REPLACE] TRIGGER 트리거명
      BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명
      [FOR EACH ROW]
      [DECLARE 변수선언;]
      BEGIN
        실행내용(지정된 이벤트가 발생되면 자동으로 실행할 구문)
      [EXCEPTION 예외처리구문;]
      END;
      /
    
    * 트리거의 삭제
      DROP TRIGGER 트리거명;
*/

SET SERVEROUT ON;

-- EMPLOYEE테이블에 새로운 행이 INSERT 될 때마다 자동으로 메시지 출력하는 트리거 정의
CREATE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '더조은', '050812-1234567', 'D5', 'J2', SYSDATE);


INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '김하나', '030812-2234567', 'D5', 'J5', SYSDATE);


-- 상품 입고 출고가 되면 재고수량이 변경되도록 하는 트리거
-- 테이블3개, 시퀀스 3개 생성

-- 1) 상품에 대한 데이터를 보관할 테이블(TB_PRODUCT)
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER PRIMARY KEY,       -- 상품번호
    PNAME VARCHAR2(30) NOT NULL,    -- 상품명
    BRAND VARCHAR2(30) NOT NULL,    -- 브랜드명
    STOCK_QUANT NUMBER DEFAULT 0    -- 재고수량
);

-- 상품번호에 넣을 시퀀스(SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플테이터 3개 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '폴드7', '삼성', DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰17', 'apple', 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '레드미노트14', '샤오미', 20);


-- 2) 입고테이블(TB_PROSTOCK)
CREATE TABLE TB_PROSTOCK(
    TCODE NUMBER PRIMARY KEY,           -- 입고번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품번호
    TDATE DATE DEFAULT SYSDATE,         -- 입고일
    STOCK_COUNT NUMBER NOT NULL,        -- 입고수량
    STOCK_PRICE NUMBER NOT NULL         -- 입고단가
);

-- 입고번호에 넣어줄 시퀀스
CREATE SEQUENCE SEQ_TCODE
NOCACHE;

-- 3) 판매테이블
CREATE TABLE TB_PROSALE(
    SCODE NUMBER PRIMARY KEY,           -- 판매번호
    PCODE NUMBER REFERENCES TB_PRODUCT, -- 상품번호
    SDATE DATE DEFAULT SYSDATE,         -- 판매일
    SALE_COUNT NUMBER NOT NULL,         -- 판매수량
    SALE_PRICE NUMBER NOT NULL          -- 판매단가
);

-- 판매번호에 넣을 시퀀스
CREATE SEQUENCE SEQ_SCODE
NOCACHE;

-- 200번 상품을 오늘날짜로 10개 입고
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 200, DEFAULT, 10, 1800000);
-- TB_PRODUCT테이블의 재고수량 10개 증가
UPDATE TB_PRODUCT
   SET STOCK_QUANT = STOCK_QUANT + 10
 WHERE PCODE = 200;  
COMMIT;

-- 210번 상품을 오늘날짜로 5개 출고
INSERT INTO TB_PROSALE
VALUES (SEQ_SCODE.NEXTVAL, 210, DEFAULT, 5, 400000); 
-- TB_PRODUCT테이블의 재고수량 5개 감소
UPDATE TB_PRODUCT
   SET STOCK_QUANT = STOCK_QUANT - 5
 WHERE PCODE = 210;  
COMMIT;

-- TB_PRODUCT테이블에 매번 자동으로 재고수량을 UPDATE하는 트리거 정의
-- TB_PROSTOCK 테이블에 입고(INSERT) 이벤트 발생한 후 UPDATE
/*
-- 트리거 정의시
UPDATE TB_PRODUCT
   SET STOCK_QUANT = STOCK_QUANT + INSERT된 자료의 STOCK_COUNT값
 WHERE PCODE = 입고된 상품번호(INSERT된 자료의 PCODE값); 
*/
CREATE TRIGGER TRG_STOCK
AFTER INSERT ON TB_PROSTOCK
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
       SET STOCK_QUANT = STOCK_QUANT + :NEW.STOCK_COUNT
     WHERE PCODE = :NEW.PCODE;
END;
/

-- 205번 상품이 오늘날짜로 5개 입고(기존10개)
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 205, DEFAULT, 5, 1700000);

-- 210번 상품이 오늘날짜로 100개 입고(기존15개)
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 210, DEFAULT, 100, 300000);


-- TB_PROSALE 테이블에 출고(INSERT) 이벤트 발생한 후 UPDATE
CREATE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
       SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
     WHERE PCODE = :NEW.PCODE;
END;
/

-- 200번 상품이 오늘날짜로 5개 출고(기존10개)
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, DEFAULT, 5, 2200000);

-- 210번 상품이 오늘날짜로 50개 출고(기존115개)
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 210, DEFAULT, 50, 400000);

-- TB_PROSALE 테이블에 출고(INSERT) 이벤트 발생한 후 UPDATE
-- 만약 재고수량이 부족하면 출고 안되게 트리거 정의
/*
    * 사용자 함수 예외처리
      RAISE_APPLECATION_ERROR([에러코드], [에러메시지])
      - 에러코드 : -20000 ~ -20999 사이의 코드
*/

CREATE OR REPLACE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW
DECLARE
    SCOUNT NUMBER; 
BEGIN
    SELECT STOCK_QUANT
      INTO SCOUNT
      FROM TB_PRODUCT
     WHERE PCODE = :NEW.PCODE; 

    IF(SCOUNT >= :NEW.SALE_COUNT)
        THEN
            UPDATE TB_PRODUCT
               SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
             WHERE PCODE = :NEW.PCODE;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, '재고수량 부족으로 판매할 수 없음');
    END IF;
END;
/

-- 200번 상품이 오늘날짜로 10개 출고(기존5개)
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, DEFAULT, 10, 2200000);

-- 210번 상품이 오늘날짜로 10개 출고(기존65개)
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 210, DEFAULT, 10, 400000);

-- TB_PROSTOCK 테이블에서 입고수량을 수정할 때 트리거
CREATE OR REPLACE TRIGGER TRG_PROUP
AFTER UPDATE ON TB_PROSTOCK
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
       SET STOCK_QUANT = STOCK_QUANT - :OLD.STOCK_COUNT + :NEW.STOCK_COUNT
     WHERE PCODE = :NEW.PCODE;
END;
/

UPDATE TB_PROSTOCK
   SET STOCK_COUNT = 10
 WHERE TCODE = 2; 

-- TB_PROSTOCK 테이블에서 삭제할 때 트리거
CREATE OR REPLACE TRIGGER TRG_PRODE
AFTER DELETE ON TB_PROSTOCK
FOR EACH ROW
BEGIN
    UPDATE TB_PRODUCT
       SET STOCK_QUANT = STOCK_QUANT - :OLD.STOCK_COUNT
     WHERE PCODE = :OLD.PCODE;
END;
/

DELETE FROM TB_PROSTOCK
WHERE TCODE = 2;