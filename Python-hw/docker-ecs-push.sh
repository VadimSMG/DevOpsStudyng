#!bin/bash
cd /home/vad/Документи/DevOpsStudyng/Python-hw
systemctl start docker
#1. Docker image build
echo "Input your Docker image name for build:"
read IMGNAME

if sudo docker build -t "$IMGNAME" .; then
  echo "Image build successfull!"
else
  echo "Image build failed :("
fi
#2. User variables input
echo "Input your ECS name:"
read ECSNAME
#3. Get ECS URL
if ECR=$(aws ecr describe-repositories --repository-names "$ECSNAME" --output json | jq -r '.repositories[0].repositoryUri'); then
  echo "AWS ECS repository found."
else
  echo "AWS ECS repository not found. Did you create it?"
fi
#4. Docker login to ECS
echo "Docker login to AWS"
if aws ecr get-login-password --region "$AWS_DEFAULT_REGION" | sudo docker login --username AWS --password-stdin $(echo "$ECR" | awk -F'/' '{print $1}'); then
  echo "Docker login successfull."
else
  echo "Docker login failed! Check the permissions."
fi
#5. Tagging the created local Docker image 
echo "Docker taging the local image"
if sudo docker tag "$IMGNAME":latest "$ECR":latest; then
  echo "Image tag change successfull."
else
  echo "Image tag change failed!"
fi
#6. Pushing Docker image to ECS
echo "Docker pushing image to ECR"
if sudo docker push "$ECR":latest; then
  echo "Docker image successfully pushed to ECS"
else
  echo "Failed to push Docker image to ECR!"
fi
