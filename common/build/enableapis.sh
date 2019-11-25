#!/bin/bash

# To see all the posible services...
# gcloud services list  --available --sort-by="NAME"

# To see all the enabled services...
# gcloud services list  --enabled --sort-by="NAME"

prerequisites=(
    gcloud
)

for prerequisite in ${prerequisites[@]}; do
    which $prerequisite ||
        (echo 1>&2 -e "Missing package: [${prerequisite}]\nRequired packages: [${prerequisites[@]}]" && exit 1)
done

function enable_required_apis() {

    declare -a required_apis=(storage-component.googleapis.com bigtable.googleapis.com stackdriver.googleapis.com sql-component.googleapis.com 
    datastore.googleapis.com appengine.googleapis.com pubsub.googleapis.com vision.googleapis.com cloudfunctions.googleapis.com
    container.googleapis.com bigquery-json.googleapis.com containerregistry.googleapis.com compute.googleapis.com spanner.googleapis.com ) 
    echo "Enabling required apis......"

    for apis in "${required_apis[@]}"; do 
       $(gcloud services enable "${apis}")
    done
 
}

main() {
  enable_required_apis  
}

main 