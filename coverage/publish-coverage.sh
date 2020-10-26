#!/bin/bash

source microservices.sh

cd temp || exit 1

# loop through the array of micro-services and get the code coverage for each
for service in "${microServices[@]}"
do
    serviceName=$(echo "${service}" | cut -d ',' -f 1)
    echo "Publishing Coverage for: ${serviceName}"
    cd ${serviceName} || exit 1

    # distinguish this as a Full End to End Integration Test (FE2E) Report
    mv pom.xml.bu pom.xml &> /dev/null
    sed -i.bu 's/<name>/<name>FE2E /g' pom.xml

    # upload the coverage report to SonarQube
    mvn -Dsonar.coverage.jacoco.xmlReportPaths=coverage-report.xml sonar:sonar \
      -Denforcer.skip=true \
      -Dsonar.projectKey="FE2E-${serviceName}" \
      -Dsonar.host.url=http://sonarinternal-450e015e76a7431d.elb.eu-west-2.amazonaws.com/ \
      -Dsonar.login=33c7cba168b3b8c57581f2e60709f854f766c2bc

    # prepare for next service
    cd ..
done


