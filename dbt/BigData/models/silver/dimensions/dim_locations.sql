{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH loc AS (
    SELECT DISTINCT 
        city,
        state,
        zip,
        lat,
        lon
    FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
    UNION
    SELECT DISTINCT 
        city,
        state,
        zip,
        lat,
        lon
    FROM parquet.`hdfs://namenode:9000/data/bronze/page_view_events/`
)
SELECT 
    /* 
       In Spark you might generate a unique key using a function such as monotonically_increasing_id(). 
       Adjust as needed if you have a better key generation method.
    */
    monotonically_increasing_id() AS location_key,
    city,
    state,
    zip,
    lat,
    lon
FROM loc
;
