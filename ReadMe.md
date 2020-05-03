# Push to GCR Github Action

An action that build docker image and push to Google Cloud Registry.

This action can be used to perform on every `push` or every `tag` creation.

## Inputs

### `gcloud_service_key`
The service account key of google cloud. The service accout json file must be encoded in base64. This field is required.

### `registry`
The registry where the image should be pushedThe name of the person to greet. Default `gcr.io`.

### `project_name`
The project name. This field is required.

### `image_name`
The image name. This field is required.

### `image_tag`
The tag for the image. Default: `latest`. To use the pushed `Tag Name` see the example.

### `dockerfile`
The image building Dockerfile. Default: `./Dockerfile`. 
If context is changed, `Dockerfile` from context folder will be used.

### `context`
The docker build context. Default: `.`

## Example usage
Put desired yml section in the `.github/workflows/build.yml` file
### [`To perform build & push on every push`](https://github.com/RafikFarhad/example/build.yml)
```
name: Push to GCR Github Action
on: [push]
jobs:
  build-and-push-to-gcr:
    runs-on: ubuntu-latest
    steps:
      - uses: RafikFarhad/push-to-gcr-github-action@v1
        with:
          gcloud_service_key: ${{ secrets.GCLOUD_SERVICE_KEY }}
          registry: gcr.io
          project_name: my-awesome-project
          image_name: server-end

```

### [`To perform build & push only on tag publish`](https://github.com/RafikFarhad/example/build_only_tags.yml)
```
name: Push to GCR Github Action
on:
  push:
    tags:
    - '*'
jobs:
  build-and-push-to-gcr:
    runs-on: ubuntu-latest
    steps:
      - name: Get the version
        id: get_tag_name
        run: echo ::set-output name=GIT_TAG_NAME::${GITHUB_REF/refs\/tags\//}
      - uses: RafikFarhad/push-to-gcr-github-action@v1
        with:
          gcloud_service_key: ${{ secrets.GCLOUD_SERVICE_KEY }}
          registry: gcr.io
          project_name: my-awesome-project
          image_name: server-end
          image_tag: ${{ steps.get_tag_name.outputs.GIT_TAG_NAME}}
          dockerfile: ./build/Dockerfile
```