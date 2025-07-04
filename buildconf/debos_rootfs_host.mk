#!/usr/bin/make -f

# DEBOS_DIR
include env_x86.mk

OSPACK_IMAGE = $(DEBOS_DIR)/out/ospack-debian-arm64-trixie.tar.gz
OSPACK_YAML = $(DEBOS_DIR)/opencca-ospack-debian.yaml

.PHONY: debos clean

build: rk3588 ## build root file system
 
$(OSPACK_IMAGE): $(OSPACK_YAML)
	cd $(DEBOS_DIR) && \
	mkdir -p out && \
    debos  --artifactdir=out -t architecture:arm64 opencca-ospack-debian.yaml

rk3588: $(OSPACK_IMAGE)
	cd $(DEBOS_DIR) && \
	debos  --artifactdir=out -t architecture:arm64 \
		-t platform:rock5b-rk3588 opencca-image-rockchip-rk3588.yaml

