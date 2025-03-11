{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH listen_data AS (
    SELECT
        userId,
        EXTRACT(DAYOFWEEK FROM TO_TIMESTAMP(ts)) AS weekday,
        SUM(duration) AS total_duration,
        COUNT(*) AS listen_count
    FROM {{ ref('fact_listen_events') }}
    GROUP BY userId, weekday
)

SELECT
    weekday,
    AVG(total_duration) AS avg_duration_per_day,
    AVG(listen_count) AS avg_listens_per_day
FROM listen_data
GROUP BY weekday
ORDER BY weekday
