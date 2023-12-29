DROP TABLE IF EXISTS INJURY_PER_COUNTY_BY_VEHICLE_CATEGORY;

CREATE TABLE INJURY_PER_COUNTY_BY_VEHICLE_CATEGORY(
  COUNTY TEXT,
  VEHICLE_CATEGORY TEXT,
  COLLISION_COUNT INTEGER
);

INSERT INTO INJURY_PER_COUNTY_BY_VEHICLE_CATEGORY (COUNTY, VEHICLE_CATEGORY, COLLISION_COUNT)
SELECT COUNTY, VEHICLE_CATEGORY, SUM(COLLISION_COUNT) AS COLLISION_COUNT
FROM (
    SELECT COUNTY, VEHICLE_CATEGORY, COUNT(COLLISION_ID) AS COLLISION_COUNT
    FROM CONSOLIDATED
    WHERE PERSON_INJURY IS NOT NULL AND PERSON_INJURY != 'Unspecified'
    GROUP BY COUNTY, VEHICLE_CATEGORY
) AS INJURY_PER_COUNTY_BY_VEHICLE_CATEGORY
GROUP BY COUNTY, VEHICLE_CATEGORY

ORDER BY COLLISION_COUNT DESC;

SELECT * FROM INJURY_PER_COUNTY_BY_VEHICLE_CATEGORY;