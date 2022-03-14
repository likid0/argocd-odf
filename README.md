# argocd-odf Deployment

1. Fork this Github Repo: https://github.com/likid0/argocd-odf/


2. Modify the values/variables for the Helm charts as needed:

- Argocd deployment: 

```
bootstrap/values.yaml
```
- Related to ODF deployment: 

```
odf/values.yaml
```

3. Commit and push the modifications you made to the values.yaml files to your forked repository. 

4. Then login into your OCP cluster with a cluster-admin account 

```
$ oc login  https://host:6443 -u XXX  -p XX
```

5. Run the setup script to start the deployment, ArgoCD will get bootstraped and ODF Deployed.

```
$ bash setup.sh
```
