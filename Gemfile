# frozen_string_literal: true

source "https://rubygems.org"

group :test, :development do
  gem "citizens-advice-style", git: "https://github.com/citizensadvice/citizens-advice-style-ruby", tag: "v11.0.0"
  gem "debug"
  gem "puma"
  gem "rack-test"
  gem "rackup"
  gem "rspec"
  gem "selenium-webdriver"
  gem "sinatra"

  # This gets pulled in by the style guide.  As we still support Ruby 3.1 we can't go to 8
  gem "activesupport", "~> 7.2", require: false
end

gemspec
