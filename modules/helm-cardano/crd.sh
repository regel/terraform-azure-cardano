#!/bin/bash
# This script applies a YAML manifest

if ! command -v kubectl &> /dev/null
then
    echo "kubectl command could not be found"
    exit 1
fi >&2
if [ -z "$KUBECONFIG_RAW" ]
then
    echo "Error. KUBECONFIG_RAW is empty"
    exit 2
fi >&2
if [ -z "$MANIFEST_RAW" ]
then
    echo "Error. MANIFEST_RAW is empty"
    exit 2
fi >&2
if [ -z "$NAMESPACE" ]
then
    echo "Error. NAMESPACE is empty"
    exit 2
fi >&2

export KUBECONFIG=$(mktemp)
MANIFEST=$(mktemp)
trap "rm -f $KUBECONFIG $MANIFEST" EXIT ;
echo $KUBECONFIG_RAW | base64 --decode > $KUBECONFIG
echo $MANIFEST_RAW | base64 --decode > $MANIFEST
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f - ; 
kubectl apply --namespace $NAMESPACE -f $MANIFEST
