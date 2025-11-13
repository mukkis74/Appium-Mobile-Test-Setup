# Appium mobile test runner
FROM maven:3.9.6-eclipse-temurin-17

# Optional: make logs more readable
ENV MAVEN_OPTS="-Dmaven.test.redirectTestOutputToFile=false"

# Install Node + npm (for Appium client utilities if needed inside container)
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g appium-doctor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy pom and resolve dependencies
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copy test sources
COPY src ./src

# Default command (overridden in CI script)
CMD ["mvn", "-B", "test"]