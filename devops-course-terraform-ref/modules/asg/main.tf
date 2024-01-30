#Ресурс для створення Launch Template для Autoscaling Group
resource "aws_launch_template" "this_template" {
  #Назва для Launch Template
  name = "this-template"
  #AMI який буде використовуватись для роозгортання системи. Передається через звонішню змінну з головного модуля
  image_id = var.aws_ami
  #Тип інстансу, який необхідно використовуати для шаблону
  instance_type = "t2.micro"
  #Пара SSH для підключення до інстансу
  key_name = "dev-test"
  #Налаштування розмітки сходвища для інстансу
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      #Розмір сховища для інстансу у Гб
      volume_size = 20
      #Тип сховища. У цьому випадку це General Purpose SSD
      volume_type = "gp2"
    }
  }
  #Налаштування мережі
  network_interfaces {
    #Ассоціювати публічний IP з інстансам
    associate_public_ip_address = true
    #Групи безпеки, які асоційовані з інстансом
    security_groups = [var.sg-id]
  }
}

#Ресурс длястворення Autoscaling Group
resource "aws_autoscaling_group" "this_asg" {
  #Визначення зон доступності, у яких можуть бути розгорнуті інстанси
  availability_zones = ["us-west-2a"]
  #Кількість інстансів, які необхідн підтримувати ASG
  desired_capacity = 1
  #Максимальна кількість інстансів
  max_size = 2
  #Мінімальна кількість інстансів
  min_size = 1
  
  #Вказування шаблону для запуску (launch template)
  launch_template {
    #Посилання на AMI який використовується для створення Launch Template
    id = aws_launch_template.this_template.id
    #Опція, яка вказує використовувати найновіший наявний Launch Template
    version = "$Latest"
  }
}

#Ресур для визначення розкладу збільшення кількості інстансів у ASG
resource "aws_autoscaling_schedule" "this_asg_scale_in" {
  #Ім'я для заданої дії за розкладом
  scheduled_action_name = "scale-in"
  #Параметр, що вказує мінімальний розмір ASG. Якщо не потрібно змінювати розмір групи то параметр приймає значення "-1"
  min_size = 2
  #Максимальний розмір ASG на період дії розкладу
  max_size = 3
  #Параметр, який визначає необхідну кількість підтрмуваних інстансів у період дії розкладу
  desired_capacity = 2
  #Задання розкладу створення інстансів у форматі cron
  recurrence = "0 12 * * *"
  #Час, який визначає запуск масштабування
  #start_time = ""
  #Час, який визначає зупинку масштабування
  #end_time = ""
  autoscaling_group_name = aws_autoscaling_group.this_asg.name
}

#Ресур для визначення розкладу зменшення кількості інстансів у ASG
resource "aws_autoscaling_schedule" "this_asg_scale_out" {
  #Ім'я для заданої дії за розкладом
  scheduled_action_name = "scale-out"
  #Параметр, що вказує мінімальний розмір ASG. Якщо не потрібно змінювати розмір групи то параметр приймає значення "-1"
  min_size = 0
  #Максимальний розмір ASG на період дії розкладу
  max_size = 1
  #Параметр, який визначає необхідну кількість підтрмуваних інстансів у період дії розкладу
  desired_capacity = 0
  #Задання розкладу створення інстансів у форматі cron
  recurrence = "0 0 * * *"
  autoscaling_group_name = aws_autoscaling_group.this_asg.name
}
