ARG OPEN_ROUTE_SERVICE_VERSION=8.0.1

FROM openrouteservice/openrouteservice:v${OPEN_ROUTE_SERVICE_VERSION} AS builder

COPY preparation.sh /preparation.sh

RUN wget http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -O files/data.osm.pbf

COPY ors-config.yml config/ors-config.yml

RUN /preparation.sh

FROM openrouteservice/openrouteservice:v${OPEN_ROUTE_SERVICE_VERSION}

COPY --from=builder /home/ors/graphs graphs
COPY ors-config.yml config/ors-config.yml
