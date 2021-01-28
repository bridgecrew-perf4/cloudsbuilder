FROM golang:1.15-alpine3.12 as builder

# Versions Variables
# Vault
ENV VAULT_VERSION=1.6.0
# Terraform
ENV TERRAFORM_VERSION=0.13.5
ENV TF_DEV=true
ENV TF_RELEASE=true
# Ansible
ENV ANSIBLE_VERSION=2.10
# Packer
ENV PACKER_VERSION=1.6.5

RUN apk -U add ca-certificates git bash unzip wget openssl \
        py3-openssl openssh-client py3-pip python3 build-base \
        openssl-dev python3-dev

# Installing terraform
RUN mkdir -p $GOPATH/src/github.com/hashicorp && \
    cd $GOPATH/src/github.com/hashicorp && \
    git clone https://github.com/hashicorp/terraform.git && \
    cd terraform && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh && \
    cp bin/terraform /usr/bin/ 

# Installing vault
RUN wget -nv https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/bin

# Installing packer
RUN wget -nv https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/bin

FROM alpine:3

COPY --from=builder /usr/bin/ /usr/bin/

RUN apk -U add ca-certificates git bash unzip wget openssl \
        py3-openssl openssh-client py3-pip python3 && \
        mkdir -p ~/.terraform.d/plugins && \
        python3 -m pip install ansible && \
        python3 -m pip install hvac && \
        ansible --version && \
        terraform --version && \
        vault version && \
        packer version

ENTRYPOINT ["terraform"]
