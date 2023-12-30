DROP TABLE IF EXISTS INJURY_PER_COUNTY;

CREATE TABLE INJURY_PER_COUNTY(
  COUNTY TEXT,
  PRIMARY_CONTRIBUTING_FACTOR TEXT,
  COLLISION_COUNT INTEGER
);

INSERT INTO INJURY_PER_COUNTY(COUNTY, PRIMARY_CONTRIBUTING_FACTOR, COLLISION_COUNT)
SELECT COUNTY, PRIMARY_CONTRIBUTING_FACTOR, SUM(COLLISION_COUNT) AS COLLISION_COUNT
FROM (
    SELECT COUNTY, PRIMARY_CONTRIBUTING_FACTOR, COUNT(COLLISION_ID) AS COLLISION_COUNT
    FROM CONSOLIDATED
    WHERE PRIMARY_CONTRIBUTING_FACTOR IS NOT NULL
    GROUP BY COUNTY, PRIMARY_CONTRIBUTING_FACTOR
) AS INJURY_PER_COUNTY
GROUP BY COUNTY, PRIMARY_CONTRIBUTING_FACTOR
ORDER BY COLLISION_COUNT DESC
LIMIT 50;

SELECT * FROM INJURY_PER_COUNTY;

---------------------------------------------------------------------------------------------------
-- Top 10 categories:
DROP TABLE IF EXISTS TOP_10_CATEGORIES;

CREATE TABLE IF NOT EXISTS TOP_10_CATEGORIES (
  PRIMARY_CONTRIBUTING_FACTOR TEXT,
  COLLISION_COUNT INTEGER
);

INSERT INTO TOP_10_CATEGORIES (PRIMARY_CONTRIBUTING_FACTOR, COLLISION_COUNT)
SELECT PRIMARY_CONTRIBUTING_FACTOR, COUNT(COLLISION_ID) AS COLLISION_COUNT
FROM CONSOLIDATED
WHERE PRIMARY_CONTRIBUTING_FACTOR IS NOT NULL
GROUP BY PRIMARY_CONTRIBUTING_FACTOR
ORDER BY COLLISION_COUNT DESC
LIMIT 10;

SELECT * FROM TOP_10_CATEGORIES;
 ---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Top 10 categories:
DROP TABLE IF EXISTS TOP_10_CATEGORIES_PER_YEAR;

CREATE TABLE TOP_10_CATEGORIES_PER_YEAR(
    Year INTEGER,
    "Unspecified" INTEGER,
    "Driver Inattention/Distraction" INTEGER,
    "Failure to Yield Right-of-Way" INTEGER,
    "Following Too Closely" INTEGER,
    "Backing Unsafely" INTEGER,
    "Other Vehicular" INTEGER,
    "Passing or Lane Usage Improper" INTEGER,
    "Passing Too Closely" INTEGER,
    "Turning Improperly" INTEGER,
    "Unsafe Lane Changing" INTEGER,
    "Grand Total" INTEGER
);

INSERT INTO TOP_10_CATEGORIES_PER_YEAR(
    Year,
    "Unspecified",
    "Driver Inattention/Distraction",
    "Failure to Yield Right-of-Way",
    "Following Too Closely",
    "Backing Unsafely",
    "Other Vehicular",
    "Passing or Lane Usage Improper",
    "Passing Too Closely",
    "Turning Improperly",
    "Unsafe Lane Changing",
    "Grand Total"
)
SELECT 
    CAST(substr(CRASHDATE, 7) as int) AS Year,
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Unspecified' THEN 1 ELSE 0 END) AS "Unspecified",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Driver Inattention/Distraction' THEN 1 ELSE 0 END) AS "Driver Inattention/Distraction",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Failure to Yield Right-of-Way' THEN 1 ELSE 0 END) AS "Failure to Yield Right-of-Way",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Following Too Closely' THEN 1 ELSE 0 END) AS "Following Too Closely",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Backing Unsafely' THEN 1 ELSE 0 END) AS "Backing Unsafely",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Other Vehicular' THEN 1 ELSE 0 END) AS "Other Vehicular",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Passing or Lane Usage Improper' THEN 1 ELSE 0 END) AS "Passing or Lane Usage Improper",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Passing Too Closely' THEN 1 ELSE 0 END) AS "Passing Too Closely",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Turning Improperly' THEN 1 ELSE 0 END) AS "Turning Improperly",
    SUM(CASE WHEN PRIMARY_CONTRIBUTING_FACTOR = 'Unsafe Lane Changing' THEN 1 ELSE 0 END) AS "Unsafe Lane Changing",
    COUNT (*) AS "Grand Total"
FROM CONSOLIDATED
WHERE CAST(substr(CRASHDATE, 7) as int) IN (2019, 2020, 2021)
GROUP BY Year
;

SELECT * FROM TOP_10_CATEGORIES_PER_YEAR;
-----------------------------------------------------------------------------------------------------------------