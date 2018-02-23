#!/bin/bash

cd /couchdb/src/hastings/sample
first_test=$(python loader.py)

if [[ ${first_test} != *"Response [200]"* ]]; then
  printf "loader.py test output was: %s" $first_test
  exit 1
fi
