{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH location_data AS (
    SELECT DISTINCT
        MD5(CONCAT(city, state, zip, lon, lat)) AS location_id,
        city,
        state,
        zip,
        lon,
        lat
    FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
)

SELECT * FROM location_data