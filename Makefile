.PHONY: help clean build fmt lint vet run test style cyclo

SOURCES:=$(shell find . -name '*.go')
BINARY:=insights-operator-web-ui

default: build

clean: ## Run go clean
	@go clean

build: ${BINARY} ## Keep this rule for compatibility

${BINARY}: ${SOURCES}
	./build.sh

fmt: ## Run go fmt -w for all sources
	@echo "Running go formatting"
	./gofmt.sh

lint: ## Run golint
	@echo "Running go lint"
	./golint.sh

vet: ## Run go vet. Report likely mistakes in source code
	@echo "Running go vet"
	./govet.sh

cyclo: ## Run gocyclo
	@echo "Running gocyclo"
	./gocyclo.sh

ineffassign: ## Run ineffassign checker
	@echo "Running ineffassign checker"
	./ineffassign.sh

shellcheck: ## Run shellcheck
	shellcheck *.sh

errcheck: ## Run errcheck
	@echo "Running errcheck"
	./goerrcheck.sh

goconst: ## Run goconst checker
	@echo "Running goconst checker"
	./goconst.sh

gosec: ## Run gosec checker
	@echo "Running gosec checker"
	./gosec.sh

abcgo: ## Run ABC metrics checker
	@echo "Run ABC metrics checker"
	./abcgo.sh

style: fmt vet lint cyclo shellcheck errcheck gosec ineffassign abcgo ## Run all the formatting related commands (fmt, vet, lint, cyclo)

run: clean build ## Build the project and executes the binary
	./${BINARY}

test: clean build ## Run the unit tests
	@go test -coverprofile coverage.out $(shell go list ./... | grep -v tests)

help: ## Show this help screen
	@echo 'Usage: make <OPTIONS> ... <TARGETS>'
	@echo ''
	@echo 'Available targets are:'
	@echo ''
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ''
