#!/usr/bin/env bash

# Change to directory of script
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" || echo "Could not change directory, exiting." #&& exit 1
# Set up test parameters
STACK_NAME=${STACK_NAME:-tmv-national-test-coverage}
CUCUMBER_TAGS=${CUCUMBER_TAGS:-"not (@bug or @tdd)"}

if [[ -z "$STACK_NAME" ]]
then
  echo "Error: No stack name provided, exiting."
  exit 1;
fi

# This shouldn't be needed anymore, but lets keep it for a while, just in case.
#echo "Logging into AWS."
## For AWS CLI version 1
#$(aws ecr get-login --region eu-west-2 --no-include-email) &> /dev/null
## For AWS CLI version 2
##aws --region eu-west-2 ecr get-login-password &> /dev/null

echo "Looking for environment with the Stack Name: $STACK_NAME"
STACK_DETAILS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" 2> /dev/null)

if [[ -z "$STACK_DETAILS" ]]
then
  echo "Could not find an environment with the Stack Name: $STACK_NAME"
  exit 1;
fi

TEST_HARNESS_IP=${TEST_HARNESS_IP:-$(echo "$STACK_DETAILS" | grep -A 4 Outputs | grep OutputValue | cut -d'"' -f 4)}
CREATION_TIME=$(echo "$STACK_DETAILS" | grep CreationTime | cut -d'"' -f 4)
TMV_DOMAIN=${TMV_DOMAIN:-"tmv-national-test-fe2e.tmv.resonate.tech"}

if [[ -z "$TEST_HARNESS_IP" ]] || [[ -z "$CREATION_TIME" ]]
then
  echo "Could not find an environment with the Stack Name: $STACK_NAME, exiting."
  exit 1;
fi

echo "Found $TEST_HARNESS_IP created at $CREATION_TIME"

# Run the full end to end tests
echo "CUCUMBER_TAGS: ${CUCUMBER_TAGS}"
echo "test_harness_ci_ip: ${TEST_HARNESS_IP}"
export npm_config_ci_ip="${TMV_DOMAIN}"; export npm_config_test_harness_ip="${TEST_HARNESS_IP}"; export cucumber_tags="${CUCUMBER_TAGS}"; npm run fe2e

# Generate JUnit style XML to support VSTS reporting
npm run junit-xml

# Print a brief summary
passed=$(cat .tmp/results.json | grep passed | wc -l)
failed=$(cat .tmp/results.json | grep failed | wc -l)
echo -e "Passed: ${passed}"
echo -e "Failed: ${failed}"

# Exit with the total failures to allow CI build jobs to fail if any tests failed
exit "${failed}"
