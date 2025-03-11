{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH session_data AS (
    SELECT DISTINCT
        sessionId,
        userAgent,
        level
    FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
    WHERE sessionId IS NOT NULL
)

SELECT * FROM session_data
