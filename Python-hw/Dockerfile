#Вказування на офіційни образ Docker. AS builder - визначення єтапу збірки та присвоєння йому імені "builder"
FROM python:3.9 AS builder
#Встановлення залежностей
WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir -r requirements.txt
#Початок наступного етапу збірки з використанням офіційного образу Python з меншим розміром
FROM python:3.9-slim
WORKDIR /app
#Копіювання файлів з попереднього етапу збірки
COPY --from=builder /app /app
#Відриття порту 5000
EXPOSE 5000
ENTRYPOINT uvicorn main:app --host 0.0.0.0 --port 5000
