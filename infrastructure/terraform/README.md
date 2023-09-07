### Check available AWS RDS postgres engins
> aws rds describe-db-engine-versions

### Kubernetes Dashboard 
1. Configure AWS Cli for EKS Cluster access
```
aws eks update-kubeconfig \ 
  --region us-east-2 \ 
  --name <cluster_name>
```

2. Get temporary token for K8s dashboard
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
```

if not working, try:
2.1 Grant a role to an application-specific service account (best practice)
```
kubectl create clusterrolebinding add-on-cluster-admin \
  --clusterrole=cluster-admin \
  --serviceaccount=kube-system:eks-admin
```


3. Open another terminal
```
kubectl proxy
```

4. Leave the terminal running. Open browser:
> http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:443/proxy/#/login

### Access ArgoCD UI
1. Browser URL:
> http://localhost:8001/api/v1/namespaces/argocd/services/https:argocd-server:443/proxy/

2. Username: admin

3. Password
> kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

4. Create repository
github url with airflow helm content cloned from: https://artifacthub.io/packages/helm/airflow-helm/airflow

```
helm repo add airflow-helm https://airflow-helm.github.io/charts
helm pull airflow-helm/airflow --version 8.5.2
```

5. Create application
Application Name: airflow2
Project: default
Sync Policy: Automatic
Check Prune Resources
Prune Propagation Policy: foreground
Source: select the repository we have configured before
Revision: HEAD
Path: infrastructure/kubernetes/apps/airflow/
Destination: select the kubernetes cluster (you will see only one)
Namespace: airflow

### Access Airflow Web UI
1. Map Airflow to localhost:8080
> kubectl port-forward svc/airflow2-web 8080:8080 -n airflow

2. Open browser url
> http://localhost:8080

3. Username/Password: 
> admin:admin

### Cleanup AWS by Terraform
> terraform destroy -var-file terraform.tfvars
