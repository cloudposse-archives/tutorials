ARG VERSION=latest
ARG OS=alpine
ARG CLI_NAME=atmos

FROM cloudposse/geodesic:$VERSION-$OS

# Geodesic message of the Day
ENV MOTD_URL="https://geodesic.sh/motd"

ENV DOCKER_IMAGE="cloudposse/atmos"
ENV DOCKER_TAG="latest"

# Geodesic banner
ENV BANNER="Atmos Tutorial"

# Install terraform.
RUN apk add -u terraform-0.14@cloudposse
# Set Terraform 0.14.x as the default `terraform`.
RUN update-alternatives --set terraform /usr/share/terraform/0.14/bin/terraform

# Install Atmos
RUN apk add atmos@cloudposse

COPY components/ /components/
COPY stacks/ /stacks/

WORKDIR /
