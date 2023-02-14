#!/bin/bash

# Replace these with your GitLab instance URL and project ID
GITLAB_URL=https://gitlab.com/ankamsandeep/employee-portal/
PROJECT_ID=42660645

# Replace this with your private token
PRIVATE_TOKEN=glpat-9s3aPqFU1smmHxCzTWKh

# Get the latest successful pipeline ID
CURRENT_PIPELINE=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "$GITLAB_URL/api/v4/projects/$PROJECT_ID/pipelines?status=success" | jq -r 'sort_by(.id)|.[-1].id')

# Get the latest successful job IDs for the "test" stage
TEST_JOBS=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "$GITLAB_URL/api/v4/projects/$PROJECT_ID/pipelines/$CURRENT_PIPELINE/jobs?stage=test&status=success" | jq -r 'sort_by(.id)|.[-1].id')

# Get the latest successful job IDs for the "build" stage
BUILD_JOBS=$(curl --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "$GITLAB_URL/api/v4/projects/$PROJECT_ID/pipelines/$CURRENT_PIPELINE/jobs?stage=build&status=success" | jq -r 'sort_by(.id)|.[-1].id')

# Generate the links to the artifacts of the "test" stage jobs
TEST_ARTIFACTS=""
for TEST_JOB_ID in $TEST_JOBS; do
  ARTIFACT_URL="$GITLAB_URL/$PROJECT_ID/-/jobs/$TEST_JOB_ID/artifacts/browse"
  TEST_ARTIFACTS="$TEST_ARTIFACTS\n- [Test Artifacts for Job $TEST_JOB_ID]($ARTIFACT_URL)"
done

# Generate the links to the artifacts of the "build" stage jobs
BUILD_ARTIFACTS=""
for BUILD_JOB_ID in $BUILD_JOBS; do
  ARTIFACT_URL="$GITLAB_URL/$PROJECT_ID/-/jobs/$BUILD_JOB_ID/artifacts/browse"
  BUILD_ARTIFACTS="$BUILD_ARTIFACTS\n- [Build Artifacts for Job $BUILD_JOB_ID]($ARTIFACT_URL)"
done

# Update the wiki home page with the links to the artifacts
curl --request PUT --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" --data "content=Latest Artifacts:\n$TEST_ARTIFACTS\n$BUILD_ARTIFACTS" "$GITLAB_URL/api/v4/projects/$PROJECT_ID/wikis/home"
