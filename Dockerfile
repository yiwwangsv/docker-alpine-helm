FROM alpine:latest as builder

ARG HELM_VERSION=3.0.0
ARG KUBECTL_VERSION=1.14.9
ARG AWS_IAM_AUTH_VERSION=0.4.0

ENV HELM_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
ENV KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ENV AWS_IAM_AUTH_URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTH_VERSION}/aws-iam-authenticator_0.4.0_linux_amd64"
RUN apk add --update --no-cache ca-certificates && \
    wget -qO- ${HELM_URL} |tar xvz && \
    wget ${KUBECTL_URL} && \
    wget ${AWS_IAM_AUTH_URL} && \
    chmod +x linux-amd64/helm && \
    chmod +x kubectl && \
    chmod +x aws-iam-authenticator_0.4.0_linux_amd64


FROM alpine:latest
COPY --from=builder linux-amd64/helm /usr/bin/helm
COPY --from=builder kubectl /usr/bin/kubectl
COPY --from=builder aws-iam-authenticator_0.4.0_linux_amd64 /usr/bin/aws-iam-authenticator

WORKDIR /local
