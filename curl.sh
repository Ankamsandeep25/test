# Current pipeline

#!/bin/bash
#https://gitlab.com/ankamsandeep/employee-portal

# Replace these placeholders with your actual values
PROJECT_ID=42660645
PRIVATE_TOKEN=glpat-9s3aPqFU1smmHxCzTWKh

# Get the current running pipeline ID
CURRENT_PIPELINE=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines?status=running" | jq '.[0].id')

# Get the latest running job ID for the pipeline
CURRENT_JOB=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines/$CURRENT_PIPELINE/jobs?status=running" | jq -r '.[].id' | tail -n 1)

# Update the wiki with the link to the latest job's artifacts
curl --request PUT --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" --data "content=New wiki content with link to current artifacts: [Artifacts for Job $CURRENT_JOB](https://gitlab.com/ankamsandeep/employee-portal/-/jobs/$CURRENT_JOB/artifacts/browse)" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home"
