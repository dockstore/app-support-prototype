#!/bin/bash
export parameters_httpPort=${parameters_httpPort:-7222}
export parameters_httpsPort=${parameters_httpsPort:-7223}
docker-compose up -d
# Wait for server to respond before exiting
timeout 300 bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:${parameters_httpPort}/ping/)" != "200" ]]; do sleep 5; done' || false
