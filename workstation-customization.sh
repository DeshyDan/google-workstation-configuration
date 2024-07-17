#!/bin/bash

CODEOSS_PATH="/home/user/.codeoss-cloudworkstations"
chown -R user:user /home/user
chown -R user:user /opt/workstation
chmod -R 755 /opt/workstation

# Get the SSH key from Secret Manager
# Use the USER environment variable to access the correct secret
SSH_KEY=$(gcloud secrets versions access latest --secret="${USER}_ssh_key")

# Write the key to .ssh/id_rsa
mkdir -p ~/.ssh
echo "$SSH_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Add GitHub (or your git server) to known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Clone your repository
git clone git@github.com:your/repo.git

# Run your scripts
bash repo/script.sh