#!/bin/bash
##
# Setup Openshift Environment
##

# Create Namespaces in order to deploy a new argocd instance
echo "Creating namespaces..."
oc new-project gitops-argocd

# Install Operators
echo "Installing ArgoCD operator..."
oc apply -f ./bootstrap/argocd-operator.yaml
sleep 60

waitoperatorpod() {
  sleep 10
  oc get pods -n openshift-operators | grep ${1} | awk '{print "oc wait --for condition=Ready -n openshift-operators pod/" $1 " --timeout 300s"}' | sh
  sleep 20
}


echo "Waiting for Operators to be ready..."
waitoperatorpod gitops


#oc apply -f ./bootstrap
echo "Creating ArgoCD Server, project and Applications in gitops-argocd namespace"
oc project gitops-argocd
helm template ./bootstrap/  --debug --namespace gitops-argocd  | oc apply -f -


#Some fixes to be removed
#For argocd to allow deployment of cluster resources outside of namespace
#oc create secret generic argocd-default-cluster-config --from-literal=namespaces=gitops-argocd --from-literal=server=https://kubernetes.default.svc --from-literal=config={"tlsClientConfig":{"insecure":false}} --from-literal=name=in-cluster --from-literal=clusterResources=true= --dry-run=client  -o yaml  | oc replace -f -

#Not for final users, so we can deploy ODF in openshift-storage namespace
#oc adm policy add-cluster-role-to-user cluster-admin -z argocd-argocd-application-controller -n gitops-argocd

#Important warning: Do not blindly elevate the permissions of application delivery instances to be cluster scoped. 
#The instances you elevate should always be managed by an administrative team, not by application delivery teams.
#Anyone with access to the namespace of a cluster-scoped instance can elevate their privileges on the cluster to become a cluster administrator themselves.
#The next patch will make the Argo CD instances installed in the gitops-argocd become a cluster scoped instance.
#Just as a reminder the per default openshift-gitops argocd instance is already cluster scoped.
oc patch subscriptions.operators.coreos.com openshift-gitops-operator -n openshift-operators --patch-file bootstrap/patch/07_patch.yaml --type merge
#oc create secret generic argocd-default-cluster-config --from-literal=namespaces=gitops-argocd --from-literal=server=https://kubernetes.default.svc --from-literal=config={"tlsClientConfig":{"insecure":false}} --from-literal=name=in-cluster --from-literal=clusterResources=true= --dry-run=client  -o yaml  | oc replace -f -
