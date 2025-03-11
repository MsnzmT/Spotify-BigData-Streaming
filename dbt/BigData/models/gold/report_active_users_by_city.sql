{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH active_users AS (
    SELECT
        l.location_id,
        l.city,  
        l.state,  
        COUNT(DISTINCT f.user_key) AS active_users
    FROM {{ ref('fact_auth_events') }} f
    JOIN {{ ref('dim_locations') }} l ON f.location_id = l.location_id
    GROUP BY l.location_id, l.city, l.state
)

SELECT * FROM active_users
ORDER BY active_users DESC;

