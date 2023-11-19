## Installation
To install the microservices, update the ```values.yaml``` file in the ```e-commerce-app``` directory with your own configurations and run:
``` helm install <name of the chart> e-commerce-app```

The application needs 3 databases, one for each microservice. To install the helmcharts for the different databases, follow these steps:

1- Create a custom yaml file, for example ```values.yaml```, for each of the databases, each containing the database credentials and the persistent volume and volume claim informations (like the examples in the folders)

2- Add the bitnami repository to helm installation:
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

3- Install the postgresql charts for each database and override its ```values.yaml``` with your own credentials, using the ```values.yaml``` file you created in the first step.
```
# Authentication microservice database
helm install db-auth -f <your custom values.yaml> bitnami/postgresql

# Order microservice database
helm install db-order -f <your custom values.yaml> bitnami/postgresql

# Product microservice database
helm install db-product -f <your custom values.yaml> bitnami/postgresql
```
###### Make sure that the names of the services created by this helmcharts are the dame ones used in the values.yaml of the microservices helmcharts, verify with ``` kubectl get services``` or ```kubectl get all```
