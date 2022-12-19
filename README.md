# pipenv ate my while loop

We have various Lambda functions in our CDK project that each have a `handler.py` file that is executed on AWS Lambda.

To automate unit testing on our CI/CD process, we use `find` to automatically iterate over each of our Lambda functions and install their specific dependencies using `pipenv` and then run `pytest`  withnin that environmment.

As of this weekend, our build process is failing because `pipenv` `2022.12.17` is eating our while loop and preventing all of our Lambda functions from being installed and tested.


## Reproducing the issue

### Working command

```
docker build --build-arg VERSION=2022.11.30 -t foo:latest .
```

### Failing command

```
docker build --build-arg VERSION=2022.12.17 -t foo:latest .
```

To debug:

* Comment out `RUN ls -lah lambdas/lambda-1/build/ && ls -lah lambdas/lambda-2/build/` in `Dockerfile`
* Run docker build --build-arg VERSION=2022.12.17 -t foo:latest . && docker run -it foo:latest /bin/bash

The diff of `pipenv` v2022.11.30 to v2022.12.17 can be found at https://github.com/pypa/pipenv/compare/v2022.11.30...v2022.12.17


## Hints

* It doesn't look like `pipenv` is raising an exit code that is stopping our script.
* The script below appears to work, so perhaps the while read is specifically problematic?

```
#!/bin/bash

# Die on any errors
set -e

declare -a StringArray=("lambda-1" "lambda-2")

for value in ${StringArray[@]}; do
    mkdir -p lambdas/$value
    mkdir -p lambdas/$value/src
    cd lambdas/$value

    echo """
from setuptools import find_packages, setup
setup(
    name='"$value"',
    packages=find_packages('src'),
    package_dir={'': 'src'},
    install_requires=[],
)
    """ > setup.py

    pipenv install -e .
    cd -
done
```
