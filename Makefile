# Set default environment (can be overridden by `make <target> ENV=<env>`)
ENV ?= dev

# Define the default binary name
TARGET_BIN = target/debug/rdza

# Run the app in the chosen environment
run:
	@echo "Running app in $(ENV) environment..."
	@echo "Using environment variable APP_ENV=$(ENV)"
	@$(MAKE) run-env

# Helper target to run in dev mode
run-env:
ifeq ($(ENV), dev)
	@echo "Starting app in development mode (localhost:3030)"
	@cargo run
else ifeq ($(ENV), prod)
	@echo "Starting app in production mode"
	@cargo run --release
else
	$(error Unknown environment: $(ENV))
endif

# Clean the build artifacts
clean:
	@echo "Cleaning project..."
	@cargo clean

# Build the project (release version)
build:
	@echo "Building project (release mode)..."
	@cargo build --release

# Run tests
test:
	@echo "Running tests..."
	@cargo test

# Help message for the available commands
help:
	@echo "Makefile for Rust Warp Example"
	@echo "Targets:"
	@echo "  run         Run the application in the specified environment (dev or prod)"
	@echo "  clean       Clean the build artifacts"
	@echo "  build       Build the project in release mode"
	@echo "  test        Run the project's tests"
	@echo "  help        Show this help message"
