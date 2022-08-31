module "tamr-config" {
  #   source = "git::git@github.com:Datatamer/terraform-aws-tamr-config?ref=2.5.0"
  source = "../.."

  config_template_path       = "../../tamr-config.yml"
  rendered_config_path       = "./rendered-config.yml"
  ephemeral_spark_configured = false
  additional_templated_variables = {
    "TAMR_LICENSE_KEY" : var.license_key
  }
  emr_tags = var.emr_tags

  rds_pg_hostname = module.rds-postgres.rds_hostname
  rds_pg_dbname   = module.rds-postgres.rds_dbname
  rds_pg_username = module.rds-postgres.rds_username
  rds_pg_password = random_password.rds-password.result
  rds_pg_db_port  = module.rds-postgres.rds_db_port

  hbase_namespace   = "tamr"
  tamr_data_bucket  = module.s3-data.bucket_name
  hbase_config_path = module.emr.hbase_config_path

  spark_emr_cluster_id           = module.emr.tamr_emr_cluster_id
  spark_cluster_log_uri          = module.emr.log_uri
  tamr_data_path                 = "tamr/unify-data"
  tamr_spark_properties_override = "{'spark.driver.maxResultSize':'4g'}"
  es_domain_endpoint             = module.tamr-opensearch-cluster.tamr_es_domain_endpoint
  spark_driver_memory            = "10G"
  spark_executor_cores           = "4"
  spark_executor_instances       = 8
  spark_executor_memory          = "16G"

  # Backup
  tamr_backup_emr_cluster_id = module.emr.tamr_emr_cluster_id
}
