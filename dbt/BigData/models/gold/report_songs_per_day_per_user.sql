{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH song_data AS (
    SELECT
        userId,
        DATE_TRUNC('day', TO_TIMESTAMP(ts)) AS day,
        COUNT(DISTINCT CONCAT(artist, song)) AS songs_listened
    FROM {{ ref('fact_listen_events') }}
    GROUP BY userId, day
)

SELECT * FROM song_data