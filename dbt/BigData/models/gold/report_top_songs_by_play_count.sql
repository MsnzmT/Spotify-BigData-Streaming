{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH song_play_count AS (
    SELECT
        f.song_id,
        s.artist,
        s.song,
        COUNT(*) AS play_count
    FROM {{ ref('fact_listen_events') }} f
    JOIN {{ ref('dim_songs') }} s ON f.song_id = s.song_id
    GROUP BY f.song_id, s.artist, s.song
)

SELECT * FROM song_play_count
ORDER BY play_count DESC;
