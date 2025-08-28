ARG GOLANG_VERSION=1.25
ARG MIMIR_IMAGE_TAG=2.17.0

FROM golang:$GOLANG_VERSION AS build

WORKDIR /app
ENV GOPATH=/app/.go

COPY go.mod ./
RUN go mod download

COPY cmd ./cmd

RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -trimpath -ldflags='-s -w' -o /app/healthcheck ./cmd/healthcheck/

FROM grafana/mimir:$MIMIR_IMAGE_TAG

COPY --from=build --chown=nonroot:nonroot /app/healthcheck /healthcheck

HEALTHCHECK --interval=3s --timeout=2s --retries=10 CMD [ "/healthcheck", "--port", "9009" ]

LABEL org.opencontainers.image.title="mimir-healthcheck" \
      org.opencontainers.image.description="Grafana Mimir Docker image with healthcheck" \
      org.opencontainers.image.source="https://github.com/zguydev/mimir-healthcheck" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.authors="zguydev <zguy@zguy.dev>"
