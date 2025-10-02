# frozen_string_literal: true

module Capybara
  module RSpecMatchers
    module Matchers
      class HaveValidationErrors
        def matches?(element, &)
          @page = element
          @elements = []
          instance_eval(&)
          @errors = []

          all_invalid_elements.reject { |el| @elements.include? el }.each do |el|
            @errors << "expected #{el.native.attribute('outerHTML')} to have no error"
          end.empty?
        end

        def does_not_match?(element) # rubocop:disable Naming/PredicatePrefix
          @page = element
          @errors = []
          all_invalid_elements.each do |node|
            @errors << "expected #{node.native.attribute('outerHTML')} not to be invalid"
          end.empty?
        end

        def failure_message
          @errors.join("\n")
        end

        def all_invalid_elements
          @page.find_all(:css, "input,select,textarea,[aria-invalid=true]", wait: false) do |node|
            node[:"aria-invalid"] == "true" || node.evaluate_script("this.willValidate === true && !this.validity.valid")
          end
        end

        %i[checkbox datalist_input field file_field fillable_field radio_button select combo_box rich_text].each do |selector|
          define_method(selector) do |*args, **options|
            raise ArgumentError, "requires validation_error option" unless options[:validation_error]

            @page.assert_selector(selector, *args, **options)
            @elements << @page.find(selector, *args, **options)
          end
        end

        def radio_group(name, exact: nil, **options)
          @page.within(:fieldset, name, exact:) do
            @elements.push(*@page.all(:radio_button, **options))
          end
        end

        def within_fieldset(*args, **kwargs, &block)
          @page.within(:fieldset, *args, **kwargs) do
            instance_eval(&block)
          end
        end

        def within(*args, **kwargs, &block)
          @page.within(*args, **kwargs) do
            instance_eval(&block)
          end
        end
      end
    end
  end
end
