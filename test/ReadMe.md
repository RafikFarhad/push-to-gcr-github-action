# Local Test

To test the action locally, [https://github.com/nektos/act](https://github.com/nektos/act) can be useful.

## Steps:

1. Create a `secret.txt` file with the `base64` representation of GCloud Service Account json key in `./test` folder.
2. Change `project_id`, `image_name`, `image_tag` in the `./test/build.yml` as your GCP project. 
2. Run `act -v -s GCLOUD_SERVICE_KEY="$(< test/secret.txt)" -W test/` from the repository root.
