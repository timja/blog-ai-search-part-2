#!/usr/bin/env bash
set -e

export SEARCH_SERVICE_NAME=example
export SEARCH_RESOURCE_GROUP=example

API_KEY=$(az search admin-key show \
  --service-name $SEARCH_SERVICE_NAME \
  --resource-group $SEARCH_RESOURCE_GROUP \
  --query primaryKey \
  -o tsv)

curl --fail-with-body \
  -X POST \
  -H "api-key: ${API_KEY}" \
  "https://$SEARCH_SERVICE_NAME.search.windows.net/indexers('example')/search.run?api-version=2024-07-01" \
  -d ''

echo "Index triggered"
