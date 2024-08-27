#!/usr/bin/env bash
azcopy login

export STORAGE_ACCOUNT_NAME=example
export CONTAINER_NAME=example

azcopy sync --compare-hash=md5 \
  --delete-destination=true \
  --include-pattern="*.html"  \
  "site/" "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/"

function setTitle() {
    local path=$1

    TITLE=$(cat $path | htmlq 'h1' --text)

    echo "Setting title to $TITLE for $path"

    az storage blob metadata update \
      --auth-mode login \
      --account-name $STORAGE_ACCOUNT_NAME \
      --container-name $CONTAINER_NAME \
      --name $path \
      --metadata title="$TITLE"
}

# so that it's available to the -exec in the find command
export -f setTitle

pushd site
# another pass over to set the file title as a metadata attribute
find . -name "*.html" -exec bash -c "setTitle \"{}\"" \;
