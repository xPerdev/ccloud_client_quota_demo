###########################################
############ Confluent Cloud ##############
###########################################

###########################################
### Confluent Client Properties Configs ###
###########################################

# This terraform script sets a set of Confluent Cloud related parameters
# in Kafka client resource configuration template files, so they 
# can be used to passto self-managed client applications.

# Generate the Confluent Cloud client configurationa properties file for producer client applications
locals{
  producer_ccloud_env =  templatefile("${path.root}/../templates/ccloud_client_properties.tftpl",{
        ccloud_kafka_api_key          = var.create_ccloud_service_account ? confluent_api_key.producer-cloud-kafka-api-key[0].id : "<kafka-api-key>", 
        ccloud_kafka_api_secret       = var.create_ccloud_service_account ? confluent_api_key.producer-cloud-kafka-api-key[0].secret : "<kafka-api-secret>",
        ccloud_kafka_bootstrap_url    = trimprefix(confluent_kafka_cluster.dedicated.bootstrap_endpoint,"SASL_SSL://"), 
        ccloud_sr_url                 = local.ccloud_sr_rest_endpoint,
        ccloud_sr_api_key             = var.create_ccloud_service_account ? confluent_api_key.producer-cloud-sr-api-key[0].id : "<sr-api-key>", 
        ccloud_sr_api_secret          = var.create_ccloud_service_account ? confluent_api_key.producer-cloud-sr-api-key[0].secret : "<sr-api-secret>"
      }   
    )
}

resource "local_file" "ccloud_producer_properties_file" {
    content         = local.producer_ccloud_env
    filename        = "${path.root}/../../config/ccloud_producer.properties"
    file_permission = "0644"
}

# Generate the Confluent Cloud client configurationa properties file for consumer client applications
locals{
  consumer_ccloud_env =  templatefile("${path.root}/../templates/ccloud_client_properties.tftpl",{
        ccloud_kafka_api_key          = var.create_ccloud_service_account ? confluent_api_key.consumer-cloud-kafka-api-key[0].id : "<kafka-api-key>",
        ccloud_kafka_api_secret       = var.create_ccloud_service_account ? confluent_api_key.consumer-cloud-kafka-api-key[0].secret : "<kafka-api-secret>",
        ccloud_kafka_bootstrap_url    = trimprefix(confluent_kafka_cluster.dedicated.bootstrap_endpoint,"SASL_SSL://"), 
        ccloud_sr_url                 = local.ccloud_sr_rest_endpoint,
        ccloud_sr_api_key             = var.create_ccloud_service_account ? confluent_api_key.consumer-cloud-sr-api-key[0].id : "<sr-api-key>",
        ccloud_sr_api_secret          = var.create_ccloud_service_account ? confluent_api_key.consumer-cloud-sr-api-key[0].secret : "<sr-api-key>"
      }   
    )
}

resource "local_file" "ccloud_consumer_properties_file" {
    content         = local.consumer_ccloud_env
    filename        = "${path.root}/../../config/ccloud_consumer.properties"
    file_permission = "0644"
}