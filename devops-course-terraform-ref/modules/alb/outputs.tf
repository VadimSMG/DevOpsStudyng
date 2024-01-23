#Налаштування зовнішніх даних модуля Load Balancer
#Зовнішні дані arn для target group
output "app_tg_arn" {
  value = aws_lb_target_group.app_lb_tg.arn
}
