#!/bin/bash

# Check if project ID and workstation name are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project_id>"
    exit 1
fi
PROJECT_ID=$1

# Submit a build to Cloud Build
echo "** Submitting the build to Cloud Build **"
gcloud builds submit . --tag=us-central1-docker.pkg.dev/$PROJECT_ID/default/vscode --project $PROJECT_ID
echo "** Submitted the build to Cloud Build **"
