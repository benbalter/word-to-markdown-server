# frozen_string_literal: true

source 'https://rubygems.org'

gem 'commonmarker'
gem 'rack-ecg'
gem 'rack-host-redirect'
gem 'secure_headers'
gem 'sinatra'
gem 'word-to-markdown', git: 'https://github.com/benbalter/word-to-markdown'
gem 'nokogiri', '>= 1.14'

group :development do
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'sitemap_generator'
end

group :production do
  gem 'puma'
end

group :test do
  gem 'rack-test'
  gem 'rspec'
end
