{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/gold/',
    file_format='parquet'
) }}

WITH song_play_count AS (
    SELECT
        MD5(CONCAT(artist, song)) AS song_id,
        artist,
        song,
        COUNT(*) AS play_count
    FROM {{ ref('fact_listen_events') }}
    GROUP BY song_id, artist, song
)

SELECT * FROM song_play_count
ORDER BY play_count DESC
