# Use an official Maven image to build the project
FROM maven:3.9.4-eclipse-temurin-17 AS builder

# Set the working directory
WORKDIR /app

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Build the project
RUN mvn package

# Use a lightweight JDK image to run the application
FROM eclipse-temurin:17-jdk-alpine

# Set the working directory
WORKDIR /app



# Copy the JAR file from the build stage
COPY --from=builder /app/target/maven-project-0.0.1-SNAPSHOT.jar app.jar


# Expose port (optional, if your app listens on a port)
# EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
