#!/usr/bin/env sh

APP_NAME=webservice
ENVIRONMENT=${ENVIRONMENT-docker}

echo "Running The Webservice ${APP_NAME} with environment '${ENVIRONMENT}'..."
"/${APP_NAME}/golang-dockerized-webservice" "/configuration/${ENVIRONMENT}/config.yaml"
echo "The Webservice has finished."