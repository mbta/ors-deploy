#!/usr/bin/env bash

export REBUILD_GRAPHS=true
export ORS_ENGINE_PREPARATION_MODE=true
export ORS_SERVICES_ROUTING_MODE=preparation

/entrypoint.sh &
entrypoint_pid=$!

# Wait for the server to stop or become healthy...
while kill -0 $entrypoint_pid >/dev/null && ! wget --quiet -O /dev/null http://localhost:8082/ors/v2/health; do
    sleep 5
done

echo Built graph, stopping server...
kill $entrypoint_pid || true

echo Checking that graphs were built...
test -d graphs/car || exit 1
test -d graphs/hgv || exit 1
