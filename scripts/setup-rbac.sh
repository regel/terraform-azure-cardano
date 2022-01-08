#!/bin/bash

spName=tf-sp
TENANT_ID=$(az account show --query tenantId -o tsv)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

TF_SP_SECRET=$(az ad sp create-for-rbac -n $spName --role Contributor --query password -o tsv)
TF_SP_ID=$(az ad sp list --display-name $spName --query [0].appId -o tsv)

cat << EOF
Terraform must store state about your managed infrastructure and configuration.
Use the settings below with azurerm Terraform provider.

**STORE THESE SETTINGS SECURELY. THEY GIVE WRITE ACCESS TO AZURE SUBSCRIPTION**

ARM_TENANT_ID=$TENANT_ID
ARM_SUBSCRIPTION_ID=$SUBSCRIPTION_ID
ARM_CLIENT_ID=$TF_SP_ID
ARM_CLIENT_SECRET=$TF_SP_SECRET
EOF
