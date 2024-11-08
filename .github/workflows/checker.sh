#!/bin/bash

# get application code changes

# get IaC changes

# get doc changes

# get test changes

# get config changes

branch_sha=$(echo -n "$BRANCH_NAME" | sha256sum | head -c 7)

echo "branch_sha=$branch_sha"
echo "branch_sha=$branch_sha" >> $GITHUB_OUTPUT
echo "**branch_sha**: \`$branch_sha\`" >> $GITHUB_STEP_SUMMARY
