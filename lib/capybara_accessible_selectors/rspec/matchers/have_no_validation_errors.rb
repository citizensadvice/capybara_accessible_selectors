# frozen_string_literal: true

module Capybara
  module RSpecMatchers
    module Matchers
      class HaveNoValidationErrors < HaveValidationErrors
        def matches?(element)
          does_not_match?(element)
        end
      end
    end
  end
end
