# mimir-healthcheck
> Grafana Mimir Docker image with healthcheck

[![build and push to GHCR](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-ghcr.yml/badge.svg)](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-ghcr.yml)
[![mirror to Docker Hub](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-docker.yml/badge.svg)](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-docker.yml)

## What is this?
This repo provides a thin Docker image on top of `grafana/mimir` that adds the so desired Docker healthcheck. As the Grafana Mimir team decided to target Kubernetes-only deployments (see [issue #9034](https://github.com/grafana/mimir/issues/9034#issuecomment-2304042358)) this image exists for Docker/Podman users.

## Healthcheck
- Endpoint: `http://localhost:9009/ready`
- Interval: `3s`
- Timeout: `2s`
- Retries: `10`

Mimir is expected to listen on port `9009` inside the container (its preferred port). If you change the internal port, override the healthcheck in Docker Compose or `docker run --health-cmd`.

## Quick start
Pull the image (change the tag if needed):
```bash
docker pull zguydev/mimir-healthcheck:latest
```
Run it (example):

```bash
docker run --rm \
  -p 9009:9009 \
  -v ./config.yaml:/etc/mimir/config.yaml:ro \
  zguydev/mimir-healthcheck:latest \
  -config.file=/etc/mimir/config.yaml
```

## Docker Compose example
```yaml
services:
  mimir:
    image: zguydev/mimir-healthcheck:latest
    command: ["-config.file=/etc/mimir/config.yaml"]
    volumes:
      - ./config.yaml:/etc/mimir/config.yaml
    ports:
      - "9009:9009"
    # Override healthcheck if you changed the internal port
    # healthcheck:
    #   test: ["CMD", "/healthcheck", "--port", "9009"]
    restart: unless-stopped
```

## Build with specific base image version
Use this method if you want to use base image versions that aren't provided by the `zguydev/mimir-healthcheck` tags.
Default tags are defined in the [Dockerfile](./Dockerfile).

```bash
git clone https://github.com/zguydev/mimir-healthcheck
cd mimir-healthcheck
docker build \
  --build-arg MIMIR_IMAGE_TAG=2.17.0 \
  -t mimir-healthcheck:2.17.0 .
```

## Version tags
`zguydev/mimir-healthcheck` mirrors upstream Mimir semver tags like `2.17.0` and prereleases like `2.17.0-rc.0`. Only stable releases receive the `latest` tag; prereleases do not.

Images are published to [Docker Hub](https://hub.docker.com/r/zguydev/mimir-healthcheck) and [GitHub Container Registry](https://ghcr.io/zguydev/mimir-healthcheck).

## Note
This image builds a custom healthcheck binary and puts it inside container; it does not change how you configure or run Mimir.

## License
MIT - see [LICENSE](./LICENSE)
