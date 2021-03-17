ARG VERSION=0.141.6
ARG OS=alpine
ARG CLI_NAME=atmos

# FROM cloudposse/geodesic:$VERSION-$OS as cli

# RUN apk add -u go variant2@cloudposse

# # Configure Go
# ENV GOROOT /usr/lib/go
# ENV GOPATH /go
# ENV PATH /go/bin:$PATH

# # Build a minimal variant binary in order to download all the required libraries and save them in a Docker layer cache
# COPY cli/build-cache /tmp
# WORKDIR /tmp/build-cache
# RUN variant2 export binary $PWD variant-echo

# # Build the CLI
# WORKDIR /usr/cli
# COPY cli/ .
# ARG CGO_ENABLED=1
# ARG CLI_NAME
# RUN variant2 export binary $PWD $CLI_NAME

# # Verify the CLI
# RUN ./"$CLI_NAME" help


FROM cloudposse/geodesic:$VERSION-$OS

# Geodesic message of the Day
ENV MOTD_URL="https://geodesic.sh/motd"

# Some configuration options for Geodesic
ENV AWS_SAML2AWS_ENABLED=false
ENV AWS_VAULT_ENABLED=false
ENV GEODESIC_TF_PROMPT_ACTIVE=false
ENV DIRENV_ENABLED=false

ENV DOCKER_IMAGE="cloudposse/atmos"
ENV DOCKER_TAG="latest"

# Geodesic banner
ENV BANNER="Atmos Tutorial"

# Install terraform.
RUN apk add -u terraform-0.14@cloudposse
# Set Terraform 0.14.x as the default `terraform`.
RUN update-alternatives --set terraform /usr/share/terraform/0.14/bin/terraform

# Install variant2
RUN apk add variant2@cloudposse
RUN update-alternatives --set variant /usr/share/variant/2/bin/variant

# Install Atmos
RUN apk add atmos@cloudposse

COPY components/ /components/
COPY stacks/ /stacks/

WORKDIR /
