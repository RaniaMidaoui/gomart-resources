# ArgoCD
Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.
It follows the GitOps pattern of using Git repositories as the source of truth for defining the desired application state. 

Kubernetes manifests can be specified in several ways:
- kustomize applications
- helm charts
- jsonnet files
- Plain directory of YAML/json manifests
- Any custom config management tool configured as a config management plugin.

ArgoCD is deployed directly in the Kubernetes cluster. It is an extension to the Kubernetes API, because it is a Kubernetes Controller itself and uses some of the existing functionalities for doing its job (for example it uses `etcd` to store its data).

The ArgoCD Controller will watch the Git repo for changes and deploy the new changes.


#### Architecure Overview:

![ArgoCD ARchitecure from docs](https://argo-cd.readthedocs.io/en/stable/assets/argocd_architecture.png)

Argo CD control plane consists of three essential components- Application Controller, API Server, and Repository Service.

###### Application Controller
The application controller is a Kubernetes controller which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the repo). It detects OutOfSync application state and optionally takes corrective action. It is responsible for invoking any user-defined hooks for lifecycle events (PreSync, Sync, PostSync). It gives you the ability to declaratively deploy containerized applications in a Kubernetes Manifest utilizing a Custom Resource Definition (CRD).

###### Repository Server
The repository server of Argo CD is an internal service that maintains a local cache of the Git repo. On providing the input, such as repository URL, Git revisions( branch, tags), application path, and template-specific settings, the server generates Kubernetes manifests.

###### API Server
The API server is the gRPC/REST server, which provides API endpoints to Argo web UI and CLI, and other CI/CD systems. The APIs are primarily used to carry out functionalities such as application deployment and management, executing rollback or any user-defined actions, storing K8S cluster credentials, etc.


#### Aapplications:
The Application CRD is the Kubernetes resource object representing a deployed application instance in an environment. It is defined by two key pieces of information:

- `source` reference to the desired state in Git (repository, revision, path, environment)
- `destination` reference to the target cluster and namespace. For the cluster one of server or name can be used, but not both (which will result in an error). Under the hood when the server is missing, it is calculated based on the name and used for any operations.
  
By default, the Application CRD is `namespaced` which ties the Application access to the provided namespace, but it can be configured as `cluster-scpoed`. More details can be found in the [ArgoCD documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/app-any-namespace/#switch-resource-tracking-method).

## ArgoCD Installation using helm
1 - After connecting to the cluster in Minikube, clone the public repo to pull the source of Argo CD from Github.
Link to Argo CD source code: https://github.com/argoproj/argo-helm.git
`git clone https://github.com/argoproj/argo-helm.git`


2 - Change the directory or the folder where you need to install Argo using helm charts:
`cd argo-helm/charts/argo-cd/`


3 - Create a namepsace (we have named myargo) in the folder for argo installation:
`kubectl create ns myargo`

4 - Update the dependencies in the chart:
`helm dependency up`


5 - Install argo using helm command:
You can modify any custom values in `values.yaml` or create a custom one and override some values in `values.yaml`.
```
# If using the already given values or modified the given file:
helm install myargo . -f values.yaml -n myargo

#If new values file was created to override some values:
helm install myargo -f <your custom values.yaml> -n myargo
```

6 - Access ArgoCD:
port-forward the Argo cd service to access the service from the browser:
`kubectl port-forward service/myargo-argocd-server 8090:80 -n myargo`

Argo auto-generated a password for the initial acces, so if you did not modify that in the provoded `values.yaml` or your custom values files, you can get it by: 
`kubectl -n myargo get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d`


##### To uninstall ArgoCD:
`helm uninstall myargo  -n myargo`

##### Running the ArgoCD application
This command only needs to be executed once, after that, ArgoCD will make sure that your application is in the desired state and update it if not automatically:
```kubectl apply -f argo-config/application.yaml -n myargo```

PS: Make sure to connect any git repository you use from the ArgoCD UI or CLI, providing the right credentials.
## ArgoCD image updater:
A tool to automatically update the container images of Kubernetes workloads that are managed by Argo CD.

You annotate your Argo CD Application resources with a list of images to be considered for update, along with a version constraint to restrict the maximum allowed new version for each image. Argo CD Image Updater then regularly polls the configured applications from Argo CD and queries the corresponding container registry for possible new versions. If a new version of the image is found in the registry, and the version constraint is met, Argo CD Image Updater instructs Argo CD to update the application with the new image.

Image updater is already installed with the ArgoCD helmchart from the previous section, you will just need to configure it to watch Docker Hub in the `charts/argocd-image-updater/values.yaml`:

```
registries:
    - name: Docker Hub
      prefix: docker.io
      api_url: https://registry-1.docker.io
      credentials: secret:myargo/<secret name>#<field>
      defaultns: library
      default: true
```