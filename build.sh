#!/bin/bash
export COMMIT_ID=$(git show -s --format=%H)
docker-compose -f docker-compose.yml -f whdemo/docker-compose.yml build
