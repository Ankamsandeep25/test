#!/bin/bash
#For complete information check Notepad ++
# Replace these placeholders with your actual values
CI_PROJECT_ID="42660645"
TOKEN="glpat-9s3aPqFU1smmHxCzTWKh"
PROJECT_ID=$CI_PROJECT_ID
PRIVATE_TOKEN=$TOKEN

# To get the current running pipeline ID

CURRENT_PIPELINE=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines?status=running" | jq '.[0].id')

# Get the IDs of all the running jobs for the pipeline that match the job names "test" and "build"

RUNNING_JOB_IDS_ARRAY=($(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/pipelines/$CURRENT_PIPELINE/jobs?status=running" | jq -r '.[] | select(.name | contains("test") or contains("build")) | .id'))

# Loop over all the running jobs and generate links to their artifacts
LINKS=""
for JOB_ID in "${RUNNING_JOB_IDS_ARRAY[@]}"; do
    ARTIFACTS_LINK="[Artifacts for Job $JOB_ID](https://gitlab.com/ankamsandeep/employee-portal/-/jobs/$JOB_ID/artifacts/browse)"
    LINKS="$LINKS $ARTIFACTS_LINK\n"
done

# Get the current date and time
DATE_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Get the current content of the wiki page
WIKI_CONTENT=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home" | jq -r '.content')

# Append the links to the wiki content and update the wiki page
NEW_WIKI_CONTENT="$WIKI_CONTENT<br><br>Links to current artifacts as of $DATE_TIME:<br><br>$LINKS<br><br>"
curl --request PUT --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" --data "content=$NEW_WIKI_CONTENT" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/home"
