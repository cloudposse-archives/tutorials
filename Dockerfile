ARG VERSION=latest
ARG OS=debian
ARG CLI_NAME=tutorials

FROM cloudposse/geodesic:$VERSION-$OS

# Move AWS CLI v1 to aws1 and set up alternatives
RUN mv /usr/local/bin/aws /usr/local/bin/aws1 && \
    update-alternatives --install /usr/local/bin/aws aws /usr/local/bin/aws1 1

# Install AWS CLI 2
# Get version from https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst
ARG AWS_CLI_VERSION=2.1.34
RUN AWSTMPDIR=$(mktemp -d -t aws-inst-XXXXXXXXXX) && \
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "$AWSTMPDIR/awscliv2.zip" && \
    cd $AWSTMPDIR && \
    unzip -qq awscliv2.zip && \
    ./aws/install -i /usr/share/aws/v2 -b /usr/share/aws/v2/bin && \
    update-alternatives --install /usr/local/bin/aws aws /usr/share/aws/v2/bin/aws 2 && \
    rm -rf $AWSTMPDIR

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
