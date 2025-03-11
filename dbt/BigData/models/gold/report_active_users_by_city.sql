{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH active_users AS (
    SELECT
        MD5(CONCAT(city, state)) AS location_id,
        city,  
        state,  
        COUNT(DISTINCT userId) AS active_users
    FROM {{ ref('fact_auth_events') }}
    WHERE sessionId IS NOT NULL
    GROUP BY city, state
)

SELECT * FROM active_users
ORDER BY active_users DESC

