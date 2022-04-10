#!/bin/bash
docker compose down
rm -rf ./datadir ./blockscout/postgres-data
docker compose pull