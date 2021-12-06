#!/usr/bin/env bash

# Change to directory of script
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" || echo "Could not change directory, exiting." #&& exit 1
# Set up test parameters
STACK_NAME=${STACK_NAME:-tmv-national-develop-suffix}
CUCUMBER_TAGS=${CUCUMBER_TAGS:-"not (@bug or @tdd or @manual)"}
DYNAMO_SUFFIX=${DYNAMO_SUFFIX:-"${STACK_NAME}"}
REDIS_PORT=${REDIS_PORT:-"8082"}
PR_RUN=${PR_RUN:-false}
SMOKE_TEST=${SMOKE_TEST:-false}

# ensure aws cli is installed
sudo apt-get -y install awscli
pip3 install --upgrade awscli

if [[ -z "$STACK_NAME" ]]
then
  echo "Error: No stack name provided, exiting."
  exit 1;
fi

echo "Looking for environments containing the Stack Name: $STACK_NAME"
INSTANCES_TO_TEST=[]
ipIndex=0
while read stack
do
  stackIp=$(echo ${stack} | jq '.stackIP' | tr -d '"')
  stackName=$(echo ${stack} | jq '.stackName' | tr -d '"')
  INSTANCES_TO_TEST[${ipIndex}]="${stackIp},${stackName}"
  ipIndex=$(( ipIndex + 1 ))
done < <(./node_modules/ts-node/dist/bin.js src/app/util/stack.interrogator.ts --stack ${STACK_NAME} -l | jq -c ".stacks[${i}]" | jq -c)

echo "Found the following environments: ${INSTANCES_TO_TEST[*]}"

# Get an array of the features that need to be executed
listFeaturesCommand="ls e2e/src/app/features/**/*.feature | sort | uniq -u | tr -s ' '"
if [[ ${PR_RUN} == "true" ]]
then
  listFeaturesCommand="git --no-pager diff --name-only origin/develop | grep -e '\.feature'"
fi
if [[ ${SMOKE_TEST} == "true" ]]
then
  listFeaturesCommand="grep SmokeTest e2e/src/app/features/**/*.feature | cut -d ':' -f 1"
fi
featureIndex=0
while read -r feature
do
  featureList[${featureIndex}]=${feature}
  featureIndex=$((featureIndex+1))
done < <(bash -c "${listFeaturesCommand}")

featureCount=${#featureList[*]}
echo "Found ${featureCount} features"

# Execute the features across the available FE2E instances
fe2eInstanceCount=${#INSTANCES_TO_TEST[*]}
echo "Found ${fe2eInstanceCount} FE2E instance(s)"
featuresToRunPerInstance=$((${featureCount}/${fe2eInstanceCount}))
echo "Will run ${featuresToRunPerInstance} features per instance"

for (( i=0; i<${fe2eInstanceCount}; i++ ))
do
   startIndex=$((i*${featuresToRunPerInstance}))
   if (( ${i} == (${fe2eInstanceCount} - 1) ))
   then
     endIndex=$(( ${featureCount} - 1 ))
   else
     endIndex=$((${startIndex}+${featuresToRunPerInstance}-1))
   fi

   TEST_HARNESS_IP=$(echo ${INSTANCES_TO_TEST[${i}]} | cut -d ',' -f 1)
   ENVIRONMENT_NAME=$(echo ${INSTANCES_TO_TEST[${i}]} | cut -d ',' -f 2)
   DYNAMO_SUFFIX=${ENVIRONMENT_NAME}
   REDIS_HOST=${REDIS_HOST:-${TEST_HARNESS_IP}}
   SPECS_TO_RUN=${featureList[${startIndex}]}
   TMV_DOMAIN=$(./node_modules/ts-node/dist/bin.js src/app/util/cognito.interrogator.ts -s ${ENVIRONMENT_NAME} | jq '.logoutUrl' | tr -d '"' | cut -d '/' -f 3)

   for (( feature=$(( startIndex + 1 )); feature<=${endIndex}; feature++ ))
   do
     SPECS_TO_RUN="${SPECS_TO_RUN},${featureList[${feature}]}"
   done
   echo "Start Index: ${startIndex}, End Index: ${endIndex} to run on ${TEST_HARNESS_IP}, ${TMV_DOMAIN}"

  # Run the full end to end tests
  echo "CUCUMBER_TAGS: ${CUCUMBER_TAGS}"
  echo "SPECS_TO_RUN: ${SPECS_TO_RUN}"
  echo "DYNAMO_SUFFIX: ${DYNAMO_SUFFIX}"
  echo "test_harness_ci_ip: ${TEST_HARNESS_IP}"
  echo "npm_config_redis_host: ${REDIS_HOST}"
  echo "npm_config_redis_port: ${REDIS_PORT}"
  export npm_config_ci_ip="${TMV_DOMAIN}";\
    export npm_config_test_harness_ip="${TEST_HARNESS_IP}";\
    export npm_config_redis_host="${REDIS_HOST}";\
    export npm_config_redis_port="${REDIS_PORT}";\
    export cucumber_tags="${CUCUMBER_TAGS}";\
    export specs_to_run="${SPECS_TO_RUN}";\
    export dynamo_suffix="${DYNAMO_SUFFIX}";\
    npm run fe2e &

  # Record the background process ID so that we can wait for it later
  testProcessIds[${i}]=${!}
done

# wait for all testing processes to finish
for pid in ${testProcessIds[*]}
do
  echo "Waiting for process ${pid} to finish"
  wait $pid
done

# Merge the json files into a single results file
npm run json-merge

# Generate JUnit style XML to support VSTS reporting
npm run junit-xml

# Print a brief summary
passed=$(cat .tmp/results.json | jq | grep \"passed\" | wc -l | tr -s ' ')
failed=$(cat .tmp/results.json | jq | grep \"failed\" | wc -l | tr -s ' ')
echo -e "Passed: ${passed}"
echo -e "Failed: ${failed}"

# Exit with the total failures to allow CI build jobs to fail if any tests failed
exit "${failed}"
