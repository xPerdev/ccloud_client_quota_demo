###########################################
############ Confluent Cloud ##############
###########################################

###########################################
################ API Keys #################
###########################################

resource "confluent_api_key" "producer-cloud-kafka-api-key" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${confluent_service_account.cloud-producer-sa[0].display_name}-kafka-api-key"
  description  = "API Key for Kafka cluster ${confluent_kafka_cluster.dedicated.display_name} that is owned by '${confluent_service_account.cloud-producer-sa[0].display_name}' service account."
  owner {
    id          = confluent_service_account.cloud-producer-sa[0].id
    api_version = confluent_service_account.cloud-producer-sa[0].api_version
    kind        = confluent_service_account.cloud-producer-sa[0].kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated.id
    api_version = confluent_kafka_cluster.dedicated.api_version
    kind        = confluent_kafka_cluster.dedicated.kind

    environment {
      id = local.ccloud_env_id
    }
  }

  # The goal is to ensure that confluent_role_binding.producer-client-namespace-topic-manage-rb is created before
  # confluent_api_key.${var.prefix}-${var.account_name}-producer-sa-kafka-api-key is used to create instances of
  # confluent_kafka_topic resources.
  # 'depends_on' meta-argument is specified in confluent_api_key.${var.prefix}-${var.account_name}-producer-sa-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic resources instead.
  depends_on = [
    confluent_role_binding.producer-client-namespace-topic-manage-rb
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_api_key" "consumer-cloud-kafka-api-key" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${confluent_service_account.cloud-consumer-sa[0].display_name}-kafka-api-key"
  description  = "API Key for Kafka cluster ${confluent_kafka_cluster.dedicated.display_name} that is owned by '${confluent_service_account.cloud-consumer-sa[0].display_name}' service account."
  owner {
    id          = confluent_service_account.cloud-consumer-sa[0].id
    api_version = confluent_service_account.cloud-consumer-sa[0].api_version
    kind        = confluent_service_account.cloud-consumer-sa[0].kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated.id
    api_version = confluent_kafka_cluster.dedicated.api_version
    kind        = confluent_kafka_cluster.dedicated.kind

    environment {
      id = local.ccloud_env_id
    }
  }

  # The goal is to ensure that confluent_role_binding.consumer-client-namespace-topic-manage-rb is created before
  # confluent_api_key.${var.prefix}-${var.account_name}-consumer-sa-kafka-api-key is used to create instances of
  # confluent_kafka_topic resources.
  # 'depends_on' meta-argument is specified in confluent_api_key.${var.prefix}-${var.account_name}-consumer-sa-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic resources instead.
  depends_on = [
    confluent_role_binding.consumer-client-namespace-topic-manage-rb
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_api_key" "producer-cloud-sr-api-key" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${confluent_service_account.cloud-producer-sa[0].display_name}-sr-api-key"
  description  = "API Key for schema registry ${local.ccloud_sr_name} that is owned by '${confluent_service_account.cloud-producer-sa[0].display_name}' service account."
  owner {
    id          = confluent_service_account.cloud-producer-sa[0].id
    api_version = confluent_service_account.cloud-producer-sa[0].api_version
    kind        = confluent_service_account.cloud-producer-sa[0].kind
  }

  managed_resource {
    id          = local.ccloud_sr_id 
    api_version = local.ccloud_sr_api_version
    kind        = local.ccloud_sr_kind

    environment {
        id = local.ccloud_env_id
    }
  }
  
  # The goal is to ensure that confluent_role_binding.producerer-sr-subject-namespace-manage-rb is created before
  # confluent_api_key.${var.prefix}-${var.account_name}-producer-sa-sr-api-key is used to create instances of
  # confluent_schema resources.
  # 'depends_on' meta-argument is specified in confluent_api_key.${var.prefix}-${var.account_name}-producer-sa-sr-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_schema resources instead.
  # Currently, Schema Registry RBAC is available but not yet supported by the current version of Confluent provider for Terraform (i.e. v 1.23)
  # Hence, the 'depends_on' meta-argument is commented out.
  # depends_on = [
  #  confluent_role_binding.producer-sr-subject-namespace-manage-rb
  # ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_api_key" "consumer-cloud-sr-api-key" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${confluent_service_account.cloud-consumer-sa[0].display_name}-sr-api-key"
  description  = "API Key for schema registry ${local.ccloud_sr_name} that is owned by '${confluent_service_account.cloud-consumer-sa[0].display_name}' service account."
  owner {
    id          = confluent_service_account.cloud-consumer-sa[0].id
    api_version = confluent_service_account.cloud-consumer-sa[0].api_version
    kind        = confluent_service_account.cloud-consumer-sa[0].kind
  }

  managed_resource {
    id          = local.ccloud_sr_id 
    api_version = local.ccloud_sr_api_version
    kind        = local.ccloud_sr_kind

    environment {
        id = local.ccloud_env_id
    }
  }

  # The goal is to ensure that confluent_role_binding.consumer-sr-subject-namespace-manage-rb is created before
  # confluent_api_key.${var.prefix}-${var.account_name}-consumer-sa-sr-api-key is used to create instances of
  # confluent_schema resources.
  # 'depends_on' meta-argument is specified in confluent_api_key.${var.prefix}-${var.account_name}-consumer-sa-sr-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_schema resources instead.
  # Currently, Schema Registry RBAC is available but not yet supported by the current version of Confluent provider for Terraform (i.e. v 1.23)
  # Hence, the 'depends_on' meta-argument is commented out.
  # depends_on = [
  #  confluent_role_binding.consumer-sr-subject-namespace-manage-rb
  # ]
  
  lifecycle {
    prevent_destroy = false
  }
}
