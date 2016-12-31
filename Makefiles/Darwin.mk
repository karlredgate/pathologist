
# Mac OSX package

distro_dependencies: release_dependencies
	@echo Check distro dependencies
	[ -x /usr/bin/xsltproc ]
	[ -x /usr/bin/fpm ] || [ -x /usr/local/bin/fpm ]

distro_package: release_package
	@echo Generic Darwin packaging
	fpm -s dir -t osxpkg -n $(PACKAGE) dist

distro_build: release_build
	@echo Generic Darwin build

distro_test: release_test
	@echo Generic Darwin test

distro_clean: release_clean
	@echo Generic Darwin clean
	rm -f $(PACKAGE)*.pkg

VERSION := $(shell sw_vers -productVersion)
include Makefiles/Darwin$(VERSION).mk
