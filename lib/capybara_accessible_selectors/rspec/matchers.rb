# frozen_string_literal: true

require "capybara_accessible_selectors/rspec/matchers/have_validation_errors"
require "capybara_accessible_selectors/rspec/matchers/have_no_validation_errors"

# rubocop:disable Naming/PredicatePrefix
module Capybara
  module RSpecMatchers
    %i[alert article banner columnheader combo_box contentinfo dialog grid gridcell heading img image main
       menu menuitem modal navigation region role row tab_panel tab_button disclosure
       disclosure_button section item].each do |selector|
      define_method :"have_#{selector}" do |locator = nil, **options, &optional_filter_block|
        Matchers::HaveSelector.new(selector, locator, **options, &optional_filter_block)
      end

      define_method :"have_no_#{selector}" do |*args, **options, &optional_filter_block|
        Matchers::NegatedMatcher.new(send(:"have_#{selector}", *args, **options, &optional_filter_block))
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
# rubocop:enable Naming/PredicatePrefix
