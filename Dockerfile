FROM ghcr.io/helmfile/helmfile:v0.161.0 as base
ENV PLATFORM=amd64
ENV SAML2AWS_VERSION=2.36.13
RUN wget -c "https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_${PLATFORM}.tar.gz" -O - | tar -xzv -C /usr/local/bin

FROM amazon/aws-cli:2.15.15
COPY --from=base /usr/local/bin/helm /usr/local/bin/helm
COPY --from=base /usr/local/bin/helmfile /usr/local/bin/helmfile
COPY --from=base /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=base /usr/local/bin/kustomize /usr/local/bin/kustomize
COPY --from=base /usr/local/bin/saml2aws /usr/local/bin/saml2aws
COPY --from=base /usr/local/bin/sops /usr/local/bin/sops
RUN mkdir -p .local/share/helm/plugins
COPY --from=base /helm/.local/share/helm/plugins /root/.local/share/helm/plugins
 