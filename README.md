# argocd-odf Deployment

Modify the values as needed:

- Argocd deployment: 

```
bootstrap/values.yaml
```
- Related to ODF deployment: 

```
odf/values.yaml
```

Push your changes to your remote branch in GIT.

Then login into your OCP cluster with a cluster-admin account 

```
$ oc login  https://host:6443 -u XXX  -p XX
```

and run the setup script to start the deployment 

```
$ bash setup.sh
```
