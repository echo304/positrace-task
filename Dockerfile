ARG RUBY_VERSION=3.1.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs git

WORKDIR /docker/app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /docker/app
