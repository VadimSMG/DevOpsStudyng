#!bin/bash
#Отримання образу Nginx з Docker Hub
sudo docker pull nginx
#Запуск контейнеру Nginx та відкриття порту 80
sudo docker run -d -p 80:80 nginx
