#!/bin/bash
##
# Setup Openshift Environment
##

# Create Namespaces in order to deploy applications
echo "Creating namespaces..."
sleep 10
oc new-project gitops-argocd

# Install Operators
echo "Installing ArgoCD operator..."
oc apply -f ./argocd-operator.yaml
sleep 60

# Wait time to install operators
echo "Waiting for Operators to be ready..."
sleep 60

# Apply chart template
#echo "Creating ArgoCD Server, project, CI/CD Application and so on..."
#oc project gitops-argocd
#helm template ./charts/jump-app-argocd -f ./scripts/files/crc-values-argocd.yaml --debug --namespace gitops-argocd | oc apply -f -
#sleep 10

#oc apply -f bootstrap/01_role.yaml
#oc apply -f bootstrap/02_rolebinding.yaml
#oc apply -f bootstrap/03_secrets.yaml
#oc apply -f bootstrap/04_argocd.yaml
#oc apply -f bootstrap/05_project.yaml
#oc apply -f bootstrap/06_application.yaml
oc apply -f bootstrap


#For argocd to allow deployment of cluster resources
oc project gitops-argocd
#oc create secret generic argocd-default-cluster-config --from-literal=clusterResources=true
oc create secret generic argocd-default-cluster-config --from-literal=namespaces=gitops-argocd --from-literal=server=https://kubernetes.default.svc --from-literal=config={"tlsClientConfig":{"insecure":false}} --from-literal=name=in-cluster --from-literal=clusterResources=true= --dry-run=client  -o yaml  | oc replace -f -
#Just for testing, so we can deploy ODF in openshift-storage namespace
oc adm policy add-cluster-role-to-user cluster-admin -z argocd-argocd-application-controller -n gitops-argocd

# Add the namespaces where you hace argocd deployed
oc patch subscriptions.operators.coreos.com openshift-gitops-operator -n openshift-operators --patch-file bootstrap/07_patch.yaml --type merge
#oc get subscriptions.operators.coreos.com openshift-gitops-operator -n openshift-operators -o yaml
#spec:
#  config:
#    env:
#    - name: ARGOCD_CLUSTER_CONFIG_NAMESPACES
#      value: openshift-operators,gitops-argocd
