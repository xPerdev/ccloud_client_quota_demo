###########################################
############ Confluent Cloud ##############
###########################################

###########################################
####### Confluent Cloud Environment #######
###########################################

data "confluent_environment" "existing_env" {
  count = var.create_ccloud_environment ? 0 : 1 
  id    = var.confluent_env_id
}

resource "confluent_environment" "new_env" {
  count        = var.create_ccloud_environment ? 1 : 0  
  display_name = var.confluent_environment_display_name
  
  lifecycle {
    prevent_destroy = false
  }
}

locals {
  ccloud_env_id = var.create_ccloud_environment ? confluent_environment.new_env[0].id : data.confluent_environment.existing_env[0].id
}

###########################################
######### Confluent Cloud Cluster #########
###########################################

resource "confluent_kafka_cluster" "dedicated" {
  display_name = "${var.prefix}_${var.project}_dedicated_cluster"
  availability = var.confluent_availability
  cloud        = var.ccloud_service_provider
  region       = var.region
  dedicated {
    cku = var.ccloud_cku_count
  }


  environment {
    id = local.ccloud_env_id
  }

  lifecycle {
    prevent_destroy = false
  }
}
