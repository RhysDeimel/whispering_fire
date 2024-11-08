#!/bin/bash

# get general job data
branch_sha=$(echo -n "$BRANCH_NAME" | sha256sum | head -c 7)
echo "branch_sha=$branch_sha"
echo "branch_sha=$branch_sha" >> $GITHUB_OUTPUT
echo "**branch_sha**: \`$branch_sha\`" >> $GITHUB_STEP_SUMMARY


workload_version=$(cat "$VERSION_FILE_PATH" | cut -d "'" -f 2)
echo "workload_version=$workload_version"
echo "workload_version=$workload_version" >> $GITHUB_OUTPUT
echo "**workload_version**: \`$workload_version\`" >> $GITHUB_STEP_SUMMARY

image_tag="$workload_version-$branch_sha"
echo "image_tag=$image_tag"
echo "image_tag=$image_tag" >> $GITHUB_OUTPUT
echo "**image_tag**: \`$image_tag\`" >> $GITHUB_STEP_SUMMARY

# get application code changes

# get IaC changes

# get doc changes

# get test changes

# get config changes


