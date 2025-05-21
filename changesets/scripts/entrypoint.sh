#!/usr/bin/env bash

search_key=$1
search_value=$2
cached=$3
modify_string="hgv=no to hgv=yes"

if [ "$cached" = "true" ]; then
  echo "Using existing files/data.osm file"
else
  echo "Downloading osm data"
  wget http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -O files/data.osm.pbf

  echo "Converting osm.pbf file to o5m format"
  osmconvert files/data.osm.pbf > files/data.o5m
fi

printf "Filtering OSM data for ways with %s\n" "$search_key=$search_value"
osmfilter files/data.o5m --ignore-dependencies --keep= --keep-ways="hgv=no and $search_key=$search_value" > tmp/filtered.o5m

printf "Modifying filtered OSM tags with %s\n" "$modify_string"
osmfilter tmp/filtered.o5m --modify-tags="$modify_string" --drop-version > tmp/modified.o5m

timestamp=$(date -Iseconds -u)
changeset_name="$timestamp"_changeset.osc

printf "Creating changeset file: %s\n" "$changeset_name"

osmconvert tmp/filtered.o5m tmp/modified.o5m --diff -o="$changeset_name"

rm -rf tmp/
