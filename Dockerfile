# Use the official Rust 1.84.1 slim bookworm image as the base image
FROM rust:1.84.1-slim-bookworm AS builder

# Set the working directory for the build
WORKDIR /app

# Copy the `Cargo.toml` and `Cargo.lock` (if available) to the container
# This helps leverage Docker's cache to avoid rebuilding dependencies on every change
COPY Cargo.toml Cargo.lock ./

# Fetch dependencies to cache them
RUN cargo fetch

# Copy the rest of the application code
COPY . .

# Build the project in release mode
RUN cargo build --release

# The runtime image (smaller and cleaner)
FROM debian:bookworm-slim

# Install necessary dependencies for running the Rust app
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the runtime container
WORKDIR /app

# Copy the built binary from the builder image to the runtime image
COPY --from=builder /app/target/release/rdza .

# Expose the port your application will listen on (e.g., 8080 or 3030)
EXPOSE 3030

# Set the environment variable to define the app's behavior (can be overridden with Docker run)
ENV APP_ENV=dev

# Command to run the app
CMD ["./rdza"]
