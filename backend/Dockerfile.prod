ARG ALPINE_VERSION=3.11
ARG ELIXIR_VERSION=1.10.4-alpine

FROM elixir:${ELIXIR_VERSION} as builder

ARG APP_VSN=0.1.0
ARG MIX_ENV=prod
ARG SKIP_PHOENIX=false
ARG APP_NAME=w_dcr
ARG PHOENIX_SUBDIR=.

WORKDIR /app

ENV SKIP_PHOENIX=${SKIP_PHOENIX} \
    APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} \
    MIX_ENV=${MIX_ENV}

RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache nodejs yarn git build-base && \
  rm -rf /var/cache/apk/* && \
  mix local.hex --force && \
  mix local.rebar --force 

COPY . .

# Тут можно задать комады в mix.exs, а затем вызвать одной командой несколько (если есть работа с базой или особая работа с сервером, то можно было бы запустить, но пока загружаем пакеты elixir и node).
RUN mix do deps.get --only prod, deps.compile, compile

RUN if [ ! "$SKIP_PHOENIX" = "true" ]; then \
  cd ${PHOENIX_SUBDIR}/assets && \
  yarn install && \
  yarn deploy && \
  cd - && \
  mix phx.digest; \
fi

# Создадим себе папку, в которую поместим скомпилированный проект и распакуем его, чтобы в дальнейшем просто перенести его на сервер
RUN mkdir -p /build  && \
    mix distillery.release --verbose && \
    cp _build/${MIX_ENV}/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /build && \
    cd /build && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz

FROM alpine:${ALPINE_VERSION}

# Чтобы можно было работать с ssl внутри экосистемы elixir
RUN apk update && \
    apk add --no-cache \
      bash \
      openssl-dev

WORKDIR /app

COPY --from=builder /build .
# TODO понять, как подсунуть переменную
CMD ["/app/bin/w_dcr", "foreground"]