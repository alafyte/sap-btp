# Plain schema access 
https://community.sap.com/t5/technology-blog-posts-by-sap/cross-hdi-container-access-using-user-provided-service-for-containers/ba-p/13540097

## Plain schema creation
```sql
CREATE SCHEMA "PLAIN";
CREATE USER PLUSR PASSWORD "HanaRocks01" SET USERGROUP DEFAULT;
ALTER USER PLUSR DISABLE PASSWORD LIFETIME;

CREATE TABLE PLAIN.CUSTOMERS (
  CUSTOMER_ID NVARCHAR(10) PRIMARY KEY,
  NAME NVARCHAR(100),
  COUNTRY NVARCHAR(50)
);

CREATE TABLE PLAIN.ORDERS (
  ORDER_ID NVARCHAR(10) PRIMARY KEY,
  CUSTOMER_ID NVARCHAR(10),
  AMOUNT DECIMAL(10,2),
  CREATED_AT DATE
);

CREATE ROLE CCROLE;
grant SELECT, UPDATE, INSERT, DELETE, EXECUTE, SELECT METADATA ON SCHEMA "PLAIN" TO CCROLE with grant option;
grant CCROLE to PLUSR with admin option;

```

## User-Provided Grant Service Creation

```bash
cf cups PLAIN_ACCESS_GRANT -p "{\"user\":\"PLUSR\",\"password\":\"HanaRocks01\",\"tags\":[\"hana\"] , \"schema\" : \"PLAIN\" }"
```

> Note: the similar flow is applicable for the objects and users of HDI container deployed to a different CF space.

# Container to Container
https://community.sap.com/t5/technology-blog-posts-by-sap/working-with-cross-hdi-container-access-scenarios-in-sap-hana-cloud/ba-p/13539139

# Container to Container from a different HANA Cloud instance
https://community.sap.com/t5/technology-blog-posts-by-sap/cross-hdi-container-access-using-virtual-tables-for-containers-located-in/ba-p/13540215

# SAP CAP example
https://www.erpqna.com/how-to-share-tables-across-different-cap-projects/ 