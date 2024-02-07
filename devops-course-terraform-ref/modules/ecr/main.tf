#Ресурс для визначення праметрів ECR
resource "aws_ecr_repository" "this_ecs" {
  name = "this_ecs"
}
