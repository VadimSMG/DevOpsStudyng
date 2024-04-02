#Вказування на офіційни образ Docker
FROM python:3.9
#Встановлення залежностей
WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir -r requirements.txt
#Відриття порту 5000
EXPOSE 5000
ENTRYPOINT uvicorn main:app --host 0.0.0.0 --port 5000

