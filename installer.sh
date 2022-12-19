#!/bin/bash

# Die on any errors
set -e

echo "Listing Lambda functions"
find lambdas -type f -name "setup.py" | while IFS= read -r lambda; do
    echo $lambda
done

echo "Starting our install process"
find lambdas -type f -name "setup.py" | while IFS= read -r lambda; do
    echo "Processing $lambda"
    cd $(dirname "$0")/../$(dirname $lambda)

    pipenv install -e .

    echo "Completed processing $lambda"
    cd -

    echo "Completed while loop for $lambda"
done
