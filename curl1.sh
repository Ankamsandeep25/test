#!/bin/bash

# Replace these with your GitLab instance URL and project ID
#GITLAB_URL=https://gitlab.com/ankamsandeep/employee-portal/
#PROJECT_ID=42660645

# Define the API endpoint and API token
API_ENDPOINT="https://gitlab.com/ankamsandeep/employee-portal/"
API_TOKEN="glpat-9s3aPqFU1smmHxCzTWKh"

# Define the pipeline id, project id and stages for which artifacts need to be updated in the wiki
PROJECT_ID=42930219
PIPELINE_ID=$(curl --header "PRIVATE-TOKEN: $API_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines?status=running" | jq '.[0].id')
STAGES="test build"

# Loop through the stages and get the latest successful job for each stage
for stage in $STAGES; do
  JOB_ID=$(curl --header "PRIVATE-TOKEN: $API_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines/$PIPELINE_ID/jobs?stage=$stage&status=success" | jq '.[0].id')
  ARTIFACT_LINK="https://gitlab.com/ankamsandeep/mynodeapp-cicd-project/-/jobs/$JOB_ID/artifacts/browse"

  # Update the wiki page with the latest artifact link for the current stage
  curl --request PUT --header "PRIVATE-TOKEN: $API_TOKEN" --data "content=$(curl --header "PRIVATE-TOKEN: $API_TOKEN" "$API_ENDPOINT" | jq '.content' -r)\n\nArtifacts for $stage stage: [Artifacts]($ARTIFACT_LINK) updated on $(date +'%Y-%m-%d %H:%M:%S')" "$API_ENDPOINT"
done
