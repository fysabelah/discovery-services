#
# Build stage
#
FROM maven:3.9.6-amazoncorretto-21 AS build

WORKDIR /server-discovery

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests

#
# Package stage
#
FROM amazoncorretto:21-alpine-jdk

WORKDIR /server-discovery

COPY --from=build /server-discovery/target/*.jar ./server-discovery.jar

EXPOSE 7070

ENTRYPOINT ["java","-jar","server-discovery.jar"]