{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

SELECT 
    ts AS time_key,
    sessionId AS session_key,
    itemInSession,
    page,
    auth,
    method,
    status
    MD5(CONCAT(city, state, zip, lon, lat)) AS location_id
FROM parquet.`hdfs://namenode:9000/data/bronze/page_view_events/`
;
