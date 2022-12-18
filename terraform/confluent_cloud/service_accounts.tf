###########################################
############ Confluent Cloud ##############
###########################################

###########################################
############ Service Account ##############
###########################################

resource "confluent_service_account" "cloud-producer-sa" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${var.prefix}-${var.account_name}-producer-sa"
  description  = "Service Account for self-managed producer applications with Confluent Cloud for ${var.prefix} ${var.project} demo"
}

resource "confluent_service_account" "cloud-consumer-sa" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${var.prefix}-${var.account_name}-consumer-sa"
  description  = "Service Account for self-managed consumer applications with Confluent Cloud for ${var.prefix} ${var.project} demo"
}

###########################################
######## Dataplane Role Bindings ##########
###########################################

# Kafka topic access role bindings
resource "confluent_role_binding" "producer-confluent-license-topic-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 :0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "producer-confluent-license-topic-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "producer-confluent-license-topic-write-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 :0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "producer-client-namespace-topic-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.namespace_topic_prefix}.*"
}

resource "confluent_role_binding" "producer-client-namespace-topic-write-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.namespace_topic_prefix}.*"
}

resource "confluent_role_binding" "consumer-confluent-license-topic-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "consumer-confluent-license-topic-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "consumer-confluent-license-topic-write-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "consumer-client-namespace-topic-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.namespace_topic_prefix}.*"
}

resource "confluent_role_binding" "consumer-client-namespace-topic-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/topic=${var.namespace_topic_prefix}.*"
}

# Kafka consumer group role bindings
resource "confluent_role_binding" "producer-confluent-license-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.license_group_prefix}*"
}

resource "confluent_role_binding" "producer-confluent-license-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.license_group_prefix}*"
}

resource "confluent_role_binding" "producer-client-connect-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.connect_internal_group_prefix}*"
}

resource "confluent_role_binding" "producer-client-connect-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.connect_internal_group_prefix}*"
}

resource "confluent_role_binding" "producer-client-namespace-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.namespace_group_prefix}*"
}

resource "confluent_role_binding" "producer-client-namespace-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-producer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.namespace_group_prefix}*"
}

resource "confluent_role_binding" "consumer-confluent-license-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.license_group_prefix}*"
}

resource "confluent_role_binding" "consumer-confluent-license-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.license_group_prefix}*"
}

resource "confluent_role_binding" "consumer-client-connect-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.connect_internal_group_prefix}*"
}

resource "confluent_role_binding" "consumer-client-connect-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.connect_internal_group_prefix}*"
}

resource "confluent_role_binding" "consumer-client-namespace-group-manage-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.namespace_group_prefix}*"
}

resource "confluent_role_binding" "consumer-client-namespace-group-read-rb" {
  count       = var.create_ccloud_service_account ? var.create_ccloud_rolebindings ? 1 : 0 : 0
  principal   = "User:${confluent_service_account.cloud-consumer-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.dedicated.rbac_crn}/kafka=${confluent_kafka_cluster.dedicated.id}/group=${var.namespace_group_prefix}*"
}