# frozen_string_literal: true

$LOAD_PATH << File.expand_path("lib", __dir__)
require "capybara_accessible_selectors/version"

Gem::Specification.new do |s|
  s.name = "capybara_accessible_selectors"
  s.summary = "Additional selectors for capybara"
  s.version = CapybaraAccessibleSelectors::VERSION
  s.files = Dir["lib/**/*.rb"]
  s.authors = ["Daniel Lewis", "Sean Doyle"]
  s.license = "ISC"
  s.required_ruby_version = ">= 3.2"

  s.add_dependency "capybara", "~> 3.36"

  s.metadata["rubygems_mfa_required"] = "true"
end
