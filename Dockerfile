FROM  golang

RUN apt-get update && apt-get -y install unzip python-dev jq software-properties-common

ENV DOCKER_VERSION 1.13.0
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
    && tar zxf docker-${DOCKER_VERSION}.tgz -C /tmp \
    && rm docker-${DOCKER_VERSION}.tgz \
    && mv /tmp/docker/* /usr/local/bin
    
ENV COMPOSE_VERSION 1.17.0
RUN curl -sSL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

ENV TERRAFORM_VERSION 0.10.8
RUN curl -sSL -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin

ENV PACKER_VERSION 1.1.1
RUN curl -sSL -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
    && unzip packer_${PACKER_VERSION}_linux_amd64.zip \
    && rm packer_${PACKER_VERSION}_linux_amd64.zip \
    && mv packer /usr/local/bin

ENV TERRAFORM_SOFTLAYER v1.5.0
RUN curl -sSL https://github.com/softlayer/terraform-provider-softlayer/releases/download/${TERRAFORM_SOFTLAYER}/terraform-provider-softlayer_linux_amd64 > /usr/local/bin/terraform-provider-softlayer \
    && chmod +x /usr/local/bin/terraform-provider-softlayer
COPY .terraformrc /root/

ENV DEP_VERSION v0.3.2
RUN curl -sSL https://github.com/golang/dep/releases/download/${DEP_VERSION}/dep-linux-amd64 > /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep


RUN mkdir -p /go/src/github.com/watson-platform/packer-builder-softlayer && git clone https://github.com/watson-platform/packer-builder-softlayer.git /go/src/github.com/watson-platform/packer-builder-softlayer
RUN cd /go/src/github.com/watson-platform/packer-builder-softlayer && dep ensure && go build -o /usr/local/bin/packer-builder-softlayer main.go

