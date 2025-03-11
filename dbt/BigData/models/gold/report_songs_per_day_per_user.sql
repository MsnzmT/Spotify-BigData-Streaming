{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH song_data AS (
    SELECT
        f.userId,
        DATE_TRUNC('day', TO_TIMESTAMP(f.time_key)) AS day,
        COUNT(DISTINCT CONCAT(s.artist, s.song)) AS songs_listened
    FROM {{ ref('fact_listen_events') }} f
    JOIN {{ ref('dim_songs') }} s ON f.song_id = s.song_id
    GROUP BY f.userId, day
)

SELECT * FROM song_data;