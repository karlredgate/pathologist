
PACKAGE = redgate-diagnostics
PWD := $(shell pwd)

default: dependencies package

OS := $(shell uname -s)

include Makefiles/$(OS).mk

dependencies: distro_dependencies
	@echo "Dependencies checked"

package: dist distro_package
	@echo "Created $(PACKAGE) package for $(DISTRO)"

dist: build
	mkdir -p dist/usr/bin
	cp bin/* dist/usr/bin
	mkdir -p dist/usr/share/redx/diagnostics
	cp diagnostics.rdf dist/usr/share/redx/diagnostics/
	mkdir -p dist/usr/libexec/redx/diagnostics
	cp libexec/redx/diagnostics/* dist/usr/libexec/redx/diagnostics

build: distro_build

TESTDB=testdata
test: distro_test
	xsltproc diagscript.xslt diagnostics.rdf | sudo bash
	-rdfproc $(TESTDB) parse diagnostics.rdf
	-rapper --count diagnostics.rdf

clean: distro_clean
	rm -f $(TESTDB)*.db dist
