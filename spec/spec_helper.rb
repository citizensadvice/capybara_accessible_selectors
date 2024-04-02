# frozen_string_literal: true

ENV["APP_ENV"] = "test"

Warning[:deprecated] = true
Warning[:performance] = true if RUBY_VERSION >= "3.3.0"

require "debug"
require "capybara/rspec"
require "selenium-webdriver"
require "capybara_accessible_selectors"
require "sinatra"

set :public_folder, "./spec/fixtures"

module CapybaraAccessibleSelectors
  class TestApplication < Sinatra::Application
    get "/pages/new" do
      erb <<~HTML
        <!doctype html>
        <html>
          <head><meta charset="UTF-8" /></head>
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
Capybara.default_driver = driver
Capybara.app = CapybaraAccessibleSelectors::TestApplication
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

  config.include(Module.new do
    def render(html)
      visit("/pages/new?body=#{CGI.escape(html.strip)}")
    end
  end)
end

module Capybara
  module Node
    module WarnOnTimeouts
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
    end

    class Base
      prepend WarnOnTimeouts
    end
  end
end
