# frozen_string_literal: true

require "capybara_accessible_selectors/version"
require "capybara"

module CapybaraAccessibleSelectors
end

require "capybara_accessible_selectors/helpers"
require "capybara_accessible_selectors/actions"
require "capybara_accessible_selectors/session"
require "capybara_accessible_selectors/filter_set"
require "capybara_accessible_selectors/selectors"
require "capybara_accessible_selectors/rspec/matchers"
require "capybara_accessible_selectors/locate_by_fieldset"
require "capybara_accessible_selectors/node/accessible_name"
