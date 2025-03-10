{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH auth_users AS (
    SELECT DISTINCT 
        userId AS user_key,
        firstName AS first_name,
        lastName AS last_name,
        gender,
        level,
        from_unixtime(registration/1000) AS registration_date,
        city,
        state
    FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
),
status_users AS (
    SELECT DISTINCT 
        userId AS user_key,
        firstName AS first_name,
        lastName AS last_name,
        gender,
        level,
        from_unixtime(registration/1000) AS registration_date,
        city,
        state
    FROM parquet.`hdfs://namenode:9000/data/bronze/status_change_events/`
    WHERE userId IS NOT NULL
)

-- Combine the two sources (if duplicate rows occur, UNION will remove them)
SELECT * FROM auth_users
UNION
SELECT * FROM status_users
;
