#Цей блок використовується для визначення плагінів, що будуть використовуватись для побудови образу. 
packer {
  #Цей блок описує усі необхідні плагіни для побудови образу
  required_plugins {
    #Плагін для створення образів з використанням Amazon AWS
    amazon = {
      #Необхідна версія плагіна
      version = ">= 1.2.8"
      #Джерело, звідки буде встановлено плагін
      source = "github.com/hashicorp/amazon"
    }
  }
}
#Блок, який визначає конфігурацію для побудови образу через builder. Можна використовувати для кількох builder
source "amazon-ebs" "ubuntu" {            #Використання плагіна який був визначений раніше  
  ami_name      = "this-packer"           #Визнчення імені образу
  instance_type = "t2.micro"              #Визначення типу AWS інстансу
  region        = "us-west-2"             #Визначення регіону розташування інстансу
  source_ami    = "ami-008fe2fc65df48dac" #Визначення стандартного образу EC2,який буде використовуватись як базовий
  /*source_ami_filter {           #Фільри, що використовуються для заповнення полей при створенні ami. Вказується, який стандартний ami використовується за основу для builder
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*" #Ім'я ami, яке використовується при побудові
      root-device-type    = "ebs"                                              #Вказується тип адмністративного пристрою: ebs або instance-store
      virtualization-type = "hvm"                                              #Вказується тип віртуалізації: hvm або paravirtual
    }
    most_recent = true           #Вказується використовувати (true) чи ні (false) найновіший образ
    owners      = [405944614123] #Вказуються один, чи кілька власників образу за їх Account ID. Цю інформацю можна знайти на порталі AWS
  }*/
  ssh_username = "ubuntu" #Ім'я користувача, яке використовується при підключенні через SSH
}
#Цей блок виконує побудову образу згідно конфігураціям, які надано вище
build {
  name = "test-packer" #Ім'я для образу
  sources = [          #Визначення модулю, який використовується для збірки
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    script = "./nginx-inst.sh"
  }
}
