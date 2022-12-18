###########################################
############ Confluent Cloud ##############
###########################################

###########################################
########## Kafka Client Quotas ############
###########################################

resource "confluent_kafka_client_quota" "producer_test" {
  count        = var.create_ccloud_producer_quota ? 1 : 0
  display_name = "${confluent_service_account.cloud-producer-sa[0].display_name}-${confluent_kafka_cluster.dedicated.id}-client-quota"
  description  = "Cloud Client Quota for Kafka cluster ${confluent_kafka_cluster.dedicated.display_name} that is enforced for '${confluent_service_account.cloud-producer-sa[0].display_name}' service account."
  throughput {
    ingress_byte_rate = var.quota_ingress_byte_rate
    egress_byte_rate  = var.quota_egress_byte_rate
  }
  principals = [confluent_service_account.cloud-producer-sa[0].id]

  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  environment {
    id = local.ccloud_env_id
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_client_quota" "consumer_test" {
  count        = var.create_ccloud_consumer_quota ? 1 : 0
  display_name = "${confluent_service_account.cloud-consumer-sa[0].display_name}-${confluent_kafka_cluster.dedicated.id}-client-quota"
  description  = "Cloud Client Quota for Kafka cluster ${confluent_kafka_cluster.dedicated.display_name} that is enforced for '${confluent_service_account.cloud-consumer-sa[0].display_name}' service account."
  throughput {
    ingress_byte_rate = var.quota_ingress_byte_rate
    egress_byte_rate  = var.quota_egress_byte_rate
  }
  principals = [confluent_service_account.cloud-consumer-sa[0].id]

  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  environment {
    id = local.ccloud_env_id
  }

  lifecycle {
    prevent_destroy = false
  }
}