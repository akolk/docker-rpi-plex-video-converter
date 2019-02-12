ARG target=arm64v8
ARG arch=aarch64
ENV ARCH=$arch
ARG tag
ENV TAG=$tag

FROM $target/debian:9.3-slim as builder
#FROM debian:stable-slim as builder

COPY .blank tmp/qemu-$ARCH-static* /usr/bin

FROM builder

LABEL maintainer="Anjo Kolk"

RUN apt-get update && apt-get install libav-tools -y --force-yes

ADD ./convert.sh /usr/bin/convert.sh

VOLUME /media

CMD ["convert.sh"]
