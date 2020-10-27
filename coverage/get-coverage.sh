#!/usr/bin/env bash

source microservices.sh

# environment variables
stackName=${STACK_NAME:-tmv-national-test-coverage}
ciIpAddress=${CI_IP_ADDRESS:-}

# install Jacoco
sudo apt-get install unzip
rm -rf /tmp/jacoco 2> /dev/null
mkdir /tmp/jacoco
wget --no-check-certificate -O /tmp/jacoco/jacoco.zip http://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/0.8.6/jacoco-0.8.6.zip
unzip /tmp/jacoco/jacoco.zip -d /tmp/jacoco

# get the IP address from AWS if it is not an environment variable
function getIpAddress
{
  ipAddress=""
  ipAddress=$(aws cloudformation describe-stacks --region eu-west-2 --stack-name ${stackName} | grep -A 4 Outputs | grep OutputValue | cut -d "\"" -f4)
  echo ${ipAddress}
}

if [[ ! "$ciIpAddress" ]]
then
    ciIpAddress=$(getIpAddress)
    echo "Found IP Address: ${ciIpAddress}"
fi

# create working directory
rm -rf temp 2> /dev/null
mkdir temp 2> /dev/null

# create directory with name of current date and time
workingDirectory="temp"

# update the output variable
echo ${workingDirectory} > /tmp/workingDirectory.txt
cd temp || exit 1

# loop through the array of micro-services and get the code coverage for each
for service in "${microServices[@]}"
do
    serviceName=$(echo "${service}" | cut -d ',' -f 1)
    coveragePort=$(echo "${service}" | cut -d ',' -f 2)
    echo "Getting Coverage for: ${serviceName}, Port: ${coveragePort}"

    # create directory with name of micro-service
    git clone https://2fbhqxyumyhp6rxvevw6z3ce67pkvxdm7yfe53pnzq3x6yf2q3xq@resonatevsts.visualstudio.com/Luminate-TMV/_git/${serviceName}

    # get code coverage binary for micro-service
    java -jar /tmp/jacoco/lib/jacococli.jar dump --address ${ciIpAddress} --port ${coveragePort} --destfile ${serviceName}/jacoco-coverage.exec --reset

    # build the code for the micro-service
    cd ${serviceName} || exit 1
    mvn clean compile -Denforcer.skip=true

    # generate code coverage report for micro-service
    mkdir coverage-report
    java -jar /tmp/jacoco/lib/jacococli.jar report jacoco-coverage.exec --classfiles target/classes/ --sourcefiles src/main/java/ --html coverage-report/ --xml "coverage-report.xml"

    # prepare for next service
    cd ..
done
