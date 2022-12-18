#!/usr/bin/env bash

docker run -v $PWD/../config/ccloud_producer.properties:/etc/ccloud.properties confluentinc/cp-server:7.3.0 /usr/bin/kafka-producer-perf-test \
  --topic adidas.perf.test \
  --num-records 200000 \
  --record-size 800 \
  --throughput -1 \
  --producer.config /etc/ccloud.properties \
  --producer-props \
      batch.size=80 \
      linger.ms=100 \
      compression.type=lz4 \
      acks=all