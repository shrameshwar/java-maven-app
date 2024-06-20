FROM openjdk:8
WORKDIR /app
COPY ./target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
