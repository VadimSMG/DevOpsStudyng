sudo apt update -y #Актуалізація системи
sudo apt install nginx -y #Встановлення Nginx з офіційного репозиторія
sudo ufw enable -y #Увімкення файрвола для Ubuntu
sudo systemctl start nginx
sudo ufw allow 'Nginx HTTP' #Надання дозволу для HTTP з'єднання до
sudo hostname -f > /var/www/index.nginx*.html
#sudo hostname -f > $(sudo find /var/www/ -type f -name index.nginx*.html)
sudo systemctl restart nginx
