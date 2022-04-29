#!/bin/bash
##
# Setup Openshift Environment
##


# Install Operators
echo "Installing ArgoCD operator..."
oc apply -f ./bootstrap/argocd-operator.yaml
sleep 30

echo "Installing Tekton operator..."
oc apply -f ./bootstrap/tekton-operator.yaml
sleep 30 

waitoperatorpod() {
  sleep 10
  oc get pods -n openshift-operators | grep ${1} | awk '{print "oc wait --for condition=Ready -n openshift-operators pod/" $1 " --timeout 300s"}' | sh
  sleep 20
}


echo "Waiting for Operators to be ready..."
waitoperatorpod gitops
waitoperatorpod pipelines


echo "Creating Project and Applications in openshift-gitops namespace"
oc project openshift-gitops
helm template ./bootstrap/  --debug   | oc apply -f -


# Notifications
read -p "Please configure GitHub weebhooks in order to notify code changes to Tekton automatically..."
