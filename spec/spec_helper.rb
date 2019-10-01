# frozen_string_literal: true

ENV["APP_ENV"] = "test"

require "byebug"
require "capybara/rspec"
require "capybara/apparition"
require "capybara_accessible_selectors"
require "sinatra"

set :public_folder, "./spec/fixtures"

Capybara.default_driver = :apparition
Capybara.app = Sinatra::Application
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Disallow should syntax
    expectations.syntax = :expect
  end

  config.define_derived_metadata do |metadata|
    metadata[:type] = :feature
  end
end
