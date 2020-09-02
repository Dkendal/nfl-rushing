#!/bin/sh

docker-compose down
docker volume rm nfl-rushing_build nfl-rushing_deps nfl-rushing_node_modules nfl-rushing_pgdata nfl-rushing_static
