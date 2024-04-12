# Параметр вказує виводити (on) чи ні (off) результат виконання команд у командному рядку.
Write-Output off

#Визначення значень змінних для використання у скрипті.
Write-Output "Please, check that you run this script from local Helm project repository."
Write-Output "Setting script variables."
$VM_DRIVER = Read-Host "Chouse your VM eviroment for minkube: 1 - VirtualBox, 2 - Docker"
switch ($VM_DRIVER) {
    "1" {
        Write-Output "Starting VirtualBox..."
        $MINIKUBE_DRIVER = "virtualbox"
        Start-Process -FilePath "C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
    }
    "2" {
        Write-Output "Starting Docker Desktop..."
        $MINIKUBE_DRIVER = "docker"
        Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    }
}
$HELM_PJ_DIR = Read-Host "Input path to your Helm project dir:" REM Запит на введення розташування шаблонів проекту Helm.
#$HELM_PJ_DIR = "C:\Users\vadim\Навчання\DevOps\DevOpsStudyng\kuber\micro-app"
$DOCKER_PASSWORD = Read-Host "Input GitLab token:" # Запит на введеня значення токену досутпу до реєстру образів Gitlab.
$DOCKER_USERNAME = Read-Host "Input GitLab e-maIl:"
#$DOCKER_USERNAME = "vadimsmg@gmail.com"
#$GITLAB_REG = Read-Host "Input your GitLab Container Registry URL:"
$GITLAB_REG = "https://registry.gitlab.com"
# Визначння назв просторів імен для кластеру.
$NAMESPACES = Read-Host "Input your namespaces names (separated by commas):"
#$NAMESPACES = "dev", "stage", "prod"

#Запуск кластеру minikube.
Write-Output "Starting minikube..."
minikube start --driver=$MINIKUBE_DRIVER --no-vtx-check

Write-Output "Setting up cluster namespaces..."
# Цикл, що сворює namespaces у кластері.
foreach ($names in $NAMESPACES) {
    kubectl create namespace $names
}

Write-Output "Creating secrets for namespaces..."
$SECRET_NAME = Read-Host "Input your kubernetes secret name"
# Цикл, що створює секрет для кожного namespace.
foreach ($name in $NAMESPACES) {    
    kubectl create secret docker-registry $SECRET_NAME -n $name --docker-server=$GITLAB_REG --docker-username=$DOCKER_USERNAME --docker-password=“$DOCKER_PASSWORD” --docker-email=$DOCKER_USER
}

Write-Output "Creating Kubernetes claster via Helm charts..."
Set-Location $HELM_PJ_DIR
$HELM_PJ_NAME = Read-Host "Input name of your project"
# Цикл, що створює масив з іменами конфігурацій для Helm.
foreach ($name in $NAMESPACES) {
    $HELM_NAMES += $HELM_PJ_NAME + "-" + $name
}
$HELM_VALUES = @()
# Цикл, що створює масив для імен файлів values для Helm.
foreach ($name in $NAMESPACES) {
    $HELM_VALUES += Read-Host "Input Helm values filename for environment -" $name "(sample: values-dev.yaml)"
}
Write-Output "Creating cluster for dev namespace."
helm install -f $HELM_VALUES[0] $HELM_NAMES[0] .
Write-Output "Creating cluster for stage namespace"
helm install -f $HELM_VALUES[1] $HELM_NAMES[1] .
Write-Output "Creating cluster for prod namespace"
helm install -f $HELM_VALUES[2] $HELM_NAMES[2] .