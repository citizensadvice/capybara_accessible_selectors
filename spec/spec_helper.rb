# frozen_string_literal: true

ENV["APP_ENV"] = "test"

require "debug"
require "capybara/rspec"
require "selenium-webdriver"
require "capybara_accessible_selectors"
require "sinatra"

set :public_folder, "./spec/fixtures"

class String
  def squish
    strip.gsub(/[[:space:]]+/, " ")
  end
end

driver = ENV["DRIVER"]&.to_sym || :selenium_chrome_headless

Capybara.register_driver(:safari) { |app| Capybara::Selenium::Driver.new(app, browser: :safari) }
Capybara.register_driver(:firefox_developer_edition) do |app|
  options = Selenium::WebDriver::Firefox::Options.new(
    binary: "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox-bin"
  )
  options.headless!
  Capybara::Selenium::Driver.new(app, browser: :firefox, capabilities: options)
end
Capybara.default_driver = driver
Capybara.app = Sinatra::Application
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # Disallow should syntax
    expectations.syntax = :expect
    expectations.max_formatted_output_length = 1000
  end

  config.define_derived_metadata do |metadata|
    metadata[:type] = :feature
  end
end
