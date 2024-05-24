#!/usr/bin/env bash

export REBUILD_GRAPHS=true
export ors.engine.preparation_mode=true
export ors.services.routing.mode=preparation

/entrypoint.sh &
entrypoint_pid=$!

# Wait for the server to become healthy...
while ! wget --quiet -O /dev/null http://localhost:8082/ors/v2/health; do
    sleep 5
done

echo Built graph, stopping server...
kill $entrypoint_pid
