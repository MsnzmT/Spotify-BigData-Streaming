{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH song_data AS (
    SELECT DISTINCT
        MD5(CONCAT(artist, song)) AS song_id,  -- Unique identifier
        artist,
        song,
        duration
    FROM parquet.`hdfs://namenode:9000/data/bronze/listen_events/`
    WHERE artist IS NOT NULL AND song IS NOT NULL
)

SELECT * FROM song_data