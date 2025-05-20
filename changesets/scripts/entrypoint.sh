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

  echo "Converting osm.pbf file to osm format"
  osmconvert files/data.osm.pbf > files/data.osm
fi

printf "Filtering OSM data for ways with %s\n" "$search_key=$search_value"
osmfilter files/data.osm --ignore-dependencies --keep= --keep-ways="hgv=no and $search_key=$search_value" > tmp/filtered.osm

printf "Modifying filtered OSM tags with %s\n" "$modify_string"
osmfilter tmp/filtered.osm --modify-tags="$modify_string" > tmp/modified.osm

printf "Updating version number of modified ways\n"
while IFS= read -r line; do
  if echo "$line" | grep -q "<way"; then
    version=$(echo "$line" | grep -o 'version="[0-9]*"' | grep -o '[0-9]*')
    if [ -n "$version" ]; then
      new_version=$((version + 1))
      line=$(echo "$line" | sed "s/version=\"$version\"/version=\"$new_version\"/")
    fi
  fi
  echo "$line"
done < tmp/modified.osm > tmp/version_updated.osm


timestamp=$(date +%s)
changeset_name="$timestamp"_changeset.osc

printf "Creating changeset file: %s\n" "$changeset_name"

osmconvert tmp/filtered.osm tmp/version_updated.osm --diff -o="$changeset_name"
