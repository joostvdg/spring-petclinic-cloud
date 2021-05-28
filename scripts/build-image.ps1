$REPOSITORY_PREFIX = "platform9community"
./mvnw spring-boot:build-image -P k8s -D REPOSITORY_PREFIX=${REPOSITORY_PREFIX}