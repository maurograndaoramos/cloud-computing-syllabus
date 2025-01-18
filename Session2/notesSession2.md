```bash
kubectl create deployment nginx --image nginx:alpine --port 80 --dry-run=client -oyaml > name_of_the_file.yaml
```
This allows you to export the deployment pods into a yaml file immediately

```bash
kubectl port-forward deployments/nginx-deployment 8000:80 
```
This allows you to port the deployment (must name file) to a specific port so you can access the html content in the mapConfig in your browser

```bash
kubectl get secret app-secret -o jsonpath='{.data.*}' | base64 -
d
```

This one allows you to read the contents of the secret. In this case, the contents of the app-secret.yaml file