/*terraform {
  required_providers { #Вказання обов'язковим ресурсом наявність Kubernetes.
    kubernetes = {
        config_path = "%USERNAME%/.kube/config" #Вказуємо шлях до конфігурації кластеру Kubernetes.
    }
  }
}*/
provider "kubernetes" {
  config_path = "%USERNAME%/.kube/config" #Шлях до файлу конфігурації кластеру.
}

resource "kubernetes_pod" "test-pod" { #Використання вбудованого ресурсу для Kubernetes.
  metadata {
    name = "this-test-pod" #Ім'я створюваного поду.
  }

  spec {
    container {
      name  = "this-test-container" #Ім'я створюваного контейнеру.
      image = "ubuntu:latest"       #Ім'я та тег образу для розгортання поду.
    }
  }
}