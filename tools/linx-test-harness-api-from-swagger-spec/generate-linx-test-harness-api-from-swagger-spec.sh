#!/usr/bin/env bash
#
# Script to automate generating code based on a swagger spec
#
# For more info, see:
# - https://github.com/RSuter/NSwag/wiki/SwaggerToTypeScriptClientGenerator
#
# Make sure we're at the root of the repo.
repo_dir=$(dirname $0)/../..
cd $repo_dir || exit

# Install ng-swagger-gen
#npm install ng-swagger-gen --save-dev

# Generate REST Client
node_modules/.bin/ng-swagger-gen -i tools/linx-test-harness-api-from-swagger-spec/openapi.json -o tmp/linx-test-harness-generated-api.service.ts
