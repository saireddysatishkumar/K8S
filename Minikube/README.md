### Hi there 👋

>Install minikube. [minikube installation guide](https://minikube.sigs.k8s.io/docs/start/) 
````
$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
$ sudo install minikube-darwin-amd64 /usr/local/bin/minikube
$ minikube start --extra-config=apiserver.service-node-port-range=1-65535 --cpus=4 --memory=6g --addons=ingress
#set the alias:- alias kubectl="minikube kubectl --"
$ minikube addons enable ingress
$ minikube tunnel
````

> Deploy sample applications
````
kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml  

>Now verify that the ingress works
$ curl 127.0.0.1/foo
Request served by foo-app

$ curl 127.0.0.1/bar
Request served by bar-app
````

>To access minikube dashboard  
$ minikube dashboard 


<!--
**saireddysatishkumar/saireddysatishkumar** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...

- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...
-->
