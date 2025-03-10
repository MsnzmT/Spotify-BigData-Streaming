{{ config(
    materialized='table',
    location_root='hdfs://namenode:9000/data/silver/',
    file_format='parquet'
) }}

WITH all_timestamps AS (
    SELECT ts FROM parquet.`hdfs://namenode:9000/data/bronze/auth_events/`
    UNION ALL
    SELECT ts FROM parquet.`hdfs://namenode:9000/data/bronze/listen_events/`
    UNION ALL
    SELECT ts FROM parquet.`hdfs://namenode:9000/data/bronze/page_view_events/`
    UNION ALL
    SELECT ts FROM parquet.`hdfs://namenode:9000/data/bronze/status_change_events/`
)
SELECT DISTINCT
    ts AS time_key,
    from_unixtime(ts/1000) AS event_time,
    year(from_unixtime(ts/1000)) AS year,
    month(from_unixtime(ts/1000)) AS month,
    day(from_unixtime(ts/1000)) AS day,
    hour(from_unixtime(ts/1000)) AS hour,
    minute(from_unixtime(ts/1000)) AS minute,
    second(from_unixtime(ts/1000)) AS second
FROM all_timestamps
;
