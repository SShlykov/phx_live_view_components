FROM elixir:1.10.4-alpine

EXPOSE 4000
WORKDIR /app

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache nodejs npm git build-base inotify-tools && \
  rm -rf /var/cache/apk/*

RUN mix local.hex --force && \
    mix local.rebar --force 