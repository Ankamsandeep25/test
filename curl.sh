#!/bin/bash

# Replace with your GitLab project ID
PROJECT_ID="42660645"

# Replace with your GitLab access token
ACCESS_TOKEN="glpat-9s3aPqFU1smmHxCzTWKh"

# Stages for which artifacts links should be updated
STAGES=("build" "test")

for STAGE in "${STAGES[@]}"; do
  # Get the latest pipeline ID
  PIPELINE_ID=$(curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines?status=running" | jq '.[0].id')

  # Get the job ID for the stage
  JOB_ID=$(curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines/$PIPELINE_ID/jobs" | jq ".[] | select(.stage == \"$STAGE\") | .id")

  # Get the artifacts URL for the stage
  ARTIFACTS_URL="https://gitlab.com/api/v4/projects/$PROJECT_ID/jobs/$JOB_ID/artifacts"

  # Get the current content of the wiki home page
  WIKI_CONTENT=$(curl --header "PRIVATE-TOKEN: $ACCESS_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home" | jq '.content')

  # Update the wiki home page with the new artifacts link
  curl --request PUT --header "PRIVATE-TOKEN: $ACCESS_TOKEN" --header "Content-Type: application/json" --data "{\"content\":\"$WIKI_CONTENT\n\nArtifacts for $STAGE stage: [Artifacts]($ARTIFACTS_URL) updated on $(date)\n\"}" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home"
done
