FROM elixir:1.10.4-alpine as dev

ENV MIX_HOME /.mix

RUN apk add --update --no-cache inotify-tools nodejs nodejs-npm \
          && mix local.hex --force \
          && mix local.rebar --force

WORKDIR /app

CMD ["mix", "phx.server"]
