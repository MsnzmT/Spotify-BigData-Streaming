{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH songs AS (
    SELECT DISTINCT 
        song AS song_name,
        artist,
        duration
    FROM parquet.`hdfs://namenode:9000/data/bronze/listen_events/`
)
SELECT
    song_name,
    artist,
    duration
FROM songs
;
