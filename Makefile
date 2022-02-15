REPOSITORY_PREFIX=joostvdgtanzu
# https://blog.frankel.ch/faster-maven-builds/1/

test:
	mvnd test -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e
verify:
	mvnd clean verify -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e
compile:
	mvnd compile -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e
install:
	mvnd install -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e

release:
	mvnd jreleaser:full-release -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e

package:
	mvnd clean package -Dparallel=all -DperCoreThreadCount=false -DthreadCount=16 -T 1C -e

image-build:
    mvn spring-boot:build-image -P k8s -D REPOSITORY_PREFIX=${REPOSITORY_PREFIX}

image-push:
    docker push ${REPOSITORY_PREFIX}/api-gateway:latest
    docker push ${REPOSITORY_PREFIX}/visits-service:latest
    docker push ${REPOSITORY_PREFIX}/vets-service:latest
    docker push ${REPOSITORY_PREFIX}/customers-service:latest
    docker push ${REPOSITORY_PREFIX}/admin-server:latest
