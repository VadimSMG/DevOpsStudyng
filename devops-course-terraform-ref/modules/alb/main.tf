#Ресурс для визначення підмереж (subnets) за замовчуанням для конкретного розташування
resource "aws_default_subnet" "us-west-2a" {
  availability_zone = "us-west-2a"
}
resource "aws_default_subnet" "us-west-2b" {
  availability_zone = "us-west-2b"
}
#Ресурс для ініціалізації Application Load Balancer
resource "aws_lb" "app_lb" {
  #Ім'я Load Balancer
  name = "app-lb"
  #Використання закритого з'єднання (без Public IP). false - з'єднання відкрито для доступу через інтернет
  internal = false
  #Визначенян типу LB. 
  load_balancer_type = "application"
  #Прив'язка до тієї ж Security Group, що і Instance. Виконано через порожню змінну, значення якої визначається у головному файлі
  security_groups = [var.sg-id]
  #Необхідно мінімум 2 підмережі (subnets) для роботи Application LB
  subnets = [
    aws_default_subnet.us-west-2a.id,
    aws_default_subnet.us-west-2b.id,
  ] 
  #Ввімкнення захисту від видалення через Terraform
  enable_deletion_protection = false
}
#Ресурс для ініцалізації цільової групи для LB та приєднання EC2
resource "aws_lb_target_group" "app_lb_tg" {
  #Ім'я цільової групи
  name = "app-lb-tg"
  #Порт, на який цільова група буде чекати запити від LB
  port = 80
  #Протокол, за яким цільова група буде отримувати запити від LB
  protocol = "HTTP"
  #Тип цілі. У цьому випадку можна не вказувати, бо за замовчуванням це інстанс. Може бути "ip"
  target_type = "instance"
  vpc_id = var.vpc-id
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
resource "aws_lb_listener" "app_lb_listener" {
  #Прив'язка до LB за допомогою ARN
  load_balancer_arn = aws_lb.app_lb.arn
  #Визначення порту та протоколу, трафік від яких буде відслідковуватися listener
  port = 80
  protocol = "HTTP"
  #Налаштування поведінки Listener 
  default_action {
    #Тип forward означає, що весь трафік буде перенаправлено на інстанси, які входять до цільової групи без додаткової обробки
    type = "forward"
    #Прив'язка listener до цільової групи через ARN
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}
