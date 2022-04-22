# frozen_string_literal: true

port        ENV.fetch('PORT', nil)     || 80
environment ENV.fetch('RACK_ENV', nil) || 'development'
