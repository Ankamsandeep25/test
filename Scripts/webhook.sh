#!/bin/bash

# GitLab API token
TOKEN="glpat-9s3aPqFU1smmHxCzTWKh"

# GitLab project ID
PROJECT_ID="42660645"

# Wiki page name
WIKI_PAGE_NAME="https://gitlab.com/ankamsandeep/employee-portal/-/wikis/home"

# Get the most recent artifacts for each stage
STAGES=(build test deploy)
links=""
for stage in "${STAGES[@]}"; do
  response=$(curl --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/jobs/artifacts/$stage/download?job=$CI_JOB_NAME")
  link=$(echo "$response" | jq -r '.url')
  title=$(echo "$response" | jq -r '.metadata.name')
  date=$(date '+%Y-%m-%d %H:%M:%S')
  links="$links\n- [$stage]($link) - $title ($date)"
done

# Update the wiki page with the new links
curl --request PUT --header "PRIVATE-TOKEN: $TOKEN" --header "Content-Type: application/json" --data "{\"content\": \"$links\"}" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/$WIKI_PAGE_NAME"
