#!/bin/bash
#Get servers list
apk update 
apk add git
apk add openssh
# Setup SSH deploy keys
eval $(ssh-agent) 
mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" | tr -d '\r' > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa
ssh-keyscan -H $DEPLOY_SERVER >> ~/.ssh/known_hosts
