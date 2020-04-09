SHELL:=/usr/bin/env bash

VERSION=0.0.1
APP_URL="https://editor.swagger.io/"
define BUILD_FLAGS
-n "Swagger Editor" \
--disable-dev-tools \
--min-width 600 \
--min-height 400 \
--width 1100 \
--height 1000 \
--app-version ${VERSION}
endef

default: help
# via https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build dependencies are installed
	@command -v nativefier >/dev/null 2>&1 || echo "[!] Missing nativefier: npm install -g nativefier"

.PHONY: clean-mac
clean-mac:  ## Clean mac build directory
	rm -rf ./mac

.PHONY: build-mac
build-mac: clean-mac check-deps  ## Build app for macOS/x64
	mkdir ./mac
	nativefier ${APP_URL} ${BUILD_FLAGS} \
		-i ./swagger-logo.icns \
		--fast-quit \
		--darwin-dark-mode-support \
		-p mac -a x64 ./mac

.PHONY: install-mac
install-mac: build-mac  ## Build & install to /Applications on macOS
	cp -R "./mac/Swagger Editor-darwin-x64/Swagger Editor.app" /Applications
