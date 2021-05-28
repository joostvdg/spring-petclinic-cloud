# Distributed version of the Spring PetClinic - adapted for Platform9 on Kubernetes

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This microservices branch was initially derived from the [microservices version](https://github.com/spring-petclinic/spring-petclinic-microservices) to demonstrate how to split sample Spring application into [microservices](http://www.martinfowler.com/articles/microservices.html).
To achieve that goal we use Spring Cloud Gateway, Spring Cloud Circuit Breaker, Spring Cloud Config, Spring Cloud Sleuth, Resilience4j, Micrometer and the Eureka Service Discovery from the [Spring Cloud Netflix](https://github.com/spring-cloud/spring-cloud-netflix) technology stack. While running on Kubernetes, some components (such as Spring Cloud Config and Eureka Service Discovery) are replaced with Kubernetes-native features such as config maps and Kubernetes DNS resolution.

This fork also demostrates the use of a free Platform9 managed Kubernetes cluster, which provides full monitoring capabilites.

## Understanding the Spring Petclinic application

[See the presentation of the Spring Petclinic Framework version](http://fr.slideshare.net/AntoineRey/spring-framework-petclinic-sample-application)

[A blog bost introducing the Spring Petclinic Microsevices](http://javaetmoi.com/2018/10/architecture-microservices-avec-spring-cloud/) (french language)

![Spring Petclinic Microservices screenshot](./docs/application-screenshot.png?lastModify=1596391473)

## Running in Kubernetes with Heml

```powershell
helm repo add Platform9-Community https://platofrm9-community.github.io/helm-charts
helm repo update
helm install spring-petclinic-cloud Platform9-Community/spring-petclinic-cloud
```

## Manually running in Kubernetes

### Create the namespace

```powershell
kubectl apply -f ./k8s/init-namespace/
```

### Create storage class

```powershell
#creates a namespace for an operator
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/master/deploy/namespace.yaml
#deploys the operator
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/master/deploy/operator.yaml -n hostpath-provisioner
#creates the storage class
kubectl create -f  https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/main/deploy/storageclass-wffc.yaml
#custom resource
kubectl create -f https://raw.githubusercontent.com/kubevirt/hostpath-provisioner-operator/master/deploy/hostpathprovisioner_cr.yaml -n hostpath-provisioner
#mark as default
kubectl patch storageclass hostpath-provisioner -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

### Deploy monitoring settings

!!! must be done before deploying the helm charts

```powershell
kubectl apply -f ./k8s/init-monitoring
```

```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

helm install grafana grafana/grafana --namespace spring-petclinic --set sidecar.dashboards.enabled=true --set sidecar.datasources.enabled=true
helm install prometheus prometheus-community/prometheus --namespace spring-petclinic
helm install vets-db-mysql bitnami/mysql --namespace spring-petclinic --version 6.14.3 --set db.name=service_instance_db
helm install visits-db-mysql bitnami/mysql --namespace spring-petclinic  --version 6.14.3 --set db.name=service_instance_db
helm install customers-db-mysql bitnami/mysql --namespace spring-petclinic  --version 6.14.3 --set db.name=service_instance_db
```

### Deploy application and their services

```powershell
Get-ChildItem ./k8s *.yaml | ForEach-Object { (Get-Content -path $_.FullName -Raw | kubectl apply --namespace spring-petclinic -f - }

kubectl apply --namespace spring-petclinic -f ./k8s/init-services
```

```bash
XXXXXX

kubectl apply --namespace spring-petclinic -f ./k8s/init-services
```

### Set port forwarding and get URLs

```powershell
$EncodedText = (kubectl get secret --namespace spring-petclinic grafana -o jsonpath="{.data.admin-password}")

echo "Starting grafana forwarding in background"
$j1 = Start-Job { kubectl --namespace spring-petclinic port-forward (kubectl get pods --namespace spring-petclinic -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}") 3000 }

echo "Starting pet clinic forwarding in background"
$j2 = Start-Job { kubectl --namespace spring-petclinic port-forward (kubectl get pods --namespace spring-petclinic -l "app=api-gateway" -o jsonpath="{.items[0].metadata.name}") 8080 }

echo "GRAFANA - http://localhost:3000
    Username: admin
    Password: $([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedText)))

"
echo "PET CLINIC - http://localhost:8080

"

echo "To stop forwarding: Stop-Job $($j1.Id); Stop-job $($j2.Id)"
```

```bash
EncodedText=(kubectl get secret --namespace spring-petclinic grafana -o jsonpath="{.data.admin-password}")

echo "Starting grafana forwarding in background"


kubectl apply --namespace spring-petclinic -f ./k8s/init-services

```
