declare -A gcp_projects
gcp_projects["adg"]="adg-internal-workstations"
gcp_projects["gw"]="grant-wilson"

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <project_key> <workstation_name>"
    echo "Available projects: ${!gcp_projects[@]}"
    exit 1
fi

PROJECT_KEY=$1
WORKSTATION_NAME=$2
PROJECT_ID=${gcp_projects[$PROJECT_KEY]:-$PROJECT_KEY}
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com --project $PROJECT_ID

gcloud artifacts repositories create default --repository-format=docker \
--location=europe-west1 --project $PROJECT_ID

gcloud builds submit . \
--tag=europe-west1-docker.pkg.dev/$PROJECT_ID/default/$WORKSTATION_NAME \
--project $PROJECT_ID