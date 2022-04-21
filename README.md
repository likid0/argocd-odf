# Deployment of ODF with ArgoCD

1. Fork and clone this Github Repo: https://github.com/likid0/argocd-odf/

```
gh repo fork  git@github.com:likid0/argocd-odf.git --clone 
```

2. Modify the values/variables for the Helm charts as needed:

- Argocd Bootstrap and ODF,LSO application configuration, at a bare minimum you
  would need to modify the helmRepoUrl variable and set it with your forked
  GitHub repo URL.

```
bootstrap/values.yaml
```
- Related to ODF deployment: 

```
odf/values.yaml
```

- If LSO is going to be used as target PVs for OSDs also modify LSO values

```
lso/values.yaml
```

3. Commit and push the modifications you made to the diferent values.yaml files to your forked repository. 

4. Then login into your OCP cluster with a cluster-admin account 

```
$ oc login  https://host:6443 -u XXX  -p XX
```

5. Run the setup script to start the deployment, ArgoCD will get bootstraped and ODF Deployed.

```
$ bash setup.sh
```
