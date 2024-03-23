#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bun install
bundle exec rails assets:precompile
bundle exec rails assets:clean
