#!bin/bash
IMGNAME="backend:test"
DOCKERDIR="../Python-hw/"
KUBERDIR="../kuber/"
NAMESPC="dev"
systemctl start docker
minikube start --driver=docker
eval $(minikube docker-env)
cd $DOCKERDIR
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker build -t $IMGNAME .
docker tag $IMGNAME localhost:5000/$IMGNAME
docker push localhost:5000/$IMGNAME
cd $KUBERDIR
kubectl create namespace dev
kubectl create namespace stage
kubectl create namespace prod
cd ./python-api/
helm install -f values-dev.yaml api-app-dev ./
helm install -f values-stage.yaml api-app-stage ./
helm install -f values-prod.yaml api-app-prod ./
