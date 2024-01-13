#Пфдключення модулю Security Group
module "sg_module" {
  source = "../sg"
}
#Ресурс для ініціалізації Classic Load Balancer
resource "aws_lb" "this_lb" {
  #Ім'я Load Balancer
  name = "this-lb"
  #Використання закритого з'єднання (без Public IP). false - з'єднання відкрито для доступу через інтернет
  internal = false
  #Визначенян типу LB. Для classic це поле не використовується
  vpc_id = module.sg_module.sg_vpc_id 
/*  load_balancer_type = "classic"
  #Прив'язка до тієї ж Security Group, що і Instance. Виконано через output зовнішнього модуля
  security_groups = [module.sg_module.sg_id]
  #Конфігурація listener для Load Balancer
/*  listener {
    #Порт, на якому будуть прослуховуватись Load Balancer
    lb_port = 80
    #Протокол, який використовується для прослуховуваня Load Balancer
    lb_protocol = "HTTP"
    #Порт, на який будуть надсилатися запити до EC2 
    instance_port = 80
    #Протокол, який використовується для надсилання запитів до EC2
    instance_protocol = "HTTP"
  }*/
}
#Ресурс для ініцалізації цільової групи для LB та приєднання EC2
resource "aws_lb_target_group" "this_lb_tg" {
  #Ім'я цільової групи
  name = "this-lb-tg"
  #Порт, на який цільова група буде чекати запити від LB
  port = 80
  #Протокол, за яким цільова група буде отримувати запити від LB
  protocol = "HTTP"
  #Тип цілі. У цьому випадку можна не вказувати, бо за замовчуванням це інстанс. Може бути "ip"
  target_type = "instance"
   #Конфігурація HealthCheck для цієї taget group
  health_check {
    #Інтервал між комжною первіркою стану (в секундах)
    interval = 60
    #Кількість послідовних успіvшних перевірок, після якої екземпляр вважається "здоровим"
    healthy_threshold = 2
    #Кількість послідовних невдалих перевірок, після якої екземпляр вважається "нездоровим"
    unhealthy_threshold = 2
    #Максимальний час очікування відповіді перевірки стану екземпляра (в секундах)
    timeout = 5
  }
}
#Ресурс для конфігурації Listener для цього LB
resource "aws_lb_listener" "this_lb_l0istener" {
  #Прив'язка до LB за допомогою ARN
  load_balancer_arn = aws_lb.this_lb.arn
  #Визначення порту та протоколу, трафік від яких буде відслідковуватися listener
  port = 80
  protocol = "HTTP"
  #Налаштування поведінки Listener 
  default_action {
    #Тип forward означає, що весь трафік буде перенаправлено на інстанси, які входять до цільової групи
    type = "forward"
    #Прив'язка listener до цільової групи через ARN
    target_group_arn = aws_lb_target_group.this_lb_tg.arn
  }
}
