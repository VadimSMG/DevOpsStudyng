#Налаштування зовнішніх даних модуля Load Balancer
#Зовнішні дані arn для target group
output "this_tg_arn" {
  value = aws_lb_target_group.this_lb_tg.arn
}
