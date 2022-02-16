# Distributed version of the Spring PetClinic - adapted for Platform9 on Kubernetes

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This microservices branch was initially derived from the [microservices version](https://github.com/spring-petclinic/spring-petclinic-microservices) to demonstrate how to split sample Spring application into [microservices](http://www.martinfowler.com/articles/microservices.html).
To achieve that goal we use Spring Cloud Gateway, Spring Cloud Circuit Breaker, Spring Cloud Config, Spring Cloud Sleuth, Resilience4j, Micrometer and the Eureka Service Discovery from the [Spring Cloud Netflix](https://github.com/spring-cloud/spring-cloud-netflix) technology stack. While running on Kubernetes, some components (such as Spring Cloud Config and Eureka Service Discovery) are replaced with Kubernetes-native features such as config maps and Kubernetes DNS resolution.

This fork also demostrates the use of a free Platform9 managed Kubernetes cluster, which provides full monitoring capabilites.

## Understanding the Spring Petclinic application

[See the presentation of the Spring Petclinic Framework version](http://fr.slideshare.net/AntoineRey/spring-framework-petclinic-sample-application)

[A blog bost introducing the Spring Petclinic Microsevices](http://javaetmoi.com/2018/10/architecture-microservices-avec-spring-cloud/) (french language)

![Spring Petclinic Microservices screenshot](./docs/application-screenshot.png?lastModify=1596391473)

## Running the application in Kubernetes

This project has a helm chart that is listed in [ArtifactHub](https://artifacthub.io/packages/helm/platform9-community/spring-petclinic-cloud) or is available from [its home](https://platform9-community.github.io/helm-charts/spring-petclinic-cloud/). Please refer to that readme for a more detailed description of what is deployed.

## Testing

Test #2
