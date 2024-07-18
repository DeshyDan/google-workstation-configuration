#!/bin/bash

# Check if project ID and service account are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ./permissions.sh [PROJECT_ID] [USER]"
    echo "Usage: ./permissions.sh grant-wilson-3 grant.wilson@africadigitalgroup.com"
    exit 1
fi
PROJECT_ID=$1
USER=$2

# Get the service account
SERVICE_ACCOUNT=$(gcloud iam service-accounts list --project=$PROJECT_ID --format="value(email)" --filter="displayName:'Compute Engine default service account'")
if [ -z "$SERVICE_ACCOUNT" ]; then
    echo "Error: Service account not found."
    exit 1
fi

# Enable APIs and create artifacts repository
gcloud services enable compute.googleapis.com --project $PROJECT_ID
gcloud services enable workstations.googleapis.com --project $PROJECT_ID
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com --project $PROJECT_ID

# Check if the artifacts repository exists then create it
output=$(gcloud artifacts repositories describe default --location=us-central1 --project=$PROJECT_ID 2>&1)
if [[ $output == *"ERROR"* ]]; then
  gcloud artifacts repositories create default --repository-format=docker --location=us-central1 --project=$PROJECT_ID
fi

# Add IAM policy binding
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/cloudbuild.builds.builder
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/storage.admin
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/viewer
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=roles/serviceusage.serviceUsageConsumer
# gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT --role=roles/storage.objectAdmin
# gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$SERVICE_ACCOUNT --role=roles/artifactregistry.writer
