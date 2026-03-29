SELECT *
FROM "com.sap.training.sales.core::product_price"
FOR APPLICATION_TIME AS OF DATE '2025-01-01'; -- order date

SELECT * FROM "com.sap.training.sales.core::sales_order_item" AS SALES_ORDER_ITEM WHERE
SALES_ORDER_ITEM.ORDER_ID = 5001;

INSERT INTO "com.sap.training.sales.core::sales_order_item"
(ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, DISCOUNT, LINE_TOTAL)
VALUES ("com.sap.training.sales.core::item_id".NEXTVAL, 5001, 1001, 1, 1100.00, 0, 1100.00);