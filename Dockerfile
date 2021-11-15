FROM openjdk:8-jre
COPY /target/spring-petclinic-2.5.0-SNAPSHOT.jar .
EXPOSE 8081
