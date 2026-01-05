# mimir-healthcheck
> Grafana Mimir image with healthcheck

[![build and push to GHCR](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-ghcr.yml/badge.svg)](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-ghcr.yml)
[![mirror to Docker Hub](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-docker.yml/badge.svg)](https://github.com/zguydev/mimir-healthcheck/actions/workflows/push-image-to-docker.yml)

## What is this?
This repo provides a thin Docker image on top of `grafana/mimir` that adds the so desired Docker healthcheck. As the Grafana Mimir team decided to target Kubernetes-only deployments (see [issue grafana/mimir#9034](https://github.com/grafana/mimir/issues/9034#issuecomment-2304042358)) this image exists for Docker/Podman users.

## Default healthcheck
- Port: `9009`
- Interval: `3s`
- Timeout: `2s`
- Retries: `10`

Mimir is expected to listen on port `9009` inside the container (its preferred port). If you change the internal port, you must override the healthcheck command. Use `--health-cmd` flag if using Docker CLI, `healthcheck` directive if using Docker Compose.

## Quick start
Pull the image:
```bash
docker pull zguydev/mimir-healthcheck:latest
```
Run:

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
    healthcheck:
      test: ["CMD", "/healthcheck", "--port", "9009"] # Override the port argument if you changed it in Mimir config
    restart: unless-stopped
```

## Build with specific base image version
Use this method if you want to use base image versions that aren't provided by the `zguydev/mimir-healthcheck` tags (versions prior `2.15.0` need to be built manually).

```bash
git clone https://github.com/zguydev/mimir-healthcheck
cd mimir-healthcheck
TAG='2.17.0' # Tag to use
docker build \
  --build-arg MIMIR_IMAGE_TAG=$TAG \
  -t mimir-healthcheck:$TAG .
```

## Version tags
`zguydev/mimir-healthcheck` mirrors upstream Mimir semver tags: stable releases (like `2.17.0`) and prereleases (like `2.17.0-rc.0`). Only stable releases of the latest version receive the `latest` tag.

Images are published to [GitHub Container Registry](https://ghcr.io/zguydev/mimir-healthcheck) and mirrored to [Docker Hub](https://hub.docker.com/r/zguydev/mimir-healthcheck).

## Note
This image builds a custom healthcheck binary and puts it inside container; it does not change how you configure or run Mimir.

## License
MIT - see [LICENSE](./LICENSE)
