$REPOSITORY_PREFIX = "platform9community"
docker push ${REPOSITORY_PREFIX}/api-gateway:latest
docker push ${REPOSITORY_PREFIX}/visits-service:latest
docker push ${REPOSITORY_PREFIX}/vets-service:latest
docker push ${REPOSITORY_PREFIX}/customers-service:latest
docker push ${REPOSITORY_PREFIX}/admin-server:latest