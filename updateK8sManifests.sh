#!/bin/bash

######################################
# Author: Suran Sandeepa
# Date: 4th December 2024
# Description: Update the K8s manifest files in azure repos
# version: v2
######################################


set -xe #enable debug mode

#Set the repository URL
REPO_URL="https://<ACCESS-TOKEN>@dev.azure.com/<AZURE-DEVOPS-ORG-NAME>/voting-app/_git/voting-app"

# Cleanup existing directory if it exists
if [ -d "/tmp/temp_repo" ]; then
    rm -rf /tmp/temp_repo
fi

# Clone the git repository into the /tmp directory
git clone "$REPO_URL" /tmp/temp_repo

# Navigate into the cloned repository directory
cd /tmp/temp_repo

# Check if the Kubernetes manifest file exists
if [ -f "k8s-specifications/$1-deployment.yaml" ]; then
    # Update the image in the Kubernetes manifest
    sed -i "s|image:.*|image: <ACR-REGISTRY-NAME>/$2:$3|g" k8s-specifications/$1-deployment.yaml
else
    echo "File k8s-specifications/$1-deployment.yaml not found!"
    exit 1
fi

# Add the modified files
git add .

# Commit the changes
git commit -m "Update Kubernetes manifest"

# Push the changes back to the repository
git push

# Cleanup: remove the temporary directory
rm -rf /tmp/temp_repo
