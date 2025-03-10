{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

SELECT 
    ts AS time_key,
    userId AS user_key,
    sessionId AS session_key,
    success,
    level,
    city,
    state
FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
;
