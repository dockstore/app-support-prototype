#!/bin/bash
docker-compose -e HTTP_PORT=$(parameters_httpPort) -e HTTPS_PORT=$(parameters_httpsPort) up -d
# Wait for server to respond before exiting
timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:$(parameters.httpPort)/ping/)" != "200" ]]; do sleep 5; done' || false
