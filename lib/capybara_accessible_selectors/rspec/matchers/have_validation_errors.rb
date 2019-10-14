# frozen_string_literal: true

module Capybara
  module RSpecMatchers
    module Matchers
      class HaveValidationErrors
        def matches?(element, &block)
          @page = element
          @elements = []
          instance_eval(&block)
          @errors = []

          all_invalid_elements.reject { |el| @elements.include? el }.each do |el|
            @errors << "expected #{el.native.attribute('outerHTML')} to have no error"
          end.empty?
        end

        def failure_message
          @errors.join("\n")
        end

        %i[field radio_button checkbox select file_field combo_box].each do |selector|
          define_method(selector) do |*args, **options|
            raise ArgumentError, "requires validation_error option" unless options[:validation_error]

            # Cannot assert and find the element in the same operation, and get a friendly error message
            @page.assert_selector(selector, *args, **options)
            @elements << @page.find(selector, *args, **options)
          end
        end

        def all_invalid_elements
          @page.find_all(:css, "input,select,textarea,[aria-invalid=true]", wait: false) do |node|
            next node.evaluate_script("this.willValidate && !this.validity.valid") if node.matches_css?("input,select,textarea")

            true
          end
        end
      end
    end
  end
end
