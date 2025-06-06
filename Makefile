
ROOT := $(shell git rev-parse --show-toplevel)
FLUTTER := $(shell which flutter)
FLUTTER_BIN_DIR := $(shell dirname $(FLUTTER))
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
DART := $(FLUTTER_BIN_DIR)/cache/dart-sdk/bin/dart

# Flutter
.PHONY: analyze
analyze:
	$(FLUTTER) analyze

.PHONY: test
test:
	$(FLUTTER) test

.PHONY: codegen
codegen:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs
    
.PHONY: run
run:
	$(FLUTTER) run -t lib/main/main.dart

.PHONY: codegen-cached
codegen-cached:
	flutter pub run build_runner build

.PHONY: codegen
codegen:
	flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: codegen-release
codegen-release:
	flutter pub run build_runner build --delete-conflicting-outputs --config release