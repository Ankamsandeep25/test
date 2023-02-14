#!/bin/bash

# Define project and API access variables
PROJECT_ID=42660645
API_PRIVATE_TOKEN=glpat-9s3aPqFU1smmHxCzTWKh

# Fetch the current running pipeline ID
PIPELINE_ID=$(curl --header "PRIVATE-TOKEN: $API_PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines?status=running" | jq '.[0].id')

# Fetch the current running job ID
JOB_ID=$(curl --header "PRIVATE-TOKEN: $API_PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines/$PIPELINE_ID/jobs" | jq '.[0].id')

# Update the wiki with the latest artifacts link
curl --request PUT --header "PRIVATE-TOKEN: $API_PRIVATE_TOKEN" --data "content=$(curl --header "PRIVATE-TOKEN: $API_PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home" | jq '.content')\n\nArtifacts link: [Artifacts](https://gitlab.com/ankamsandeep/mynodeapp-cicd-project/-/jobs/$JOB_ID/artifacts/browse)" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home"

