# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # Methods to extend the DSL and page
  module Session; end

  ::Capybara::DSL.include Session
  ::Capybara::Session.include Session
end
