ARG VERSION=latest
ARG OS=debian
ARG CLI_NAME=tutorials

FROM cloudposse/geodesic:$VERSION-$OS

# Install ubuntu universe repo so we can install more helpful packages
RUN apt-get install -y software-properties-common && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu bionic universe" && \
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 3B4FE6ACC0B21F32 && \
    gpg --export --armor 3B4FE6ACC0B21F32 | apt-key add - && \
    apt-get update && \
    apt-get install -y golang-petname


# Install terraform.
RUN apt-get update && apt-get install -y -u terraform-0.14
# Set Terraform 0.14.x as the default `terraform`.
RUN update-alternatives --set terraform /usr/share/terraform/0.14/bin/terraform

# Install Atmos
RUN apt-get install -y --allow-downgrades \
    atmos \
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
