FROM maven:3.8.2-jdk-8 AS builder
COPY . /app
RUN mvn -f /app/pom.xml clean install

FROM openjdk:8-jre
COPY --from=builder /app/target/spring-petclinic-2.5.0-SNAPSHOT.jar .
ENTRYPOINT java
CMD -jar spring-petclinic-2.5.0-SNAPSHOT.jar
