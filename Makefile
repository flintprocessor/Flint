BIN_NAME = flint
USR_BIN_PATH = /usr/local/bin/
BIN_BUILD_PATH = ./.build/release/

.PHONY: all build install uninstall

all: build install
build:
	swift build -c release -Xswiftc -static-stdlib
install:
	cp -f $(BIN_BUILD_PATH)$(BIN_NAME) $(USR_BIN_PATH)$(BIN_NAME)
uninstall:
	rm $(USR_BIN_PATH)$(BIN_NAME)
