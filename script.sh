#!/bin/sh

APPS=$(git diff --name-only HEAD~1 | awk -F "/*[^/]*/*$" '{ print ($1 == "" ? "." : $1); }' | sort | uniq | grep apps | cut -d/ -f2)
SHA=$(git rev-parse --short HEAD)
arr=("doc" "web")

# for app in $APPS
# do
  # echo "docker build -f apps/$app/Dockerfile -t=$app:$SHA"

# done

echo ${arr[@]} | jq -csR 'split(" ")'

