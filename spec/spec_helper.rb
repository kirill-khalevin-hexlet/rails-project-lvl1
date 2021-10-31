# frozen_string_literal: true

require 'bundler'

Bundler.require

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
