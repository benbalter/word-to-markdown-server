# frozen_string_literal: true

require 'rack/test'
require 'rspec'

RSpec.configure do |config|
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random
  config.default_formatter = 'doc' if config.files_to_run.one?
  Kernel.srand config.seed
end

ENV['RACK_ENV'] = 'test'

require File.expand_path '../server.rb', __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

RSpec.configure { |c| c.include RSpecMixin }
