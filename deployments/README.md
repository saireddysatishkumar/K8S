# Most Common Kubernetes Deployment Strategies (Examples & Code)
## Prerequisite    
a) Keep open 3 Terminals
b) In Terminal 1, Start Minikube  
```bash
minikube start --driver=docker 
Note: It will take few mins to start
```
c) In Terminal 2, Watch pods list and leave it for continuously monitoring pods. This will not show anything until you start with section 1.   
```
watch -n 0.5 -t kubectl get pods -n default
```
d) In Terminal 3, Run curl to check the deployed. This will not show anything until you start with section 1.  
```
$ kubectl run curl --image=alpine/curl:8.2.1 -n kube-system -i --tty --rm -- sh
Note: above command will launch into a curl pod/container. Then run following command
for i in `seq 1 10`; do curl myapp.default:8181/version ;echo ""; sleep 1; done
```
```
Note: During deployment, you can pause, resume, undo and restart using rollout command. It is kubernetes native tool.
$ kubectl get deployments
$ kubectl rollout undo  deployment myapp
$ kubectl rollout restart  deployment myapp ## restrat will be used when new version deployment is tested successfully and route all trafic to it.
```
----------------------------------------------------------------------------------
## Section1:
> Rolling update deployment:
```
Let us know about code/files in 1-rolling-update folder before proceeding  
1-deployment.yaml - rolling update deployment with v1 myapp.  
2-deployment.yaml  - rolling update deployment with v2 myapp.
3-service.yaml - service manifest which will just point to selector myapp. Above both files includes same selector label.
```
```
step) In terminal 1:
Run myapp deployment version v1 by executing following commands
$cd 1-rolling-update   
kubectl apply -f 1-deployment.yaml
Note: check terminal 2 for pods status. Once all pods are up, run the service.
kubectl apply -f 3-service.yaml
Note: Now monitor terminal 3. It will show myapp application version once service is up.
It means application is deployed with version1. 
```
```
step) Now lets deploy version2 using rolling update. Check 2-deployment.yaml for deployment strategy.
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1 # Max number of Pods that can be unavailable during the update process.
      maxSurge: 1 # Max number of Pods that can be created over the desired number of Pods.
In terminal 1:
Run myapp deployment version v2 by executing following commands
$cd 1-rolling-update   
kubectl apply -f 2-deployment.yaml
Note: check terminal 2 for pods status. Slowly v1 deployment pods will be killed and v2 deployment pods get created.   
Note: Now monitor terminal 3. It will show myapp application version once service is up.
It means application is deployed with version2 automatically. At this moment there will be two replica sets but only one replica set will be up.
```
----------------------------------------------------------------------------------
## Section2:
> Recreate deployment:
```
Let us know about code/files in  2-recreate folder before proceeding  
1-deployment.yaml - recreate deployment with myapp.  All versions updated in same manifest file.
```
```
step) In terminal 1:
Run myapp deployment version v1 by executing following commands
$cd 2-recreate   
kubectl apply -f 1-deployment.yaml
Note: check terminal 2 for pods status.
Note: Now monitor terminal 3. It will show myapp application version once service is up.
It means application is deployed with version1. 
```
```
step) In terminal 1:
Update deployment version to v2 in same file and run deployment by executing following commands 
kubectl apply -f 1-deployment.yaml
Note: check terminal 2 for pods status.
Note: Now monitor terminal 3. It will show myapp application version once service is up.
It means application is deployed with version2. 
During recreate deployment stratgy, all pods willbe recreated. So downtime is expected.
Such deployment will be used, when a pod like grafana is mounted to PersistentVolumeClaim with access mode ReadWriteOnce. Because those permissions allows a storage to point to sigle pod. It can't be mounted until old deployment pod is killed.
```
----------------------------------------------------------------------------------
## Section3:
> Blue Green deployment(native):
```
Let us know about code/files in 3-blue-green/native folder before proceeding  
1-blue-deployment.yaml - Runs deployment with matchLabel blue replica.  
2-green-deployment.yaml - Runs deployment with matchLabel green replica.
3-service.yaml -  service manifest which will just point to myapp's matchLabel(blue/green).
So during deployment both replicasets willbe available. Once deployment is done, all trafic will be routed to replicaset whcih is pointed in service manifest.
```
```
step) In terminal 1:
Run myapp deployment by executing following commands
$cd 3-blue-green   
kubectl apply -f native
Note: check terminal 2 for pods status.
Note: Now monitor terminal 3. It will show myapp application version once service is up.
It means application is deployed with version1. 
```
```
step) In terminal 1:
Update app's matchLabel(green) in service file and run deployment by executing following commands 
$cd 3-blue-green   
kubectl apply -f native
Note: check terminal 2 for pods status.
Note: Now monitor terminal 3. It will show myapp application version immediatly.
It means application is deployed with version2. 
```
----------------------------------------------------------------------------------
## Section4:
### Deployments automation(istio/flagger):
#### Prerequisites:  
> Deploy Prometheus (apply 2 times)

```bash
kubectl apply --server-side -R -f monitoring/
kubectl get service -n monitoring
minikube service grafana -n monitoring --url
# open url it shows. 
```

> Install Istio & Flagger

```bash
helm repo add flagger https://flagger.app
helm upgrade -i flagger-loadtester flagger/loadtester
cd terraform
terraform init
terraform apply
```

> Blue Green deployment(flagger):
```
step) In terminal 1:
Run myapp deployment by executing following commands
$ kubectl apply -f 3-blue-green/flagger 

In Terminal 2:
$ watch -n 0.5 -t kubectl get pods -n staging

In Terminal 3:
$ kubectl run curl --image=alpine/curl:8.2.1 -n kube-system -i --tty --rm -- sh
for i in `seq 1 5`; do curl myapp.staging:8181/version ;echo ""; sleep 1; done

```

## Test application

```bash
kubectl run curl --image=alpine/curl:8.2.1 -n kube-system -i --tty --rm -- sh
for i in `seq 1 1000`; do curl myapp.default:8181/version; echo ""; sleep 1; done
```