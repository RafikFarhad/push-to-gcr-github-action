#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo "Fully qualified image name: $IMAGE_NAME"

echo "Authenticating docker to gcloud ..."
echo $INPUT_GCLOUD_SERVICE_KEY | python -m base64 -d > /tmp/key.json
if cat /tmp/key.json | docker login -u _json_key --password-stdin https://$INPUT_REGISTRY; then
    echo "Logged in to google cloud ..."
else
    echo "Docker login failed. Exiting..."
    exit 1
fi

echo "Building image ..."

[ -z ${INPUT_DOCKERFILE+x} ] && FILE_ARG="" || FILE_ARG="--file $INPUT_DOCKERFILE"

if docker build -t $IMAGE_NAME $INPUT_CONTEXT $FILE_ARG; then
    echo "Image built ..."
else
    echo "Image building failed. Exiting..."
    exit 1
fi

echo "Pushing image ..."
if ! docker push $IMAGE_NAME; then
    echo "Pushing failed. Exiting..."
    exit 1
else
    echo "Process complete."
fi
