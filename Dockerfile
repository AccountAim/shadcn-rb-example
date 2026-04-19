# syntax=docker/dockerfile:1.7

FROM ruby:4.0.7-alpine AS builder

ARG RAILS_ENV=production
ARG BUNDLE_WITHOUT='development test'

ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=5 \
    BUNDLE_NO_CACHE=1 \
    BUNDLE_SILENCE_ROOT_WARNING=1

RUN apk add --no-cache build-base git yaml-dev

WORKDIR /rails

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    find /usr/local/bundle -name "*.o" -delete && \
    find /usr/local/bundle -name "*.c" -delete && \
    find /usr/local/bundle -type d -name .git -prune -exec rm -rf {} + && \
    rm -rf /usr/local/bundle/cache

FROM ruby:4.0.7-alpine AS base

ARG RAILS_ENV=production
ARG BUNDLE_WITHOUT='development test'

ENV RUBY_YJIT_ENABLE=1 \
    RAILS_ENV=${RAILS_ENV} \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT}

RUN apk add --no-cache curl tzdata libstdc++

RUN adduser -D -s /bin/sh rails && \
    mkdir -p /rails /usr/local/bundle && \
    chown -R rails:rails /rails /usr/local/bundle

COPY --from=builder --chown=rails:rails /usr/local/bundle /usr/local/bundle

WORKDIR /rails
USER rails:rails

FROM base AS development

USER root
# Bundler shells out to git against the bind-mounted local-override repo;
# `just gem-upgrade` compiles gems without musl binaries in this image.
RUN apk add --no-cache build-base git yaml-dev && \
    git config --system --add safe.directory '*'
USER rails:rails

# `just build` does `docker cp` to sync the host's Gemfile.lock with what
# the image actually resolved; that cp needs the file at this path.
COPY --chown=rails:rails Gemfile.lock ./Gemfile.lock

EXPOSE 3000
ENV BINDING=0.0.0.0
CMD ["foreman", "start", "-f", "Procfile.dev", "-p", "3000"]

FROM base AS production

COPY --chown=rails:rails . ./
ENV SECRET_KEY_BASE=1
RUN bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
