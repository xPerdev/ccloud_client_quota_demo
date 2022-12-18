###########################################
############ Confluent Cloud ##############
###########################################

###########################################
############ Schema Registry ##############
###########################################

# Obtain the data-object for an already existing SR when using and exsitng Confluent Cloud environment.
data "confluent_schema_registry_cluster" "cc_existing_sr" {
  count   = var.create_ccloud_environment ? 0 : 1
  id = var.confluent_sr_id
  environment {
    id = var.confluent_env_id
  }
}

# Obtain the Confluent Cloud schema registry region for a new SR in a new Confluent Cloud environment.
data "confluent_schema_registry_region" "cc_sr_region" {
  count   = var.create_ccloud_environment ? 1 : 0
  cloud   = var.ccloud_service_provider
  region  = var.sr_region
  package = var.sr_package
}

resource "confluent_schema_registry_cluster" "cc_new_sr" {
  count   = var.create_ccloud_environment ? 1 : 0
  package = data.confluent_schema_registry_region.cc_sr_region[0].package

  environment {
    id = local.ccloud_env_id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    # Schema Registry and Kafka clusters can be in different regions as well as different cloud providers,
    # but you should to place both in the same cloud and region to restrict the fault isolation boundary.
    id = data.confluent_schema_registry_region.cc_sr_region[0].id
  }

  lifecycle {
    prevent_destroy = false
  }
}

locals {
  ccloud_sr_id            = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].id : data.confluent_schema_registry_cluster.cc_existing_sr[0].id
  ccloud_sr_name          = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].display_name : data.confluent_schema_registry_cluster.cc_existing_sr[0].display_name
  ccloud_sr_api_version   = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].api_version : data.confluent_schema_registry_cluster.cc_existing_sr[0].api_version
  ccloud_sr_kind          = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].kind : data.confluent_schema_registry_cluster.cc_existing_sr[0].kind
  ccloud_sr_rest_endpoint = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].rest_endpoint : data.confluent_schema_registry_cluster.cc_existing_sr[0].rest_endpoint
  ccloud_sr_resoure_name  = var.create_ccloud_environment ? confluent_schema_registry_cluster.cc_new_sr[0].resource_name : data.confluent_schema_registry_cluster.cc_existing_sr[0].resource_name
}
