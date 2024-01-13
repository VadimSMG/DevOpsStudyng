#Підключення моділю з налаштуваннями Security Group
/*module "sg_module" {
  source = "../sg"
}*/
#Ремурс для ініцалізації Classic Load Balancer
resource "aws_elb" "this_elb" {
  name = "classic-elb"
  availability_zones = var.az_elb
  #Налаштування слухання портів для ELB
  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  #Налаштування переліку Security Group для стовреного ELB
  security_groups = [var.sg_id]
  #Налаштування параметрів перевірку стану інстансу - health check
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/"
    interval = 30
  }
}
