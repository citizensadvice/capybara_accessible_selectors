# frozen_string_literal: true

module Capybara
  module RSpecMatchers
    module Matchers
      class HaveValidationErrors
        include RSpec::Matchers

        def matches?(element, &block)
          @page = element
          @elements = []
          instance_eval(&block)
          @matcher = match_array(all_invalid_elements)
          @matcher.matches? @elements
        end

        def failure_message
          @matcher.failure_message
        end

        %i[field radio_button checkbox select file_field combo_box].each do |name|
          define_method(name) do |*args|
            @elements << @page.find(name, *args)
          end
        end

        def all_invalid_elements
          @page.find_all(:css, "input,select,textarea,[aria-invalid=true]") do |node|
            next node.evaluate_script("this.willValidate && !this.validity.valid") if node.matches_css?("input,select,textarea")

            true
          end
        end
      end
    end
  end
end
