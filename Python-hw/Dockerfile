#Вказування на офіційни образ Docker
FROM python:3.9
#Встановлення залежностей
WORKDIR /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
#Копіювання додатку
COPY . /app/
#Відриття порту 5000
EXPOSE 5000
#Запускаємо додаток
CMD ["python3", "main.py"]
