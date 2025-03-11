{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

SELECT 
    ts AS time_key,
    userId AS user_key,
    sessionId AS session_key,
    itemInSession,
    auth,
    MD5(CONCAT(city, state, zip, lon, lat)) AS location_id
FROM parquet.`hdfs://namenode:9000/data/bronze/status_change_events/`
;
