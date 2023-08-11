# awx in minikube.
Reference:
[a link](https://minikube.sigs.k8s.io/docs/start/)
[a link](https://subscription.packtpub.com/book/cloud-and-networking/9781803244884/4/ch04lvl1sec17/installing-awx-on-minikube)

>Step1) Install minikube.
````
$ minikube start --extra-config=apiserver.service-node-port-range=1-65535 --cpus=4 --memory=6g --addons=ingress
$ set the alias:- alias kubectl="minikube kubectl --"
````

>Step2) Install AWX Operator
```` 
$ git clone https://github.com/ansible/awx-operator.git
$ cd awx-operator
$ export NAMESPACE=my-namespac
$ make deploy
$ kubectl get pods -n $NAMESPACE
$ kubectl config set-context --current --namespace=$NAMESPACE
````

>Step3) Launch awx deployment
````
awx-demo.yml
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
    name: awx-demo
spec:
    service_type: nodeport


$ kubectl apply -f awx-demo.yml -n $NAMESPACE
````

>Step4)  monitor the deployment by running various commands
````
$ kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager
$ kubectl get pods -l "app.kubernetes.io/managed-by=awx-operator"
$ kubectl get svc -l "app.kubernetes.io/managed-by=awx-operator"
$ minikube dashboard
````

>Step5) After a little while, the deployment should be complete. approx 10-15 mins
        Check it by using the following command:
````
$ minikube service awx-demo-service --url -n $NAMESPACE
http://127.0.0.1:55641
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.

Copy URL and open in browser. Sometimes it may take more time to open.
````

>Step6) To get the admin password, use the following command:
````
$ kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 –decode
````
