# Kubernetes Canary Deployment (Manual vs Automated)

You can find tutorial [here](https://youtu.be/fWe6k4MmeSg).

## Start Minikube

```bash
minikube start --driver=docker
```

## Build application
```bash
# Run following command from automated-deployment folder(K8S).
export USERNAMR=<containerRegistry> VER=v1 APP_DIR=myapp && ./build.sh
```

## Deploy All Dependencies

```bash
cd terraform
terraform apply
```

## Grafana & Promethius
```bash
# username: admin, password: devops123
kubectl port-forward svc/grafana 3000 -n monitoring
kubectl port-forward svc/prometheus-operated 9090 -n monitoring
```

## Test application (Example 1)

```bash
kubectl run curl --image=alpine/curl:8.2.1 -n default -i --tty --rm -- sh
for i in `seq 1 1000`; do curl myapp:8080/version; echo ""; sleep 1; done
```

## Test application (Example 2)

```bash
kubectl run curl --image=alpine/curl:8.2.1 -n staging -i --tty --rm -- sh
for i in `seq 1 1000`; do curl myapp:8080/version; echo ""; sleep 1; done
```

To get grafana password:
kubectl get secrets/grafana -n monitoring  -o go-template='
{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'