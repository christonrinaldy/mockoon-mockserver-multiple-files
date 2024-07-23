#!/bin/sh

# combine mock json file into one file data.json
jq -s --slurpfile init app/mock-response-configurations.json 'reduce .[] as $item ($init[0]; .routes += $item.routes)' app/mock-responses/*.json > app/data/mock-response-compilation.json

# Do not run as root.
adduser --shell /bin/sh --disabled-password --gecos "" mockoon

# Change ownership of data.json
chown mockoon app/data/mock-response-compilation.json
su - mockoon

mockoon-cli start --disable-log-to-file --data app/data/mock-response-compilation.json --port 80
