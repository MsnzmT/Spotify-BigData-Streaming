#!/bin/bash

# Wait for HDFS to be ready
until hdfs dfs -ls /; do
  echo "Waiting for HDFS..."
  sleep 5
done

# Define base directory
BASE_DIR="/data/bronze"
TOPICS=("auth_events" "listen_events" "page_view_events" "status_change_events")

# Create directories if they don't exist
for TOPIC in "${TOPICS[@]}"; do
  DIR="${BASE_DIR}/${TOPIC}"
  if ! hdfs dfs -test -d $DIR; then
    echo "Creating HDFS directory: $DIR"
    hdfs dfs -mkdir -p $DIR
    hdfs dfs -chmod -R 777 $DIR
  fi
done

echo "HDFS directories initialized successfully."

# Keep the container running
exec "$@"
