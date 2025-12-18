# ==========================================
# STAGE 1: The Build Factory
# ==========================================
# Use the official Flutter Docker image (includes Dart, Java, Android SDK)
FROM ghcr.io/cirruslabs/flutter:stable

# Set the working directory inside the container
WORKDIR /app

# 1. Copy dependency definitions first (Optimization)
# This allows Docker to cache dependencies if files haven't changed
COPY pubspec.* ./
RUN flutter pub get

# 2. Copy the rest of the application source code
COPY . .

# 3. Build the Release APK
# We limit Gradle memory to 1.5GB so it doesn't crash Docker
ENV GRADLE_OPTS="-Dorg.gradle.jvmargs=-Xmx1536m"
RUN flutter build apk --release

# 4. PROOF OF SUCCESS 
# This command lists the generated APK file size in the terminal log
# showing that the build actually worked.
RUN ls -lh build/app/outputs/flutter-apk/app-release.apk