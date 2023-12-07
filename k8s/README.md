This folder contains the Kubernetes manifests needed for all the microservices and the API Gateway.

If you're using minikube, you should enable the addon ingress in minikube in order to have an ingress-controller, which is mandatory for any ingress resource we're creating, to do that run:
```
minikube addons enable ingress
```
You can also install the ingress nginx controller in any cluster you have, with manifests:
```
#Use the version that suits you, here we're using v1.1.3
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/baremetal/deploy.yaml
```

To apply all the manifests you can run: 
`kubectl apply -Rf .`

If you want to run each microservice on its own, just state the path for ots manifests, every folder is dedicated for a single microservice and its database.

To test the microservices, get the microservice's service url with minikube:
`minikube service <service-name> --url`

If you want to delete the deployments:
`kubectl delete -Rf .`
