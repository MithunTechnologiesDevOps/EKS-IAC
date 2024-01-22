environmnet = "Dev"
common_tags = {
    "Env"     = "Devlopment"
    "Company" = "Mithun Technologies"
  }
vpc_cidr = "10.1.0.0/16"
public_subnets_cidr = ["10.1.0.0/19","10.1.32.0/19","10.1.64.0/19"]
private_subnets_cidr = ["10.1.96.0/19","10.1.128.0/19","10.1.160.0/19"]
nodegroup_instance_type = "t2.medium"
nodegroup_desired_size = 2
nodegroup_min_size = 2
nodegroup_max_size = 4