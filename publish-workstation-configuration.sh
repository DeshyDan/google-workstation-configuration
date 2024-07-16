declare -A gcp_projects
gcp_projects["adg"]="adg-internal-workstations"

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <project_key>"
    echo "Available projects: ${!gcp_projects[@]}"
    exit 1
fi

PROJECT_ID=${gcp_projects[$1]:-$1}
echo "Selected project: $PROJECT_ID"
gcloud services enable artifactregistry.googleapis.com cloudbuild.googleapis.com --project $PROJECT_ID

gcloud artifacts repositories create default --repository-format=docker \
--location=europe-west1 --project $PROJECT_ID

gcloud builds submit . \
--tag=europe-west1-docker.pkg.dev/$PROJECT_ID/default/my-workstation \
--project $PROJECT_ID