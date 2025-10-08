# frozen_string_literal: true

ENV["APP_ENV"] = "test"

Warning[:deprecated] = true
Warning[:performance] = true if RUBY_VERSION >= "3.3.0"

require "debug"
require "capybara/rspec"
require "selenium-webdriver"
require "capybara_accessible_selectors"
require "sinatra"

# Suppress gecko driver warnings
# https://github.com/teamcapybara/capybara/issues/2779
Selenium::WebDriver.logger.ignore(:clear_local_storage, :clear_session_storage)

set :public_folder, "./spec/fixtures"

class Object
  # Provide a way to enter debug when the calling context is a C function
  # This is generally the case with selectors
  def _enter_debug(*args, **kwargs)
    binding.b # rubocop:disable Lint/Debugger
  end
end

module CapybaraAccessibleSelectors
  class TestApplication < Sinatra::Application
    get "/pages/new" do
      erb <<~HTML
        <!doctype html>
        <html>
          <head><meta charset="UTF-8" /><%= params[:head] %></head>
          <body><%= params[:body] %></body>
        </html>
      HTML
    end
  end
end

class String
  def squish
    strip.gsub(/[[:space:]]+/, " ")
  end
end

driver = ENV["DRIVER"]&.to_sym || :selenium_chrome_headless
Capybara.register_driver(:safari) { |app| Capybara::Selenium::Driver.new(app, browser: :safari) }
Capybara.register_driver(:firefox_aurora) do |app|
  options = Selenium::WebDriver::Firefox::Options.new(
    binary: "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox"
  )
  Capybara::Selenium::Driver.new(app, browser: :firefox, options:)
end
Capybara.register_driver(:firefox_aurora_headless) do |app|
  options = Selenium::WebDriver::Firefox::Options.new(
    binary: "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox",
    args: ["--headless"]
  )
  Capybara::Selenium::Driver.new(app, browser: :firefox, options:)
end
Capybara.register_driver(:edge) { |app| Capybara::Selenium::Driver.new(app, browser: :edge) }
Capybara.register_driver(:edge_headless) do |app|
  options = Selenium::WebDriver::Edge::Options.new(args: ["--headless"])
  Capybara::Selenium::Driver.new(app, browser: :edge, options:)
end
Capybara.register_driver(:chrome_canary) do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    binary: "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"
  )
  service = Selenium::WebDriver::Service.chrome(path: "/usr/local/bin/chromedriver-canary/chromedriver")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options:, service:)
end
Capybara.register_driver(:chrome_canary_headless) do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    binary: "/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary",
    args: ["--headless"]
  )
  service = Selenium::WebDriver::Service.chrome(path: "/usr/local/bin/chromedriver-canary/chromedriver")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options:, service:)
end
Capybara.default_driver = driver
Capybara.app = CapybaraAccessibleSelectors::TestApplication
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.max_formatted_output_length = 1000
  end

  config.define_derived_metadata do |metadata|
    metadata[:type] = :feature
  end

  config.before do |example|
    next if ENV["IGNORE_DRIVER_SKIPS"]

    skip_driver = Array(example.metadata[:skip_driver])
    next unless skip_driver.include?(:all) || skip_driver.include?(Capybara.current_driver.to_s.gsub(/_headless$/, "").to_sym)

    skip "not compatible with current driver"
  end

  config.include(Module.new do
    def render(html)
      visit("/pages/new?body=#{CGI.escape(html.strip)}")
    end

    def render_in_head(html)
      visit("/pages/new?head=#{CGI.escape(html.strip)}")
    end
  end)
end

Capybara::Node::Base.prepend(Module.new do
  def synchronize(seconds = nil, *, **)
    start_time = Time.now
    super
  rescue Capybara::ElementNotFound => e
    seconds ||= Capybara.default_max_wait_time
    unless seconds.zero? || Time.now - start_time <= seconds
      stack = caller.select { _1.start_with?(Dir.pwd) }.map { _1.slice(Dir.pwd.length..) }.drop(1)
      warn("selector has timed out #{stack}")
    end
    raise e
  end
end)
