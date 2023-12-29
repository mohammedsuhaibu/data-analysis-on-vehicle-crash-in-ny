-- making the new table
DROP TABLE IF EXISTS CRASH_1NF; 
SELECT CRASHDATE, CRASHTIME, substr(CRASHDATE, 7) || '-' || substr(CRASHDATE, 1, 2) || '-' || substr(CRASHDATE, 4, 2) || ' ' || 
                    case length(CRASHTIME)
                       when 1 then '0' || CRASHTIME || ':00'
                       when 2 then CRASHTIME || ':00'
                       when 3 then substr(CRASHTIME, 1, 1) || ':' || substr(CRASHTIME, 2) || ':00'
					   when 4 then '0' || substr(CRASHTIME, 1, 1) || substr(CRASHTIME, 2) || ':00'
                       else substr(CRASHTIME, 1, 2)  || substr(CRASHTIME, 3) || ':00'
                    end  date1 from CRASH_0NF WHERE CRASHDATE IS NOT NULL AND CRASHTIME IS NOT NULL limit 100;
 

CREATE TABLE CRASH_1NF (
  COLLISION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
  CRASHDATE DATE,
  CRASHTIME TIME,
  CRASHDATETIME DATETIME,
  BOROUGH TEXT,
  COUNTY TEXT,
  STATE TEXT,
  ZIPCODE TEXT,
  LATITUDE REAL,
  LONGITUDE REAL
);

INSERT INTO CRASH_1NF (
  COLLISION_ID, 
  CRASHDATE,
  CRASHTIME,
  CRASHDATETIME,
  BOROUGH, 
  COUNTY, 
  STATE, 
  ZIPCODE, 
  LATITUDE, 
  LONGITUDE
)

SELECT 
  COLLISION_ID,
  CRASHDATE,
  CRASHTIME,
   (substr(CRASHDATE, 7) || '-' || substr(CRASHDATE, 1, 2) || '-' || substr(CRASHDATE, 4, 2) || ' ' || 
                    case length(CRASHTIME)
                       when 1 then '0' || CRASHTIME || ':00'
                       when 2 then CRASHTIME || ':00'
                       when 3 then substr(CRASHTIME, 1, 1) || ':' || substr(CRASHTIME, 2) || ':00'
					   when 4 then '0' || substr(CRASHTIME, 1, 1) || substr(CRASHTIME, 2) || ':00'
                       else substr(CRASHTIME, 1, 2)  || substr(CRASHTIME, 3) || ':00'
                    end),
  BOROUGH,
  case BOROUGH
    when 'BRONX' then 'Bronx'
    when 'BROOKLYN' then 'Kings'
    when 'MANHATTAN' then 'New York'
    when 'QUEENS' then 'Queens'
    when 'STATEN ISLAND' then 'Richmond'
    else NULL
  end,
  'NY',
  ZIPCODE,
  LATITUDE,
  LONGITUDE
FROM 
 CRASH_0NF
WHERE 
    (substr(CRASHDATE, 7) || '-' || substr(CRASHDATE, 1, 2) || '-' || substr(CRASHDATE, 4, 2) || ' ' || 
                    case length(CRASHTIME)
                       when 1 then '0' || CRASHTIME || ':00'
                       when 2 then CRASHTIME || ':00'
                       when 3 then substr(CRASHTIME, 1, 1) || ':' || substr(CRASHTIME, 2) || ':00'
					   when 4 then '0' || substr(CRASHTIME, 1, 1) || substr(CRASHTIME, 2) || ':00'
                       else substr(CRASHTIME, 1, 2)  || substr(CRASHTIME, 3) || ':00'
                    end) >= '2019-01-01 00:00:00'
  AND BOROUGH IS NOT NULL;

  