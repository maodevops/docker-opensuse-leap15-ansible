#
# Dockerfile used to build openSUSE Leap 15 images for testing Ansible
#

# syntax = docker/dockerfile:1

ARG BASE_IMAGE_TAG=15

FROM opensuse/leap:${BASE_IMAGE_TAG}

ENV container=docker

RUN zypper install -y dbus-1 systemd-sysvinit && \
  cd /usr/lib/systemd/system/sysinit.target.wants/; \
  for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done ; \
  rm -f /usr/lib/systemd/system/multi-user.target.wants/* ; \
  rm -f /etc/systemd/system/*.wants/* ; \
  rm -f /usr/lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /usr/lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /usr/lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /usr/lib/systemd/system/basic.target.wants/* ; \
  rm -f /usr/lib/systemd/system/anaconda.target.wants/*

RUN zypper update -y ; \
  zypper install -y python310 python310-pip ; \
  update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 ; \
  pip3 install --no-cache-dir --upgrade pip ; \
  zypper install -y \
    sudo \
    which

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/lib/systemd/systemd"]
