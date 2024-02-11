#!bin/bash
#Клонування репозиторію
git clone https://github.com/koshmanov/kavin-corporate-static-website.git
pwd
#Покаати перелік наявних S3 bucktes
aws s3 ls
#Вказати необхідний bucket
echo "Input bucket name:"
read S3BUCK
#Надсилання всіх файлів з каталогу до вказаного S3 Bucket
aws s3 cp ./kavin-corporate-static-website/ s3://'$S3BUCK'/  
