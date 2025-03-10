{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

SELECT 
    ts AS time_key,
    sessionId AS session_key,
    page,
    auth,
    method,
    status
FROM parquet.`hdfs://namenode:9000/data/bronze/page_view_events/`
;
