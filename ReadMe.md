# Push to GCR GitHub Action

An action that build docker image and push to Google Cloud Registry.

This action can be used to perform on every git `push` or every `tag` creation.

## Inputs

### `gcloud_service_key`
The service account key of google cloud. The service accout json file must be encoded in base64. This field is required.

### `registry`
The registry where the image should be pushed. Default `gcr.io`.

### `project_id`
The project id. This field is required.

### `image_name`
The image name. This field is required.

### `image_tag`
The tag for the image. To create multiple tag of the same image, provide comma (`,`) separeted tag name (e.g. `v2.1,v2,latest`).

Default: `latest`.

To use the pushed `Tag Name` as image tag, see the [example](https://github.com/RafikFarhad/push-to-gcr-github-action/blob/master/example/build_only_tags.yml).

### `dockerfile`
The image building Dockerfile. 
If context is changed, `Dockerfile` from context folder will be used.

Default: `./Dockerfile`.

### `context`
The docker build context. Default: `.`

### `target`
If you use multi-stage build and want to stop builing at a certain image, you can use this field. Default value is empty.

### `build_args`
Pass a list of env vars as build-args for docker-build, separated by commas. ie: `HOST=db.default.svc.cluster.local:5432,USERNAME=db_user`

## Permissions
The service key you provided must have the `Storage Admin` permission to push the image to GCR.
It is possible to use a lower access level `Storage Object Admin`, but it will work only for already created registry. You must also add the `Storage Legacy Bucket Reader` permission to the `artifacts.<project id>.appspot.com` bucket for the given service account.

[Reference 1](https://cloud.google.com/container-registry/docs/access-control)

[Reference 2](https://stackoverflow.com/a/39750467/6189461)

To create service key/account visit [here](https://console.cloud.google.com/iam-admin/serviceaccounts)

## Example usage
Put desired yml section in the `.github/workflows/build.yml` file
### `To perform build & push on every git push`

```
name: Push to GCR GitHub Action
on: [push]
jobs:
  build-and-push-to-gcr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: RafikFarhad/push-to-gcr-github-action@v3.0.2
        with:
          gcloud_service_key: ${{ secrets.GCLOUD_SERVICE_KEY }}
          registry: gcr.io
          project_id: my-awesome-project
          image_name: server-end

```
### `To perform build & push only on tag publish`

```
name: Push to GCR GitHub Action
on:
  push:
    tags:
    - '*'
jobs:
  build-and-push-to-gcr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Get the version
        id: get_tag_name
        run: echo ::set-output name=GIT_TAG_NAME::${GITHUB_REF/refs\/tags\//}
      - uses: RafikFarhad/push-to-gcr-github-action@v3.0.2
        with:
          gcloud_service_key: ${{ secrets.GCLOUD_SERVICE_KEY }}
          registry: gcr.io
          project_id: my-awesome-project
          image_name: server-end
          image_tag: ${{ steps.get_tag_name.outputs.GIT_TAG_NAME}}
          dockerfile: ./build/Dockerfile
```
