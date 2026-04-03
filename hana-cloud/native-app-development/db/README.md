# Tables
https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/68554490aee94885ba31611489a04992.html

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/tables-hdbtable-and-hdbdropcreatetable

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d58a5f75191014b2fe92141b7df228.html?locale=en-US&state=PRODUCTION&version=2.0.08

# Table Data
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/table-data-hdbtabledata

https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/3530d1d3bb1a40ca831016dbf7c5a90f.html

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20f712e175191014907393741fadcb97.html?locale=en-US&state=PRODUCTION&version=2.0.08&q=constraint

# Constaints
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/constraints-hdbconstraint

## Usage Example
```sql
SELECT * FROM "com.sap.training.sales.core::sales_order_item" AS SALES_ORDER_ITEM WHERE
SALES_ORDER_ITEM.ORDER_ID = 5001;
```

# Indexes
https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/713e65a10d55404b9ac503bb7b4c735a.html?locale=en-US&version=2.0.08

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d4117e75191014ba5aaab91b3f087d.html?locale=en-US&state=PRODUCTION&version=2.0.08

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/9b79b31dde1b4f6d84144fba8d942bd3.html?locale=en-US&state=PRODUCTION&version=2.0.08

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d44b4175191014a940afff4b47c7ea.html?locale=en-US&state=PRODUCTION&version=2.0.08

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/indexes-hdbindex

# Sequences
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/sequences-hdbsequence

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d509277519101489029c064d468c5d.html?locale=en-US&state=PRODUCTION&version=2.0.08

## Usage Example
```sql
INSERT INTO "com.sap.training.sales.core::sales_order_item"
(ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, DISCOUNT)
VALUES ("com.sap.training.sales.core::item_id".NEXTVAL, 5001, 1001, 1, 1100.00, 10);
```

# Statistics
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/statistics-hdbstatistics

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d5252d7519101493f5e662a6cda4d4.html?locale=en-US&state=PRODUCTION&version=2.0.08&q=statistics

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20fae6d975191014849d91781fd50986.html?locale=en-US&state=PRODUCTION&version=2.0.08&q=statistics

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-sql-on-files-guide/statistics

# Triggers

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/triggers-hdbtrigger

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d5a65575191014946db96aaedbef5b.html?locale=en-US&state=PRODUCTION&version=2.0.08&q=trigger

## Usage Example
```sql
-- get current total amount for sales order #5001 
SELECT TOTAL_AMOUNT FROM "com.sap.training.sales.core::sales_order" WHERE ORDER_ID = 5001;

-- output: 2200.00

-- add a new sales item to the order: 2 products with price of 500 per unit and a 10% discount
-- the total should be 2200.00 + 2 * 500 * 0.9 = 3100.00
INSERT INTO "com.sap.training.sales.core::sales_order_item"
(ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE, DISCOUNT)
VALUES ("com.sap.training.sales.core::item_id".NEXTVAL, 5001, 1001, 2, 500.00, 10);

-- get updated total amount by trigger for sales order #5001 
SELECT TOTAL_AMOUNT FROM "com.sap.training.sales.core::sales_order" WHERE ORDER_ID = 5001;

-- output: 3100.00
```

# Application-Time Period Tables
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/application-time-period-tables-hdbapplicationtime

https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/2e37d6a82f7b48ccbfcc5a1a6ce490f5.html

## Usage Example
```sql
SELECT * FROM "com.sap.training.sales.core::product_price" WHERE PRODUCT_ID = 1001;

-- output: two intervals from January 1st 2024 to June 30th 2024 and July 1st 2024 to December 31st 9999

-- get the price for January 1st 2025 (falls to July 1st 2024 to December 31st 9999 period)
SELECT PRICE
FROM "com.sap.training.sales.core::product_price"
FOR APPLICATION_TIME AS OF DATE '2025-01-01' WHERE PRODUCT_ID = 1001;

-- output: 1100.00

-- change the price for the interval from March 1st 2024 to March 31st 2024
UPDATE "com.sap.training.sales.core::product_price"
FOR PORTION OF APPLICATION_TIME 
FROM DATE '2024-03-01' TO DATE '2024-03-31'
SET PRICE = 1150.00
WHERE PRODUCT_ID = 1001;

SELECT * FROM "com.sap.training.sales.core::product_price" WHERE PRODUCT_ID = 1001;

-- output: for intervals: January 1st 2024 to March 1st 2024, March 1st 2024 to March 31st 2024, March 31st 2024 to June 30th 2024, July 1st 2024 to December 31st 9999
```

# System Versionning

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/system-versioning-tables-hdbsystemversioning

https://help.sap.com/docs/SAP_HANA_PLATFORM/6b94445c94ae495c83a19646e7c3fd56/91302b26f62c4433bbc58e0a951cdc1d.html

## Usage Example
```sql
INSERT INTO "com.sap.training.sales.core::inventory"
(PRODUCT_ID, WAREHOUSE_ID, STOCK_QTY)
VALUES (1001, 'WH1', 100);

SELECT * FROM "com.sap.training.sales.core::inventory";
-- output: 1001, WH1, 100, 0, ..., ...
SELECT * FROM "com.sap.training.sales.core::inventory_history";
-- output: empty

UPDATE "com.sap.training.sales.core::inventory"
SET RESERVED_QTY = RESERVED_QTY + 2
WHERE PRODUCT_ID = 1001
  AND WAREHOUSE_ID = 'WH1';
  
SELECT * FROM "com.sap.training.sales.core::inventory";
-- output: 1001, WH1, 100, 2, ..., ...
SELECT * FROM "com.sap.training.sales.core::inventory_history";
-- output: 1001, WH1, 100, 0, ..., ...
  
UPDATE "com.sap.training.sales.core::inventory"
SET STOCK_QTY = STOCK_QTY - 2,
    RESERVED_QTY = RESERVED_QTY - 2
WHERE PRODUCT_ID = 1001
  AND WAREHOUSE_ID = 'WH1';
 
  
SELECT * FROM "com.sap.training.sales.core::inventory";
-- output: 1001, WH1, 98, 0, ..., ...
SELECT * FROM "com.sap.training.sales.core::inventory_history";
-- output row1: 1001, WH1, 100, 0, ..., ... ; 
-- output row2: 1001, WH1, 100, 2, ..., ...
```

## SQL Views
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/sql-views-hdbview

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/20d5fa9b75191014a33eee92692f1702.html

## Projection Views

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/projection-views-hdbprojectionview-and-hdbprojectionviewconfig

https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/e35411b417a94f199679b9f9f45c2306.html

## Calculation Views
https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/calculation-views-hdbcalculationview

## Result cache

https://help.sap.com/docs/hana-cloud-database/sap-hana-cloud-sap-hana-database-deployment-infrastructure-hdi-reference/result-caches-hdbresultcache


https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/3bc89515b93d4844bd700b3492673270.html?locale=en-US&state=PRODUCTION&version=LATEST&q=result+cache

See <cache_clause>:
https://help.sap.com/docs/SAP_HANA_PLATFORM/4fe29514fd584807ac9f2a04f6754767/9d274fa7e20d4841a6017e020d871aa0.html?locale=en-US&state=PRODUCTION&version=2.0.08&q=result%20cache