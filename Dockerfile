ARG ALPINE_VERSION=3.18
ARG IAMLIVE_VERSION=v0.53.0
ARG FORMAT_LOGS='true'
ARG ALLOWED_ADDRESS='0.0.0.0'
ARG OUTPUT_PATH='/app/iamlive.log'

# Environment
FROM alpine:${ALPINE_VERSION} AS base
RUN apk --update upgrade && \
    apk add --update ca-certificates bash jq=~1.6 && \
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
ARG FORMAT_LOGS
ARG ALLOWED_ADDRESS
ARG OUTPUT_PATH
ENV FORMAT_LOGS=$FORMAT_LOGS
ENV ALLOWED_ADDRESS=$ALLOWED_ADDRESS
ENV OUTPUT_PATH=$OUTPUT_PATH
WORKDIR /app/
COPY --from=download "/downloads/iamlive" ./
RUN addgroup -S "appgroup" && adduser -S "appuser" -G "appgroup" && \
    chown -R "appuser:appgroup" .
USER "appuser"
EXPOSE 10080
COPY entrypoint.sh ./
ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "--force-wildcard-resource" ]
