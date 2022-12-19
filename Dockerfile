FROM python:3.8.10

ARG VERSION

RUN pip3 install pipenv==$VERSION

COPY ./lambdas ./lambdas
COPY ./installer.sh ./installer.sh

RUN /bin/bash installer.sh

# Simple method to verify that Pipenv install was run on both Lambdas
RUN ls -lah lambdas/lambda-1/build/ && ls -lah lambdas/lambda-2/build/
