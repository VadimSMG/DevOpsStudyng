#Зовнішній модуль для налаштування Security Group
module "sg_module" {
  source = "../sg"
}
#Зовнішній модуль для IAM Profile з дозволами на роботу Secret Manager
module "iam_role_module" {
  source = "../iam-role"
}
#Створення EC2 instance за допомогою AWS
resource "aws_instance" "dev_ops_test" {
  ami                    = var.aws_ami
  instance_type          = var.aws_instance_type
  key_name               = "dev-test"
  vpc_security_group_ids = [module.sg_module.sg_vpc_id]
  #Користувацький скрипт по встановленню та запуску Docker  
  user_data = var.docker_install_script
  #Прив'язування створеного IAM Profile до цього інстансу
  iam_instance_profile = module.iam_role_module.this_profile_name

  tags = {
    Name = "DevOpsLearning"
  }
}
