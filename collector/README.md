The `docker-compose.yml` file runs/configures a container from an existing image.
Create a service called `snowplow-collector` using Snowplow's pre-built Collector image, version `3.7.0`. Pinning the version is much safer than something like `:latest`

Use `docker ps` to verify if `snowplow-collector` is running.
Use `docker logs snowplow-collector` to inspect logs.
