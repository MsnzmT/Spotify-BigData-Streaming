{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

SELECT 
    ts AS time_key,
    userId AS user_key,
    sessionId AS session_key,
    song AS song_name,
    duration,
    level
FROM parquet.`hdfs://namenode:9000/data/bronze/listen_events/`
;
