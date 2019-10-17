# frozen_string_literal: true

module Capybara
  class Selector
    private

    alias old_locate_field locate_field

    def locate_field(xpath, locator, **options)
      return xpath if locator.nil?

      *fieldsets, locator = Array(locator)
      xpath = old_locate_field(xpath, locator, options)
      xpath = CapybaraAccessibleSelectors::Helpers.within_fieldset(xpath, fieldsets) if fieldsets.any?
      xpath
    end
  end
end

%i[field file_field checkbox radio_button fillable_field select].each do |selector|
  Capybara.modify_selector(selector) do
    @locator_type |= [Array]
  end
end
