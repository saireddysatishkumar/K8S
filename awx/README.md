# awx in minikube(linux/mac).

> Create awx cluster
minikube start --output='text' -p awx --extra-config=apiserver.service-node-port-range=1-65535 --cpus=4 --memory=6g --addons=dashboard --addons=metrics-server --addons="ingress" --addons="ingress-dns"

>Step1) Install AWX Operator. 
[awx service setup in k8s(linux/mac) guide](https://subscription.packtpub.com/book/cloud-and-networking/9781803244884/4/ch04lvl1sec17/installing-awx-on-minikube)
```` 
$ git clone https://github.com/ansible/awx-operator.git
$ cd awx-operator
$ export NAMESPACE=awx
````
Create and run following file and run command. kubectl --cluster awx apply -k . 
````
 kustomization.yaml 
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  # Find the latest tag here: https://github.com/ansible/awx-operator/releases
  - github.com/ansible/awx-operator/config/default?ref=2.5.1

# Set the image tags to match the git version from above
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.5.1
# Specify a custom namespace in which to install AWX
namespace: awx
````

````
$ kubectl --cluster awx get pods -n $NAMESPACE
$ kubectl --cluster awx config set-context --current --namespace=$NAMESPACE
````
````
>Step2) Launch awx deployment
$ kubectl --cluster awx apply -f awx-demo.yml -n $NAMESPACE
````

>Step3)  monitor the deployment by running various commands
````
$ kubectl --cluster awx logs -f deployments/awx-operator-controller-manager -c awx-manager -n awx
$ kubectl --cluster awx get pods -l "app.kubernetes.io/managed-by=awx-operator"
$ kubectl --cluster awx get svc -l "app.kubernetes.io/managed-by=awx-operator"
$ minikube --cluster awx dashboard
````

>Step4) After a little while, the deployment should be complete. approx 10-15 mins
        Check it by using the following command:
````
$ minikube -p awx service awx-demo-service --url -n $NAMESPACE
http://127.0.0.1:55641
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.

Copy URL and open in browser. Sometimes it may take more time to open.
````
or 
````
$kubectl --cluster awx port-forward svc/awx-demo-service 8010:80 -n awx 
http://127.0.0.1:8010/#/login
````

>Step5) To get the admin password, use the following command. username: admin
````
kubectl --cluster awx get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 –decode
 kubectl --cluster awx get secrets/awx-demo-admin-password -n awx  -o go-template='\n{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'
````

>Step6) To stop awx cluster
````
minikube -p awx stop
````