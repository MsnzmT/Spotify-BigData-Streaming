CREATE TABLE report_songs_per_day_per_user
(
    userId UInt64,
    day Date,
    songs_listened UInt64
)
ENGINE = HDFS('hdfs://namenode:9000/data/gold/report_songs_per_day_per_user/', 'Parquet');


CREATE TABLE report_active_users_by_city
(
    location_id String,
    city String,
    state String,
    active_users UInt64
)
ENGINE = HDFS('hdfs://namenode:9000/data/gold/active_users/', 'Parquet');


CREATE TABLE avg_duration_per_day_hdfs
(
    weekday UInt32,
    avg_duration_per_day Float64,
    avg_listens_per_day Float64
)
ENGINE = HDFS('hdfs://namenode:9000/data/gold/avg_duration_per_day/', 'Parquet');


CREATE TABLE song_play_count_hdfs
(
    song_id String,
    artist String,
    song String,
    play_count UInt64
)
ENGINE = HDFS('hdfs://namenode:9000/data/gold/song_play_count/', 'Parquet');
