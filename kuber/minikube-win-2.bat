REM Параметр вказує виводити (on) чи ні (off) результат виконання команд у командному рядку.
@echo off

REM Визначення значень змінних для використання у скрипті.
set IMGNAME=backend:test
set DOCKERDIR=..\Python-hw\
set KUBERDIR=..\kuber\
set NAMESPC=dev
set DOCKER_PASSWORD=13V31a13D%GL
set DOCKER_USERNAME=vadimsmg@gmail.com
set CI_IMAGE=registry.gitlab.com/dev-ops-dosvit/microservice-app
REM Виведеня повідомлення про запуск служби Docker та запуск служби.
echo Starting Docker Service...
net start docker

REM Вказування використовувати вбудований Docker minikube замість локального.
REM minikube docker-env --shell cmd
REM Перезапуск командного рядку у сценарії з використання поточного файлу сценарію.
REM start "" "%~f0"
REM exit

REM Виведення повідомлення про запуск служби minikube та її запуск.
echo Starting minikube...
minikube start --driver=docker

REM Визначення змінних середовища для Docker.
REM @FOR /F "tokens=*" %%i IN ('minikube docker-env') DO @%%i
REM @FOR - запуск цикла виконання для кожного рядка команди, яка знаходиться у IN (). Для цього файлу це minikube docker-env.
REM "tokens=*" - параметр, що вказує розбирати всі токени (слова) в кажному рядку.
REM %%i - змінна, яка представляє кожен рядок для циклу FOR.
REM IN ('minikube docker-env') параметр, що вказує команду, яку необхідн обробляти у циклі FOR.
REM DO %%i - вказується, що для кожного рядку, виконання команди 'minikube docker-env' виконується команда, що збережена у змінній %%i. Ключове слово @ призначене для виведення результатів роботи цієї команди.

REM Побудова образу Docker, використовуючи внутрышный реєстр minikube.
REM echo /Building Docker image...
REM cd %DOCKERDIR%
REM docker run -d -p 5000:5000 --restart=always --name registry registry:2
REM docker build -t %IMGNAME%
REM docker tag %IMGNAME% localhost:5000/%IMGNAME%
REM docker push localhost:5000/%IMGNAME%

REM Виконання авторизації за допомогою docker login для внутрішнього Docker minikube.
minikube ssh "echo %DOCKER_PASSWORD% | docker login --username %DOCKER_USERNAME% --password-stdin registry.gitlab.com"
REM Отримання образів з реєстру GitLab.
minikube ssh "docker pull %CI_IMAGE%"
minikube ssh "docker pull %CI_IMAGE%/users-api:latest"
minikube ssh "docker pull %CI_IMAGE%/todos-api:latest"
minikube ssh "docker pull %CI_IMAGE%/log-message-processor:latest"
minikube ssh "docker pull %CI_IMAGE%/frontend:latest"
minikube ssh "docker pull %CI_IMAGE%/auth-api:latest"
REM Перевірка наявеності образів у minikube.
minikube ssh "docker images"

REM Створення просторів імен Kubernetes.
echo Setting up Kubernetes namespaces...
cd %KUBERDIR%
kubectl create namespace dev
kubectl create namespace stage
kubectl create namespace prod

REM Встановлення Helm діаграм для кожного середовища.
echo Installing Helm charts...
cd .\python-api\
helm install -f values-dev.yaml api-app-dev .\
helm install -f values-stage.yaml api-app-stage .\
helm install -f values-prod.yaml api-app-prod .\