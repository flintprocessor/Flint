BIN_NAME = flint
USR_BIN_PATH = /usr/local/bin/
RELEASE_BIN_BUILD_PATH = ./.build/release/
DEBUG_BIN_BUILD_PATH = ./.build/debug/

.PHONY: all release debug build-release build-debug
	install-release install-debug uninstall sync-version git-reset

all: release install-release git-reset

release: sync-version build-release
debug: build-debug install-debug

# Build
build-release:
	swift build -c release -Xswiftc -static-stdlib
build-debug:
	swift build -c debug -Xswiftc -static-stdlib

# Install
install-release:
	cp -f $(RELEASE_BIN_BUILD_PATH)$(BIN_NAME) $(USR_BIN_PATH)$(BIN_NAME)
install-debug:
	cp -f $(DEBUG_BIN_BUILD_PATH)$(BIN_NAME) $(USR_BIN_PATH)$(BIN_NAME)
uninstall:
	rm $(USR_BIN_PATH)$(BIN_NAME)

sync-version:
	swift Scripts/SyncVersion.swift
git-reset:
	git reset --hard
