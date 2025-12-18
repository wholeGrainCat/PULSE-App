# ===============================
# Stage 1: Build Flutter Web App
# ===============================
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory inside container
WORKDIR /app

# Copy dependency configuration first (better caching)
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

# Copy the rest of the project
COPY . .

# Build Flutter web release
RUN flutter build web --release


# ===============================
# Stage 2: Serve with Nginx
# ===============================
FROM nginx:alpine

# Copy built web files to Nginx public directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
