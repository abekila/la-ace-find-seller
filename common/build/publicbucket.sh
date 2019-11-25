#!/bin/bash


prerequisites=(
    gsutil
)

for prerequisite in ${prerequisites[@]}; do
    which $prerequisite ||
        (echo 1>&2 -e "Missing package: [${prerequisite}]\nRequired packages: [${prerequisites[@]}]" && exit 1)
done


# Import the settings from the common settings file
source ../project_settings.sh

cat > publicbucketcors.json << EOL
[
    {
      "origin": ["*"],
      "responseHeader": ["Content-Type", "Access-Control-Allow-Origin"],
      "method": ["GET", "HEAD"],
      "maxAgeSeconds": 5
    }
]
EOL

gsutil mb -p $PROJECT_NAME -c regional -l $PROJECT_REGION gs://$PUBLIC_ASSETS/

gsutil cors set publicbucketcors.json gs://$PUBLIC_ASSETS

gsutil iam ch allUsers:objectViewer gs://$PUBLIC_ASSETS

: '
  {
  "bindings": [
    {
      "members": [
        "projectEditor:la-ace-find-seller-demo",
        "projectOwner:la-ace-find-seller-demo"
      ],
      "role": "roles/storage.legacyBucketOwner"
    },
    {
      "members": [
        "projectViewer:la-ace-find-seller-demo"
      ],
      "role": "roles/storage.legacyBucketReader"
    },
    {
      "members": [
        "allUsers"
      ],
      "role": "roles/storage.objectViewer"
    }
  ],
  "etag": "CAM="
}
'

