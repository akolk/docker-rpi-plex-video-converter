VERSION ?= 0.2.0
FULLVERSION ?= ${VERSION}
archs = amd64 arm32v5 arm32v7 arm64v8 i386

.PHONY: all build publish latest
all: build publish latest
build:
	cp /usr/bin/qemu-*-static .
	$(foreach arch,$(archs), \
		cat Dockerfile | sed "s/FROM debian:stable-slim/FROM ${arch}\/debian:stable-slim/g" > .Dockerfile; \
		docker build -t jaymoulin/rpi-plex-video-converter:${VERSION}-$(arch) -f .Dockerfile .;\
	)
publish:
	docker push jaymoulin/rpi-plex-video-converter
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish