#!/bin/bash

# Check if project ID and service account are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ./permissions.sh [PROJECT_ID] [USER]"
    echo "Usage: ./permissions.sh adg-internal-workstations grant.wilson@africadigitalgroup.com"
    exit 1
fi
PROJECT_ID=$1
USER=$2

# Remove IAM policy binding
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/iam.serviceAccountUser
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/storage.objectAdmin
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/artifactregistry.writer
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/cloudbuild.builds.builder
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/serviceusage.serviceUsageConsumer
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/storage.admin
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/storage.objectAdmin
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/viewer
gcloud projects remove-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/storage.objectCreator
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/storage.objectAdmin