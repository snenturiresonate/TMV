#!/usr/bin/env bash

SHOULD_CHECK=$(cat /tmp/check-fe2e-coverage.txt || exit 1)

if [[ "$SHOULD_CHECK" = "true" ]]
then
  ./get-coverage.sh
  ./publish-coverage.sh
fi
