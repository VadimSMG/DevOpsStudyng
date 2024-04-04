REM Параметр вказує виводити (on) чи ні (off) результат виконання команд у командному рядку.
@echo on

REM Визначення значень змінних для використання у скрипті.
set IMGNAME=backend:test
set DOCKERDIR=..\Python-hw\
set KUBERDIR=..\kuber\
set NAMESPC=dev

REM Виведеня повідомлення про запуск служби Docker та запуск служби.
echo Starting Docker Service...
net start docker

REM Виведення повідомлення про запуск служби minikube та її запуск.
echo Starting minikube...
minikube start --driver=docker

REM Визначення змінних середовища для Docker.
@FOR /F "tokens=*" %%i IN ('minikube docker-env') DO @%%i
REM @FOR - запуск цикла виконання для кожного рядка команди, яка знаходиться у IN (). Для цього файлу це minikube docker-env.
REM "tokens=*" - параметр, що вказує розбирати всі токени (слова) в кажному рядку.
REM %%i - змінна, яка представляє кожен рядок для циклу FOR.
REM IN ('minikube docker-env') параметр, що вказує команду, яку необхідн обробляти у циклі FOR.
REM DO %%i - вказується, що для кожного рядку, виконання команди 'minikube docker-env' виконується команда, що збережена у змінній %%i. Ключове слово @ призначене для виведення результатів роботи цієї команди.

REM Побудова образу Docker, використовуючи внутрышный реєстр minikube.
echo /Building Docker image...
cd %DOCKERDIR%
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker build -t %IMGNAME%
docker tag %IMGNAME% localhost:5000/%IMGNAME%
docker push localhost:5000/%IMGNAME%

REM Створення просторів імен Kubernetes.
echo Setting up Kubernetes namespaces...
cd %KUBERDIR%
kubectl create namespace %NAMESPC%
kubectl create namespace stage
kubectl create namespace prod

REM Встановлення Helm діаграм для кожного середовища.
echo Installing Helm charts...
cd .\python-api\
helm install -f values-dev.yaml api-app-dev .\
helm install -f values-stage.yaml api-app-stage .\
helm install -f values-prod.yaml api-app-prod .\
