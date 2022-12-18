#!/usr/bin/env bash

docker run -v $PWD/../config/ccloud_consumer.properties:/etc/ccloud.properties confluentinc/cp-server:7.3.0 /usr/bin/kafka-consumer-perf-test \
  --bootstrap-server pkc-66766.eu-central-1.aws.confluent.cloud:9092 \
  --topic adidas.perf.test \
  --messages 200000 \
  --consumer.config /etc/ccloud.properties \
  --group adidas-perf-consumer-221218 \
  --timeout 60000
  