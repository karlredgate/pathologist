
DISTRO := $(shell lsb_release -is)
include Makefiles/$(DISTRO).mk

RELEASE := $(shell lsb_release -rs)
include Makefiles/$(DISTRO)$(RELEASE).mk

CODENAME := $(shell lsb_release -cs)
include Makefiles/$(CODENAME).mk
