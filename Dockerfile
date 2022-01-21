ARG GO_VERSION=1.16.3
ARG ALPINE_VERSION=3.14
ARG IAMLIVE_VERSION=v0.43.0


# Base image
FROM alpine:${ALPINE_VERSION} AS base
RUN apk --update upgrade && \
    apk add --update ca-certificates && \
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
ENTRYPOINT [ "/app/iamlive" , "--output-file", "/app/iamlive.log", "--mode", "proxy", "--bind-addr", "0.0.0.0:10080"]
CMD [ "--force-wildcard-resource" ]


# Lambda custom runtime - https://docs.aws.amazon.com/lambda/latest/dg/go-image.html#go-image-other
FROM public.ecr.aws/lambda/provided:al2 as lambda
USER root
WORKDIR /app/
COPY --from=download "/downloads/iamlive" ./
EXPOSE 10080
ENTRYPOINT [ "/app/iamlive" , "--output-file", "/app/iamlive.log", "--mode", "proxy", "--bind-addr", "0.0.0.0:10080"]
CMD [ "--force-wildcard-resource" ]
