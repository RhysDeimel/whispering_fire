#!/bin/bash

set -euxo pipefail

# Check semver by turning it into a 7 digit int for comparison
function semver_to_int { echo "$@" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'; }

compare_semver=$(head "$VERSION_FILE_PATH" -n 1 | cut -d "'" -f 2)
base_semver=$(head "$VERSION_FILE_PATH" -n 1 | cut -d "'" -f 2)

if [ "$(semver_to_int "$base_semver")" -ge "$(semver_to_int "$compare_semver")" ]; then
    echo -e "\e[31;1mError:\e[0m Version needs incrementing!"
    echo "  Merge target is: $base_semver"
    echo "  Current branch is: $compare_semver"
    exit 1
fi
