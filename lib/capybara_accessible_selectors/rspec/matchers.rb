# frozen_string_literal: true

Dir[File.join(__dir__, "matchers", "*.rb")].each { |f| require f }

# rubocop:disable Name/PredicateName
module Capybara
  module RSpecMatchers
    def have_combo_box(locator = nil, **options, &optional_filter_block)
      Matchers::HaveSelector.new(:combo_box, locator, options, &optional_filter_block)
    end

    def have_no_combo_box(*args, &optional_filter_block)
      Matchers::NegatedMatcher.new(have_combo_box(*args, &optional_filter_block))
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
