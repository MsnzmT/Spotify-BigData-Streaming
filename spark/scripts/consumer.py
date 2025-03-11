from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StructField, StringType, LongType, DoubleType, BooleanType

auth_events_schema = StructType([
    StructField("ts", LongType(), True),
    StructField("sessionId", LongType(), True),
    StructField("level", StringType(), True),
    StructField("itemInSession", LongType(), True),
    StructField("city", StringType(), True),
    StructField("zip", StringType(), True),
    StructField("state", StringType(), True),
    StructField("userAgent", StringType(), True),
    StructField("lon", DoubleType(), True),
    StructField("lat", DoubleType(), True),
    StructField("userId", LongType(), True),
    StructField("lastName", StringType(), True),
    StructField("firstName", StringType(), True),
    StructField("gender", StringType(), True),
    StructField("registration", LongType(), True),
    StructField("success", BooleanType(), True)
])

listen_events_schema = StructType([
    StructField("artist", StringType(), True),
    StructField("song", StringType(), True),
    StructField("duration", DoubleType(), True),
    StructField("ts", LongType(), True),
    StructField("sessionId", LongType(), True),
    StructField("auth", StringType(), True),
    StructField("level", StringType(), True),
    StructField("itemInSession", LongType(), True),
    StructField("city", StringType(), True),
    StructField("zip", StringType(), True),
    StructField("state", StringType(), True),
    StructField("userAgent", StringType(), True),
    StructField("lon", DoubleType(), True),
    StructField("lat", DoubleType(), True),
    StructField("userId", LongType(), True),
    StructField("lastName", StringType(), True),
    StructField("firstName", StringType(), True),
    StructField("gender", StringType(), True),
    StructField("registration", LongType(), True)
])

page_view_events_schema = StructType([
    StructField("ts", LongType(), True),
    StructField("sessionId", LongType(), True),
    StructField("page", StringType(), True),
    StructField("auth", StringType(), True),
    StructField("method", StringType(), True),
    StructField("status", LongType(), True),
    StructField("level", StringType(), True),
    StructField("itemInSession", LongType(), True),
    StructField("city", StringType(), True),
    StructField("zip", StringType(), True),
    StructField("state", StringType(), True),
    StructField("userAgent", StringType(), True),
    StructField("lon", DoubleType(), True),
    StructField("lat", DoubleType(), True)
])

status_change_events_schema = StructType([
    StructField("ts", LongType(), True),
    StructField("sessionId", LongType(), True),
    StructField("auth", StringType(), True),
    StructField("level", StringType(), True),
    StructField("itemInSession", LongType(), True),
    StructField("city", StringType(), True),
    StructField("zip", StringType(), True),
    StructField("state", StringType(), True),
    StructField("userAgent", StringType(), True),
    StructField("lon", DoubleType(), True),
    StructField("lat", DoubleType(), True),
    StructField("userId", LongType(), True),
    StructField("lastName", StringType(), True),
    StructField("firstName", StringType(), True),
    StructField("gender", StringType(), True),
    StructField("registration", LongType(), True)
])

spark = SparkSession.builder \
    .appName("KafkaToHDFS") \
    .getOrCreate()

df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "broker:9092") \
    .option("subscribe", "auth_events,listen_events,page_view_events,status_change_events") \
    .option("startingOffsets", "earliest") \
    .load()

parsed_df = df.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)", "topic")

auth_events_df = parsed_df.filter(col("topic") == "auth_events") \
    .select(from_json(col("value"), auth_events_schema).alias("data")) \
    .select("data.*")

listen_events_df = parsed_df.filter(col("topic") == "listen_events") \
    .select(from_json(col("value"), listen_events_schema).alias("data")) \
    .select("data.*")

page_view_events_df = parsed_df.filter(col("topic") == "page_view_events") \
    .select(from_json(col("value"), page_view_events_schema).alias("data")) \
    .select("data.*")

status_change_events_df = parsed_df.filter(col("topic") == "status_change_events") \
    .select(from_json(col("value"), status_change_events_schema).alias("data")) \
    .select("data.*")

auth_events_query = auth_events_df.writeStream \
    .format("parquet") \
    .option("path", "hdfs://namenode:9000/data/bronze/auth_events") \
    .option("checkpointLocation", "hdfs://namenode:9000/checkpoints/auth_events") \
    .start()

listen_events_query = listen_events_df.writeStream \
    .format("parquet") \
    .option("path", "hdfs://namenode:9000/data/bronze/listen_events") \
    .option("checkpointLocation", "hdfs://namenode:9000/checkpoints/listen_events") \
    .start()

page_view_events_query = page_view_events_df.writeStream \
    .format("parquet") \
    .option("path", "hdfs://namenode:9000/data/bronze/page_view_events") \
    .option("checkpointLocation", "hdfs://namenode:9000/checkpoints/page_view_events") \
    .start()

status_change_events_query = status_change_events_df.writeStream \
    .format("parquet") \
    .option("path", "hdfs://namenode:9000/data/bronze/status_change_events") \
    .option("checkpointLocation", "hdfs://namenode:9000/checkpoints/status_change_events") \
    .start()

auth_events_query.awaitTermination()
listen_events_query.awaitTermination()
page_view_events_query.awaitTermination()
status_change_events_query.awaitTermination()