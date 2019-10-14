# frozen_string_literal: true

module Capybara
  module RSpecMatchers
    module Matchers
      class HaveNoValidationErrors < HaveValidationErrors
        def matches?(element)
          @page = element
          @errors = []
          all_invalid_elements.each do |node|
            @errors << "expected #{node.native.attribute('outerHTML')} not to be invalid"
          end.empty?
        end

        def failure_message
          @errors.join("\n")
        end
      end
    end
  end
end
