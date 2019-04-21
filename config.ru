# frozen_string_literal: true

Encoding.default_external = 'UTF-8'

require_relative './server'
run WordToMarkdownServer::App
