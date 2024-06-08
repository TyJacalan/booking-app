#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exex rails db:reset
bundle exec rails db:migrate
bin/rails runner db/script/create_users_and_appointments.rb
