PROJECT_ID=grant-wilson
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com --project $PROJECT_ID

gcloud artifacts repositories create default --repository-format=docker \
--location=europe-west1 --project $PROJECT_ID

gcloud builds submit . \
--tag=europe-west1-docker.pkg.dev/$PROJECT_ID/default/my-workstation \
--project $PROJECT_ID