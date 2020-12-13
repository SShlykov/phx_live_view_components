ARG ELIXIR_VERSION=1.11.2

FROM elixir:${ELIXIR_VERSION} as builder

ARG APP_VSN=0.1.0
ARG MIX_ENV=prod
ARG SKIP_PHOENIX=false
ARG APP_NAME=w_dcr
ARG PHOENIX_SUBDIR=.
ARG CORES=4
ARG TIMEOUT=240

WORKDIR /app

ENV SKIP_PHOENIX=${SKIP_PHOENIX} \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

RUN apt-get update -y && apt-get upgrade -y && \
  apt install nodejs npm curl wget git build-essential -y && \
  mix local.hex --force && \
  mix local.rebar --force

COPY . .

RUN HEX_HTTP_CONCURRENCY=${CORES} HEX_HTTP_TIMEOUT=${HEX_HTTP_TIMEOUT} mix do deps.get, deps.compile, compile

RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then \
  npm install --prefix assets && \
  mix phx.digest; \
fi