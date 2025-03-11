{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH user_data AS (
    SELECT DISTINCT
        userId,
        firstName,
        lastName,
        gender,
        registration
    FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
    WHERE userId IS NOT NULL
)

SELECT * FROM user_data
