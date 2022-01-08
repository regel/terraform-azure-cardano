#!/bin/bash
# Creates tfstate remote backend in Azure storage
# Usage: setup-azure-storage [ -e ENV ] -g [ RESOURCE_GROUP ] -l [ LOCATION ] -s [ SKU ]

set -e

usage() {
  echo "$0 [ -e ENV ] -g [ RESOURCE_GROUP ] -l [ LOCATION ] -s [ SKU ]"

  echo "Description of options:"
  echo "  -e: Name of the environment (default: 'testnet')."
  echo "  -g: Name of the Azure resouce group."
  echo "  -l: Name of the Azure location (default: 'eastus')."
  echo "  -s: Azure storage sku. Possible values: 'Standard_LRS', 'Standard_GRS'"
}

exit_abnormal() {
  usage
  exit 1
}
ENVIRONMENT="testnet"
LOCATION="eastus"
RESOURCE_GROUP=""
SKU="Standard_GRS"

while getopts "he:g:l:s:" options; do
  case "${options}" in
    h)
      usage
      exit 0
      ;;
    e)
      ENVIRONMENT=${OPTARG}
      ;;
    g)
      RESOURCE_GROUP=${OPTARG}
      ;;
    l)
      LOCATION=${OPTARG}
      ;;
    s)
      SKU=${OPTARG}
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument." >&2
      exit_abnormal
      ;;
    *)
      exit_abnormal
      ;;
  esac
done

TFSTATE_RESOURCE_GROUP_NAME=tfstate-$ENVIRONMENT
if [ -n "$RESOURCE_GROUP" ]; then
  TFSTATE_RESOURCE_GROUP_NAME=$RESOURCE_GROUP
fi
TFSTATE_STORAGE_ACCOUNT_NAME=tfstate$RANDOM$ENVIRONMENT
TFSTATE_BLOB_CONTAINER_NAME=tfstate-$ENVIRONMENT

az group create -n $TFSTATE_RESOURCE_GROUP_NAME -l "$LOCATION"
az storage account create -g $TFSTATE_RESOURCE_GROUP_NAME -n $TFSTATE_STORAGE_ACCOUNT_NAME --sku "$SKU" --encryption-services blob
TFSTATE_STORAGE_ACCOUNT_KEY=$(az storage account keys list -g $TFSTATE_RESOURCE_GROUP_NAME --account-name $TFSTATE_STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
az storage container create -n $TFSTATE_BLOB_CONTAINER_NAME --account-name $TFSTATE_STORAGE_ACCOUNT_NAME --account-key $TFSTATE_STORAGE_ACCOUNT_KEY

az group lock create --lock-type CanNotDelete -n CanNotDelete -g $TFSTATE_RESOURCE_GROUP_NAME

