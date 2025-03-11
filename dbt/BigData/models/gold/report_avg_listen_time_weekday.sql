{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH listen_data AS (
    SELECT
        f.userId,
        EXTRACT(DAYOFWEEK FROM TO_TIMESTAMP(f.time_key)) AS weekday,
        SUM(s.duration) AS total_duration,
        COUNT(*) AS listen_count
    FROM {{ ref('fact_listen_events') }} f
    JOIN {{ ref('dim_songs') }} s ON f.song_id = s.song_id
    GROUP BY f.userId, weekday
)

SELECT
    weekday,
    AVG(total_duration) AS avg_duration_per_day,
    AVG(listen_count) AS avg_listens_per_day
FROM listen_data
GROUP BY weekday
ORDER BY weekday;
