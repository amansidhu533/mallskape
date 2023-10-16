#!/bin/bash
# Get list:
bash
sudo apt-get update -y
#sudo apt-get -y install python-pip \
#pip install docker-compose
sudo docker login registry.gitlab.com -u vikramsingh@nestorbird.com -p Pass@world1
# Variables from GitLab server:
# Note: They can’t have spaces!!
bash
sudo docker --version
sudo docker stop NopCommerce
sudo docker rm NopCommerce
sudo docker rmi registry.gitlab.com/nhkteam/nhk-food-4.2
sudo docker images
sudo docker pull registry.gitlab.com/nhkteam/nhk-food-4.2:latest
sudo docker run -d -p 8080:80 --name NopCommerce registry.gitlab.com/nhkteam/nhk-food-4.2 
sudo docker ps -a 
