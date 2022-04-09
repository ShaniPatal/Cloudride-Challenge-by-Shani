module "cloudride-shani-vpc" {
  source = "./modules"
  region               = "us-east-2"
  vpc_cidr             = "10.11.0.0/16"
  name                 = "cloudride-shani-vpc"
  env                  = "prod"
  public_subnets_cidr  = ["10.11.0.0/24", "10.11.1.0/24"]
  private_subnets_cidr = ["10.11.3.0/24", "10.11.4.0/24"]
  availability_zones   = ["us-east-2a", "us-east-2b", "us-east-2c"]
}