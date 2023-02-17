#!/bin/bash

# Extract the X-Gitlab-Token header from the incoming request
gitlab_token=$(curl -sI -H "X-Gitlab-Token: " "$1" | grep -i X-Gitlab-Token | awk '{print $2}' | tr -d '\r')

# Get the secret token from an environment variable
secret_token="$GITLAB_SECRET_TOKEN"

# Compare the GitLab token to the secret token
if [[ "$gitlab_token" != "$secret_token" ]]; then
  # Reject the request
  exit 1
fi

# GitLab API token
TOKEN="$TOKEN"

# GitLab project ID
PROJECT_ID="$CI_PROJECT_ID"

# Wiki page name
WIKI_PAGE_NAME="Home"

# Get the most recent artifacts for each stage
STAGES=(build test deploy)
for stage in "${STAGES[@]}"; do
  response=$(curl --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/projects/$PROJECT_ID/jobs/artifacts/$stage/download?job=$CI_JOB_NAME")
  link=$(echo "$response" | jq -r '.url')
  title=$(echo "$response" | jq -r '.metadata.name')
  links="$links\n- [$stage]($link) - $title"
done

# Update the wiki page with the new links
curl --request PUT --header "PRIVATE-TOKEN: $TOKEN" --header "Content-Type: application/json" --data "{\"content\": \"$links\"}" "https://gitlab.com/api/v4/projects/$PROJECT_ID/wikis/$WIKI_PAGE_NAME"
