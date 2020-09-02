#!/bin/sh

docker-compose build
docker-compose run web mix do deps.get, deps.compile
docker-compose run web mix ecto.setup
docker-compose run web sh -c 'cd assets && npm i'
