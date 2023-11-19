This folder contains the Kubernetes manifests needed for all the microservices and the API Gateway.

To apply all the manifests you can run: 
`kubectl apply -Rf .`

If you want to run each microservice on its own, just state the path for ots manifests, every folder is dedicated for a single microservice and its database.

To test the microservices, get the microservice's service url with minikube:
`minikube service <service-name> --url`

If you want to delete the deployments:
`kubectl delete -Rf .`