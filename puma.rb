# frozen_string_literal: true

port        ENV['PORT']     || 80
environment ENV['RACK_ENV'] || 'development'
