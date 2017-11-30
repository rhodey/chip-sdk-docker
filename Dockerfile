FROM alpine:edge

MAINTAINER rhodey@anhonestefort.org

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk update

RUN apk add bash \
  wget \
  curl \
  unzip \
  git \
  make \
  libc-dev \
  gcc \
  linux-headers \
  util-linux-dev \
  dpkg-dev \
  acl-dev \
  zlib-dev \
  lzo-dev \
  libusb-dev \
  ppp \
  android-tools@testing \
  uboot-tools@testing

WORKDIR /root

RUN git clone \
  --single-branch --depth 1 --branch master \
  http://github.com/linux-sunxi/sunxi-tools && \
  cd sunxi-tools && \
  make && \
  make misc && \
  make install && \
  make install-misc && \
  cd ..

ARG MTD_BRANCH=by/1.5.2/next-mlc-debian

RUN git clone \
  --single-branch --depth 1 --branch ${MTD_BRANCH} \
  http://github.com/nextthingco/chip-mtd-utils && \
  cd chip-mtd-utils && \
  make && \
  make install && \
  cd ..

ARG TOOLS_BRANCH=chip/stable-busybox

RUN git clone \
  --single-branch --depth 1 --branch ${TOOLS_BRANCH} \
  https://github.com/rhodey/CHIP-tools && \
  cd CHIP-tools && \
  cd ..

ARG BLD_ROOT_BRANCH=chip/stable

RUN git clone \
  --single-branch --depth 1 --branch ${BLD_ROOT_BRANCH} \
  https://github.com/NextThingCo/CHIP-buildroot

RUN mv /usr/local/bin/sunxi-fel /usr/local/bin/sunxi-fel.orig && \
  mv /usr/bin/fastboot /usr/bin/fastboot.orig

ADD sunxi-fel-mdev.sh /usr/local/bin/sunxi-fel
ADD fastboot-mdev.sh /usr/bin/fastboot

WORKDIR /root/CHIP-tools
