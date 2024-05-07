SHELL:=/usr/bin/env bash

VERSION=v4.12.2
APP_NAME=Swagger Editor
ARCH=arm64
TARGET_DIR=./build/${APP_NAME}-darwin-${ARCH}
APP_DIR=${TARGET_DIR}/${APP_NAME}.app
APP_URL=file:///Applications/${APP_NAME}.app/index.html
SE_SRC=./build/swagger-editor
define BUILD_FLAGS
-n "${APP_NAME}" \
--insecure \
--ignore-certificate \
--disable-dev-tools \
--min-width 600 \
--min-height 400 \
--app-version ${VERSION}
endef

default: help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: check-deps
check-deps:  ## Verify build dependencies are installed
	@command -v nativefier >/dev/null 2>&1 || echo "[!] Missing nativefier: npm install nativefier"

.PHONY: clean
clean:  ## Clean mac build directory
	rm -rf "./build"

.PHONY: build
build: clean check-deps  ## Build app for macOS/arm64
	nativefier "${APP_URL}" ${BUILD_FLAGS} \
		-i ./swagger-logo.icns \
		--fast-quit \
		--darwin-dark-mode-support \
		-p mac -a ${ARCH} ./build

.PHONY: download-src
download-src:
	git clone https://github.com/swagger-api/swagger-editor.git ${SE_SRC} --branch ${VERSION} 

.PHONY: install
install: build download-src  ## Build & install to /Applications on macOS
	cp ${SE_SRC}/index.html "./${APP_DIR}"
	cp -R ${SE_SRC}/dist "./${APP_DIR}/"
	cp -R "./${APP_DIR}" /Applications
