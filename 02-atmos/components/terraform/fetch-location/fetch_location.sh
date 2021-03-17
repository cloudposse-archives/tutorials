#!/bin/env bash

# Invoke the ipapi to get information about the client's IP address.
# Utilize `jq` to pull out the city + state into an object for external data source.
curl -s https://ipapi.co/json/ |
    jq '{ city: .city, region: .region_code, country: .country }'
