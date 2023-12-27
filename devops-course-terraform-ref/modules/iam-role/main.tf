#Ресурс, який створює IAM Role
resource "aws_iam_role" "this_role" {
  name = "this-role"
  #Команда jsonencode конвертує результат виконання коду Terraform у формат JSON
  assume_role_policy = jsonencode ({
    #Визначення версії синтаксису мови політик
    Version = "2012-10-17"
    #Масив, який визначає довзоли для ролі
    Statement = [{
      #Визначення заяви, яка дозволяє EC2 використовувати цю роль. Statemen "Assume Role" надає дозволи іншим суб'єктам
      Action = "sts:AssumeRole"
      #Вказується, що statement надає дозвіл
      Effect = "Allow"
      Sid = ""
      #Визначає суб'єкти, які мають доступ до ролі. У цьому випадк це EC2 
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    },]
    })

  tags = {
    tag-key = "tag-value"
  }
}
#Ресурс, який визначає політики для створеної ролі
resource "aws_iam_policy" "this_role_policy" {
  name = "this-policy"
  description = "Policy for access to Secret Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
    Effect = "Allow"
    #Надання дозволів для взаємодії з Secret Manager
    Action = [
      "secretmanager:GetSecretValue",
      "secretmanager:DescribeSecret",
      "secretmanager:ListSecrets",
    ]
    Resource = "*"
    },]
  })
}
#Прив'язування створеного інстансу до профілю
resource "aws_iam_instance_profile" "this_instance" {
  name = "this-instance"
  role = aws_iam_role.this_role.name
}
