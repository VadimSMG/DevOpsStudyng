REM Параметр вказує виводити (on) чи ні (off) результат виконання команд у командному рядку.
@echo off

REM Визначення значень змінних для використання у скрипті.
echo "Please, check that you run this script from local Helm project repository."
echo "Setting script variables."
$VM_DRIVER = Read-Host "Chouse your VM eviroment for minkube: 1 - VirtualBox, 2 - Docker"
switch ($VM_DRIVER) {
    "1" {
        echo "Starting VirtualBox..."
        $MINIKUBE_DRIVER = "virtualbox"
        Start-Process -FilePath "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
        }
    "2" {
        echo "Starting Docker Desktop..."
        $MINIKUBE_DRIVER = "docker"
        Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        }
}
REM $HELM_PJ_DIR = Read-Host "Input path to your Helm project dir:" REM Запит на введення розташування шаблонів проекту Helm.
$HELM_PJ_DIR = "C:\Users\vadim\Навчання\DevOps\DevOpsStudyng\kuber\micro-app"
$DOCKER_PASSWORD = Read-Host "Input GitLab token:" REM Запит на введеня значення токену досутпу до реєстру образів Gitlab.
REM $DOCKER_USERNAME = Read-Host "Input GitLab e-maIl:"
$DOCKER_USERNAME = "vadimsmg@gmail.com"
REM $GITLAB_REG = Read-Host "Input your GitLab private URL:"
$GITLAB_REG = "https://registry.gitlab.com"
REM Визначння назв просторів імен для кластеру.
REM $NAMESPACES = Read-Host "Input your namespaces names (separated by commas):"
$NAMESPACES = "dev", "stage", "prod"
REM Запуск кластеру minikube.
echo "Starting minikube..."
minikube start --driver=$MINIKUBE_DRIVER --no-vtx-check

echo "Setting up cluster namespaces..."
REM Цикл, що сворює namespaces у кластері.
foreach ($names in $NAMESPACES) {
    kubectl create namespace $names
}
REM kubectl create namespace $NAMESPACES[0]
REM kubectl create namespace $NAMESPACES[1]
REM kubectl create namespace $NAMESPACES[2]

echo "Creating secrets for namespaces..."
$SECRET_NAME = Read-Host "Input your kubernetes secret name"
REM  Цикл, що створює секрет для кожного namespace.
foreach ($name in $NAMESPACES) {    
    kubectl create secret docker-registry $SECRET_NAME -n $name --docker-server=$GITLAB_REG --docker-username=$DOCKER_USERNAME --docker-password=“$DOCKER_PASSWORD” --docker-email=$DOCKER_USER
}
REM kubectl create secret docker-registry $SECRET_NAME -n $NAMESPACES[0] --docker-server=$GITLAB_REG --docker-username=$DOCKER_USER --docker-password=“$DOCKER_PASSWORD” --docker-email=$DOCKER_USER
REM kubectl create secret docker-registry $SECRET_NAME -n $NAMESPACES[1] --docker-server=$GITLAB_REG --docker-username=$DOCKER_USER --docker-password=“$DOCKER_PASSWORD” --docker-email=$DOCKER_USER
REM kubectl create secret docker-registry $SECRET_NAME -n $NAMESPACES[2] --docker-server=$GITLAB_REG --docker-username=$DOCKER_USER --docker-password=“$DOCKER_PASSWORD” --docker-email=$DOCKER_USER

echo "Creating Kubernetes claster via Helm charts..."
cd $HELM_PJ_DIR
$HELM_PJ_NAME = Read-Host "Input name of your project"
REM Цикл, що створює масив з іменами конфігурацій для Helm.
foreach ($name in $NAMESPACES) {
    $HELM_NAMES += $HELM_PJ_NAME + "-" + $name
}
$HELM_VALUES = @()
REM Цикл, що створює масив для імен файлів values для Helm.
foreach ($name in $NAMESPACES) {
    $HELM_VALUES += Read-Host "Input Helm values filename for" $name "environment (sample: values-dev.yaml)"
}
echo "Creating cluster for dev namespace."
helm install -f $HELM_VALUES[0] $HELM_NAMES[0] .
echo "Creating cluster for stage namespace"
helm install -f $HELM_VALUES[1] $HELM_NAMES[1] .
echo "Creating cluster for prod namespace"
helm install -f $HELM_VALUES[2] $HELM_NAMES[2] .