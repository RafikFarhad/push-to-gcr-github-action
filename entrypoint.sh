#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo "Fully qualified image name: $IMAGE_NAME"

echo "Building image"
docker build -t $IMAGE_NAME . --file $INPUT_DOCKERFILE

echo "Authenticating docker to gcloud"
echo $INPUT_GCLOUD_SERVICE_KEY > /tmp/key.json
echo /tmp/key.json | docker login -u _json_key --password-stdin https://$INPUT_REGISTRY

echo "Pushing image"
docker push $IMAGE_NAME

echo "Process complete."