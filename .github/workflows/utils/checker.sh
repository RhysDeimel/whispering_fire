#!/bin/bash

set -euxo pipefail

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


# get changes
change_schema="./.github/workflows/utils/change_schema.yml"

# load yml array into a bash array
# need to output each entry as a single line
readarray pipelines < <(yq e -o=j -I=0 '.pipelines[]' $change_schema )

for item in "${pipelines[@]}"; do
    # item is a yaml snippet representing a single entry
    name=$(echo "$item" | yq e '.name' -)
    regex=$(echo "$item" | yq e '.regex' -)
    echo "name: $name"
    echo "regex: $regex"

    # Grep with -e
    # This causes the run to terminate immediately when any pipeline exits with a non-zero status.
    # grep returns a 1 when it doesn't find any match, and thus, terminates immediately.
    # We instead run an OR on the grep command, and exit on anything greater than 1 so we don't
    # clobber other error codes.
    exit_code=0
    result=$(git diff $BASE $COMPARE --name-only | grep -P -c "$regex" || exit_code=$?)
    echo $result
    if (( exit_code > 1 )) ; then
        exit $exit_code
    fi

    echo "$name=$result" >> $GITHUB_OUTPUT
done
