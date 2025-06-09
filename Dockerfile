# === Stage 1: Build the WAR file ===
FROM maven:3.8.5-openjdk-8 AS builder

WORKDIR /app
COPY . /app

RUN mvn clean package

# === Stage 2: Deploy WAR to Tomcat ===
FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy built WAR file from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/WebAppCal.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
