#!/usr/bin/env bash

search_key=""
search_value=""
cached=false
modify_string="hgv=no to hgv=yes"

escape_spaces() {
  echo "${1// /\\ }"
}

USAGE_STRING="Correct usage: generate_changeset.sh -k \"<search key>\" -v \"<search value>\""
OPTSTRING="k:v:c"

if ! ARGS=$(getopt -o "$OPTSTRING" -- "$@"); then
  echo "Failed to parse args"
  echo "$USAGE_STRING"
  exit 1
fi

eval set -- "$ARGS"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -k)
      shift
      search_key=$(escape_spaces "$1")
      shift 
      ;;
    -v)
      shift
      search_value=$(escape_spaces "$1")
      shift
      ;;
    -c)
      shift
      cached=true
      shift
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1"
      echo "$USAGE_STRING"
      exit 1
      ;;
  esac
done

if [[ -z "$search_key" ]]; then
  echo "Search key not found. Please provide in the format of -k \"<search key>\"";
  exit 1
fi

if [[ -z "$search_value" ]]; then
  echo "Search value not found. Please provide in the format of -v \"<search value>\"";
  exit 1
fi

if [ "$cached" = true ]; then
  echo "Using existing files/data.osm file"
else
  echo "Downloading osm data"
  wget http://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf -O files/data.osm.pbf

  echo "Converting osm.pbf file to o5m format"
  osmconvert files/data.osm.pbf -o=files/data.o5m
fi

printf "Filtering OSM data for ways with %s\n" "$search_key=$search_value"
osmfilter files/data.o5m --ignore-dependencies --keep= --keep-ways="hgv=no and $search_key=$search_value" -o=tmp/filtered.o5m

printf "Modifying filtered OSM tags with %s\n" "$modify_string"
osmfilter tmp/filtered.o5m --modify-tags="$modify_string" --drop-version -o=tmp/modified.o5m

timestamp=$(date -Iseconds -u)
changeset_name="$timestamp"_changeset.osc

printf "Creating changeset file: %s\n" "$changeset_name"

osmconvert tmp/filtered.o5m tmp/modified.o5m --diff -o="$changeset_name"

rm -rf tmp/
