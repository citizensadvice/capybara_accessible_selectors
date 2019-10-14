# frozen_string_literal: true

module Capybara
  module Selector
    private

    alias old_locate_field locate_field

    def locate_field(xpath, locator, **options) # rubocop:disable Metrics/AbcSize
      return old_locate_field(xpath, locator, **options) unless locate_on_fields(options)
      return xpath if locator.nil?

      *fieldsets, locator = Array(locator)

      locate_xpath = xpath # Need to save original xpath for the label wrap
      locator = locator.to_s
      attr_matchers = [XPath.attr(:id) == XPath.anywhere(:label)[XPath.string.n.is(locator)].attr(:for)]
      attr_matchers |= XPath.attr(:'aria-label').is(locator) if enable_aria_label

      locate_xpath = locate_xpath[attr_matchers]
      xpath = locate_xpath + XPath.descendant(:label)[XPath.string.n.is(locator)].descendant(xpath)
      fieldsets.each do |fieldset|
        xpath = CapybaraAccessibleSelectors::Helpers.within_fieldset(xpath, fieldset)
      end
      xpath
    end

    def locate_on_fields(options)
      (CapybaraAccessibleSelectors.locate_fields_on_labels && options[:locate_on_labels] != false) ||
        (!CapybaraAccessibleSelectors.locate_fields_on_labels && options[:locate_on_labels])
    end
  end
end

%i[field file_field checkbox radio_button fillable_field select].each do |selector|
  Capybara.modify_selector(selector) do
    @locator_type |= [Array]
  end
end
