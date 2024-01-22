environmnet = "Prod"
common_tags = {
    "Env"     = "Production"
    "Company" = "Mithun Technologies"
  }
vpc_cidr = "10.2.0.0/16"
public_subnets_cidr = ["10.2.0.0/19","10.2.32.0/19","10.2.64.0/19"]
private_subnets_cidr = ["10.2.96.0/19","10.2.128.0/19","10.2.160.0/19"]
nodegroup_instance_type = "t2.large"
nodegroup_desired_size = 2
nodegroup_min_size = 2
nodegroup_max_size = 5