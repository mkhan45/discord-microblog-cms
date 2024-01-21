FROM hexpm/elixir:1.13.3-erlang-24.3.4-alpine-3.14.5

COPY . src
WORKDIR src

RUN mix local.rebar --force && \
    mix local.hex --force && \
    mix deps.get --only prod

RUN MIX_ENV=prod mix release

CMD ./_build/prod/rel/discord_microblog/bin/discord_microblog start
