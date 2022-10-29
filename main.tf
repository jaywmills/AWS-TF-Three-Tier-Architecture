module "AutoScalingGroups" {
  source = "./modules/Auto Scaling Groups"

  instance_type   = var.instance_type
  security_groups = module.SecurityGroups.public_http_sg
  public_subnets  = module.Networking.aws_public_subnet
}

module "ec2_instances" {
  source = "./modules/Compute"

  ami                           = var.ami
  instance_type                 = var.instance_type
  instance_count                = 2
  key_name                      = var.key_name
  security_groups               = module.SecurityGroups.public_http_sg
  bastion_sg                    = module.SecurityGroups.bastion_sg
  app_tier_sg                   = module.SecurityGroups.app_tier_sg
  public_subnet                 = module.Networking.aws_public_subnet
  private_subnet_app_tier       = module.Networking.aws_app_subnet
  project_tier_target_group_arn = module.LoadBalancing.project_lb_tg
  app_tier_target_group_arn     = module.LoadBalancing.app_tier_lb_tg
  user_data                     = file("./userdata.tpl")
}

module "Database" {
  source            = "./modules/Database"
  allocated_storage = var.allocated_storage
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  multi_az          = false
  db_name           = var.db_name
  subnet_ids        = module.Networking.aws_private_subnet
  security_groups   = module.SecurityGroups.private_database_sg
}

module "Networking" {
  source            = "./modules/Networking"
  vpc_cidr          = var.vpc_id
  private_sn_count  = var.private_sn_count
  public_sn_count   = var.public_sn_count
  app_tier_sn_count = var.app_tier_sn_count
}

module "LoadBalancing" {
  source                 = "./modules/Load Balancing"
  vpc_id                 = module.Networking.vpc_id
  public_subnets         = module.Networking.aws_public_subnet
  app_tier_sn            = module.Networking.aws_app_subnet
  security_groups        = module.SecurityGroups.public_ALB
  private_sg             = module.SecurityGroups.private_ALB
  app_tier_sg            = module.SecurityGroups.app_tier_sg
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 20
  lb_interval            = 30
}

module "SecurityGroups" {
  source = "./modules/Security Groups"
  vpc_id = module.Networking.vpc_id
}