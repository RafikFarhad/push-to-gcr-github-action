#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo "Fully qualified image name: $IMAGE_NAME"

echo $GCLOUD_SERVICE_KEY > /tmp/key.json

echo "Activiting google cloud auth"
gcloud auth activate-service-account --quiet --key-file /tmp/key.json

echo "Configuring docker"
gcloud auth configure-docker --quiet

echo "Building image"
docker build -t $IMAGE_NAME --file $INPUT_DOCKERFILE

echo "Pushing image"
docker push $IMAGE_NAME

echo "Process complete."