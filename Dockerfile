ARG BUSYBOX_IMAGE_TAG=1.37.0-uclibc
ARG MIMIR_IMAGE_TAG=2.17.0
FROM busybox:$BUSYBOX_IMAGE_TAG AS busybox
FROM grafana/mimir:$MIMIR_IMAGE_TAG

LABEL org.opencontainers.image.title="mimir-healthcheck" \
      org.opencontainers.image.description="Grafana Mimir Docker image with healthcheck" \
      org.opencontainers.image.source="https://github.com/zguydev/mimir-healthcheck" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.authors="zguydev <zguy@zguy.dev>"

COPY --from=busybox /bin/wget /bin/wget

HEALTHCHECK --interval=3s --timeout=2s --retries=10 CMD [ "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9009/ready" ]
