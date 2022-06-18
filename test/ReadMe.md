# Local Test

To test the action locally, [Act](https://github.com/nektos/act) can be useful.

## Steps:

1. Create a `secret.txt` file with the `base64` representation of GCloud Service Account json key in `./test` folder.
2. Change `project_id`, `image_name`, `image_tag` in the `./test/build.yml` as your GCP project. 
2. Run `act -s B64_GCLOUD_SERVICE_ACCOUNT_JSON="$(cat THE_JSON_FILE | python3 -m base64 -e)" -s JSON_GCLOUD_SERVICE_ACCOUNT_JSON="$(cat THE_JSON_FILE)"` from the repository root.
