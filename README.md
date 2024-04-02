# ORS Deploy

This repo contains config files for the MBTA's OpenRouteService
instance, and will eventually also contain deploy scripts and CI/CD.

## Run Locally

Clone this repo, and ensure that you have docker running. Build an
image containing the latest [OpenSteetMaps data from
Geofabrik](http://download.geofabrik.de/north-america/us-northeast-latest.osm.pbf)
by running

    docker build . -t ors --no-cache

(This will take a while, because one of its steps involves downloading
a fairly large file from Geofabrik)

(`--no-cache` is required to get the latest OpenStreetMap data)

Run that container so that it's ready to serve traffic with

    docker run --name ors -p 8082:8082 --rm ors

It will typically take a while to start. Check its status with

    curl http://localhost:8082/ors/v2/health
