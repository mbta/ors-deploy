FROM openrouteservice/openrouteservice:v8.0.0

RUN wget http://download.geofabrik.de/north-america/us-northeast-latest.osm.pbf -O files/data.osm.pbf

COPY ors-config.yml config/ors-config.yml
