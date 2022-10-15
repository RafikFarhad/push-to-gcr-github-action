#!/bin/bash -
#title          :entrypoint.sh
#description    :This script build image with multiple option and push the image to Google Container Registry.
#author         :RafikFarhad<rafikfarhad@gmail.com>
#date           :20200703
#version        :2.0.1
#usage          :./entrypoint.sh
#notes          :Required env values are: INPUT_REGISTRY,INPUT_PROJECT_ID,INPUT_IMAGE_NAME
#                Optional env values are: INPUT_GCLOUD_SERVICE_KEY,INPUT_IMAGE_TAG,INPUT_DOCKERFILE,INPUT_TARGET,INPUT_CONTEXT,INPUT_BUILD_ARGS
#bash_version   :5.0.17(1)-release
###################################################

ALL_IMAGE_TAG=()

# detect service_account json flavour
if [ $GOOGLE_APPLICATION_CREDENTIALS ] && ls $GOOGLE_APPLICATION_CREDENTIALS; then
    # workload identity
    echo "Workload identity found ..."
    cp $GOOGLE_APPLICATION_CREDENTIALS /tmp/key.json
else
    if [ -z $INPUT_GCLOUD_SERVICE_KEY ]; then
        echo "GCLOUD_SERVICE_KEY is a required field when workload identity is not used. Exiting ..."
        exit 1
    fi
    # persing service account json
    if ! echo $INPUT_GCLOUD_SERVICE_KEY | python3 -m base64 -d >/tmp/key.json 2>/dev/null; then
        if ! echo $INPUT_GCLOUD_SERVICE_KEY >/tmp/key.json 2>/dev/null; then
            echo "Failed to get gcloud_service_key. It could be plain text or base64 encoded service account JSON file"
            exit 1
        else
            # service account found as plain text json
            echo "This action is unable to decode INPUT_GCLOUD_SERVICE_KEY as base64. It assumes INPUT_GCLOUD_SERVICE_KEY as plain text"
        fi
    else
        # service account found as base64 encoded json
        echo "Successfully decoded from base64"
    fi
fi

if ! gcloud auth login --cred-file=/tmp/key.json --quiet; then
    echo "Unable to login to gcloud. Exiting ..."
    exit 1
fi

if gcloud auth configure-docker $INPUT_REGISTRY --quiet; then
    echo "Authentication successful to $INPUT_REGISTRY ..."
else
    echo "Docker login failed. Exiting ..."
    exit 1
fi

# split -> trim -> compact -> uniq -> bash array
ALL_IMAGE_TAG=($(python3 -c "print(' '.join(list(set([v for v in [v.strip() for v in '$INPUT_IMAGE_TAG'.split(',')] if v]))))"))

# default to 'latest' when $ALL_IMAGE_TAG is empty
if [ ${#ALL_IMAGE_TAG[@]} -eq 0 ] ; then
    echo "INPUT_IMAGE_TAG tag is not parsable. Using latest by default"
    ALL_IMAGE_TAG=(latest)
fi

TEMP_IMAGE_NAME="$INPUT_IMAGE_NAME:temporary"

if [ "$INPUT_PUSH_ONLY" = true ]; then
    echo "Skipping image build ..."
else
    echo "Building image ..."
    [ -z $INPUT_TARGET ] && TARGET_ARG="" || TARGET_ARG="--target $INPUT_TARGET"
    [ -z $INPUT_DOCKERFILE ] && FILE_ARG="" || FILE_ARG="--file $INPUT_DOCKERFILE"

    if [ ! -z "$INPUT_BUILD_ARGS" ]; then
        for ARG in $(echo "$INPUT_BUILD_ARGS" | tr ',' '\n'); do
            BUILD_PARAMS="$BUILD_PARAMS --build-arg ${ARG}"
        done
    fi

    echo "docker build $BUILD_PARAMS $TARGET_ARG -t $TEMP_IMAGE_NAME $FILE_ARG $INPUT_CONTEXT"

    if docker build $BUILD_PARAMS $TARGET_ARG -t $TEMP_IMAGE_NAME $FILE_ARG $INPUT_CONTEXT; then
        echo "Image built ..."
    else
        echo "Image building failed. Exiting ..."
        exit 1
    fi
fi

for IMAGE_TAG in ${ALL_IMAGE_TAG[@]}; do

    IMAGE_NAME="$INPUT_REGISTRY/$INPUT_PROJECT_ID/$INPUT_IMAGE_NAME:$IMAGE_TAG"

    echo "Fully qualified image name: $IMAGE_NAME"

    echo "Creating docker tag ..."

    docker tag $TEMP_IMAGE_NAME $IMAGE_NAME

    echo "Pushing image $IMAGE_NAME ..."

    if ! docker push $IMAGE_NAME; then
        echo "Pushing failed. Exiting ..."
        exit 1
    else
        echo "Image pushed."
    fi
done

echo "Process complete."
