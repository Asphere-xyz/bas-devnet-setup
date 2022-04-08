#!/bin/bash
docker compose down
rm -rf datadir
docker compose pull
docker compose up --build -d