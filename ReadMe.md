# Push to GCR GitHub Action

An action that builds docker image and pushes to Google Cloud Registry.

This action can be used to perform on every git `push` or every `tag` creation.

## Inputs

### `gcloud_service_key`
The service account key of google cloud. The JSON file can be encoded in base64 or in plain text. This field is required.

### `registry`
The registry where the image should be pushed. Default `gcr.io`.

### `project_id`
The project id. This field is required.

### `image_name`
The image name. This field is required.

### `image_tag`
The tag for the image. To create multiple tags of the same image, provide a comma (`,`) separated tag name (e.g. `v2.1,v2,latest`).

Default: `latest`.

To use the pushed `Tag Name` as image tag, see the [example](https://github.com/RafikFarhad/push-to-gcr-github-action/blob/master/examples/build_only_tags.yml).

### `dockerfile`
The image building Dockerfile. 
If the context is not the root of the repository, `Dockerfile` from the context folder will be used.

Default: `./Dockerfile`.

### `context`
The docker build context. Default: `.`

### `target`
If you use a multi-stage build and want to stop building at a certain image, you can use this field. The default value is empty.

### `build_args`
Pass a list of env vars as build-args for docker-build, separated by commas. ie: `HOST=db.default.svc.cluster.local:5432,USERNAME=db_user`

### `push_only`
If you want to skip the build step and just push the image built by any previous step, use this option. The default for this is `false`.

## Permissions
The service key you provided must have the `Storage Admin` permission to push the image to GCR.
It is possible to use a lower access level `Storage Object Admin`, but it will work only if the registry is already created. You must also add the `Storage Legacy Bucket Reader` permission to the `artifacts.<project id>.appspot.com` bucket for the given service account.

[Reference 1](https://cloud.google.com/container-registry/docs/access-control)

[Reference 2](https://stackoverflow.com/a/39750467/6189461)

To create service key/account visit [here](https://console.cloud.google.com/iam-admin/serviceaccounts)

## Example usage
```yaml
name: Push to GCR GitHub Action
on: [push]
jobs:
  build-and-push-to-gcr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: RafikFarhad/push-to-gcr-github-action@v4.1
        with:
          gcloud_service_key: ${{ secrets.GCLOUD_SERVICE_KEY }} # can be base64 encoded or plain text
          registry: gcr.io
          project_id: my-awesome-project
          image_name: backend
          image_tag: latest,v1
          dockerfile: ./docker/Dockerfile.prod
          context: ./docker
```
[More Example](https://github.com/RafikFarhad/push-to-gcr-github-action/tree/master/examples)

[Workflow Example](https://github.com/RafikFarhad/push-to-gcr-github-action/tree/master/.github/workflows)

## Contribution
- Fork
- Implement your awesome idea or fix a bug
- Create PR 🎉

NB: The included workflow which tests the action's basic functionalities needs a GitHub secret named `JSON_GCLOUD_SERVICE_ACCOUNT_JSON`.
Currently, the workflow is not testable for forked repositories but I have an action item to enable this.  
