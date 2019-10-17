# frozen_string_literal: true

Dir[File.join(__dir__, "matchers", "*.rb")].each { |f| require f }

# rubocop:disable Name/PredicateName
module Capybara
  module RSpecMatchers
    %i[alert combo_box modal tab_panel tab_button disclosure disclosure_button section item].each do |selector|
      define_method "have_#{selector}" do |locator = nil, **options, &optional_filter_block|
        Matchers::HaveSelector.new(selector, locator, options, &optional_filter_block)
      end

      define_method "have_no_#{selector}" do |*args, &optional_filter_block|
        Matchers::NegatedMatcher.new(send("have_#{selector}", *args, &optional_filter_block))
      end
    end

    def have_validation_errors
      Matchers::HaveValidationErrors.new
    end

    def have_no_validation_errors
      Matchers::HaveNoValidationErrors.new
    end
  end
end
# rubocop:enable Name/PredicateName
