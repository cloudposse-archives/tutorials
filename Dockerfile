ARG VERSION=latest
ARG OS=debian
ARG CLI_NAME=tutorials
ARG TF_1_VERSION=1.3.0
ARG ATMOS_VERSION=1.4.20

FROM cloudposse/geodesic:$VERSION-$OS

# Install ubuntu universe repo so we can install more helpful packages
RUN apt-get install -y software-properties-common && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic universe" && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 3B4FE6ACC0B21F32 && \
    gpg --export --armor 3B4FE6ACC0B21F32 | apt-key add - && \
    apt-get update && \
    apt-get install -y golang-petname


ARG TF_1_VERSION
# Install terraform.
RUN apt-get update && apt-get install -y -u --allow-downgrades \
    terraform-1="${TF_1_VERSION}-*" && \
    update-alternatives --set terraform /usr/share/terraform/1/bin/terraform

# Install Atmos
ARG ATMOS_VERSION
RUN apt-get install -y --allow-downgrades \
    atmos="${ATMOS_VERSION}-*" \
    vendir

# Geodesic message of the Day
ENV MOTD_URL=""

ENV AWS_VAULT_BACKEND=file

ENV DOCKER_IMAGE="cloudposse/tutorials"
ENV DOCKER_TAG="latest"

# Geodesic banner
ENV BANNER="Tutorials"

COPY rootfs/ /
COPY ./ /tutorials

WORKDIR /
