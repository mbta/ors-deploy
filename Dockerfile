ARG OPEN_ROUTE_SERVICE_VERSION=8.2.0

FROM --platform=$BUILDPLATFORM openrouteservice/openrouteservice:v${OPEN_ROUTE_SERVICE_VERSION} AS builder

RUN <<EOT
apk add osmctools --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
wget http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -O files/data.osm.pbf
EOT

COPY preparation.sh /preparation.sh
COPY ors-config.yml config/ors-config.yml
COPY parameter-file /parameter-file
RUN /preparation.sh

FROM openrouteservice/openrouteservice:v${OPEN_ROUTE_SERVICE_VERSION}

RUN apk upgrade --no-cache -f --purge

COPY --from=builder /home/ors/graphs graphs
COPY ors-config.yml config/ors-config.yml
