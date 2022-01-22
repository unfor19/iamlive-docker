ARG GO_VERSION=1.16.3
ARG ALPINE_VERSION=3.14
ARG IAMLIVE_VERSION=v0.44.0


# Base image
FROM alpine:${ALPINE_VERSION} AS base
RUN apk --update upgrade && \
    apk add --update ca-certificates bash && \
    update-ca-certificates


# Download iamlive binary from GitHub
FROM base as download
ARG IAMLIVE_VERSION
WORKDIR /downloads/
RUN \
    wget -O iamlive.tar.gz "https://github.com/iann0036/iamlive/releases/download/${IAMLIVE_VERSION}/iamlive-${IAMLIVE_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf iamlive.tar.gz


# App
FROM base AS app
WORKDIR /app/
COPY --from=download "/downloads/iamlive" ./
RUN addgroup -S "appgroup" && adduser -S "appuser" -G "appgroup" && \
    chown -R "appuser:appgroup" .
USER "appuser"
EXPOSE 10080
COPY entrypoint.sh ./
ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "--force-wildcard-resource" ]
