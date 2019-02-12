ARG target=arm64v8
FROM $target/debian:9.3-slim

ARG arch=aarch64
ENV ARCH=$arch

COPY .blank tmp/qemu-$ARCH-static* /usr/bin/

LABEL maintainer="Anjo Kolk"

RUN apt-get update && apt-get install libav-tools -y --force-yes

ADD ./convert.sh /usr/bin/convert.sh

VOLUME /media

CMD ["convert.sh"]
