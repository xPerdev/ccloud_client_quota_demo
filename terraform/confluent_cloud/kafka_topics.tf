###########################################
############ Confluent Cloud ##############
###########################################

###########################################
############## Kafka Topics ###############
###########################################

resource "confluent_kafka_topic" "perf_test" {
  count              = var.create_ccloud_service_account ? var.create_ccloud_kafka_topics ? 1 : 0 : 0
  kafka_cluster {
    id               = confluent_kafka_cluster.dedicated.id
  }
  topic_name         = "${var.namespace_topic_prefix}.perf.test"
  partitions_count   = 8
  rest_endpoint      = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key              = confluent_api_key.producer-cloud-kafka-api-key[0].id
    secret           = confluent_api_key.producer-cloud-kafka-api-key[0].secret
  }

  lifecycle {
    prevent_destroy = false
  }
}
