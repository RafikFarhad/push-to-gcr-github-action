#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo "Fully qualified image name: $IMAGE_NAME"

echo $GCLOUD_SERVICE_KEY > /tmp/key.json

echo "Authenticating docker to gcloud"
echo /tmp/key.json | docker login -u _json_key --password-stdin https://$INPUT_REGISTRY

echo "Building image"
docker build -t $IMAGE_NAME . --file $INPUT_DOCKERFILE

echo "Pushing image"
docker push $IMAGE_NAME

echo "Process complete."