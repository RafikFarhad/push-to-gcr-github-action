#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo $GCLOUD_SERVICE_KEY | docker login -u _json_key --password-stdin https://$INPUT_REGISTRY/

docker build -t $IMAGE_NAME --file $INPUT_DOCKERFILE

docker push $IMAGE_NAME