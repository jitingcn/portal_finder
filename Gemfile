# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.1"

gem "bcrypt", "~> 3.1.7"
gem "jbuilder", "~> 2.7"
# gem 'jieba_rb'
gem "pg", ">= 0.18", "< 2.0"
# gem 'pghero'
gem "puma", github: "puma/puma"
gem "rails" # , github: "rails/rails"
gem "composite_primary_keys", github: "composite-primary-keys/composite_primary_keys"
gem "redis", "~> 4.0"
gem "sassc-rails", "~> 2.1"
gem "turbolinks", "~> 5"
gem "tzinfo-data", ">= 1.2019.1"
gem "webpacker", "~> 5.2.1"

gem "image_processing", "~> 1.2"

gem "bulk_insert"

gem "stimulus_reflex", "~> 3.2"

gem "dotenv-rails"
gem "sentry-raven"

gem "hamlit-rails"
gem "rails-i18n", "~> 6.0.0"

gem "phashion", github: "jitingcn/phashion"
gem "rmagick"  #, require: false

gem "active_storage_validations"

gem "devise"
gem "devise-encryptable"
gem "devise-i18n"

gem "cancancan"

gem "http_accept_language"

gem "rails-settings-cached", "~> 2.0"

gem "leaflet-rails"
gem "geocoder"

gem "kaminari"

gem "delayed_job_active_record"
gem "activerecord-session_store"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  gem "break"
  gem "byebug"
  gem "spring"
end

group :development do
  gem "seed_dump"
  gem "amazing_print"
  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "faker", require: false
  gem "guard", ">= 2.2.2", require: false
  gem "guard-bundler", require: false
  gem "guard-livereload", require: false
  gem "guard-minitest", require: false
  gem "listen", "~> 3.2"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"

  gem "brakeman", ">= 4.0", require: false
  gem "bundler-audit"
  gem "rubocop", ">= 0.72", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false

  gem "pry-byebug"
  gem "pry-rails"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

