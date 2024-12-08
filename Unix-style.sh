#!/bin/bash
set -xe

#Set the repository URL
REPO_URL="https://F5mvVOshkUUUwt3qHZTlLOEvQAzCrY77YtnfGZs0WPDlEn7TQ4NwJQQJ99ALACAAAAAAAAAAAAASAZDOXYYD@dev.azure.com/sandeepauththamawadu/voting-app/_git/voting-app"

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
    sed -i "s|image:.*|image: susanazurecicd/$2:$3|g" k8s-specifications/$1-deployment.yaml
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
