#!/bin/sh -l

IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_NAME/$INPUT_IMAGE_NAME:$INPUT_IMAGE_TAG"

echo "Fully qualified image name: $IMAGE_NAME"

echo "Building image"
docker build -t $IMAGE_NAME . --file $INPUT_DOCKERFILE

echo "Authenticating docker to gcloud"
echo $INPUT_GCLOUD_SERVICE_KEY | python -m base64 -d > /tmp/key.json

cat /tmp/key.json | grep project_id

if echo /tmp/key.json | docker login -u _json_key --password-stdin https://$INPUT_REGISTRY; then
    echo "Logged in"
else
    echo "JSON file not present. Exiting..."
    exit 1
fi

echo "Pushing image"
if ! docker push $IMAGE_NAME; then
    echo "Pushing failed. Exiting..."
else
    
    echo "Process complete."
fi
