ARG AL2_VERSION

FROM amd64/amazonlinux:${AL2_VERSION}

ARG AWS_CLI_VERSION
ARG AWS_VAULT_VERSION

RUN yum update -y && \
    yum install -y unzip less && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install AWS CLI v2
# Verify the signature of the zip
COPY assets/aws-public.key /
RUN gpg --import aws-public.key && \
    curl -sLO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip.sig && \
    curl -sLO https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip && \
    gpg --verify awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip.sig awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip && \
    unzip awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip && \
    aws/install && \
    rm -rf \
      aws-public.key \
      awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip* \
      aws \
      /usr/local/aws-cli/v2/*/dist/aws_completer \
      /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
      /usr/local/aws-cli/v2/*/dist/awscli/examples

# Install aws-vault
# Only MacOS client is code-signed
RUN curl -sLO https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/aws-vault-linux-amd64 && \
    curl -sLO https://github.com/99designs/aws-vault/releases/download/${AWS_VAULT_VERSION}/SHA256SUMS && \
    echo "$(cat SHA256SUMS | grep aws-vault-linux-amd64)" | sha256sum -c && \
    mv aws-vault-linux-amd64 /usr/local/bin/aws-vault && \
    chmod 700 /usr/local/bin/aws-vault && \
    rm SHA256SUMS

ENTRYPOINT ["aws"]