# frozen_string_literal: true

Capybara.add_selector(:section) do
  xpath do |locator, heading_level: (1..6), section_element: %i[section article aside footer header main form], **|
    # the nil function is to wrap the condition in brackets
    heading = XPath.function(nil, XPath.descendant(*Array(heading_level).map { |i| :"h#{i}" }))[1][XPath.string.n.is(locator.to_s)]
    XPath.descendant(*Array(section_element).map(&:to_sym))[heading]
  end

  filter_set(:capybara_accessible_selectors, %i[described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a section
    #
    # @param [String] locator The section heading
    # @param [Hash] options Finder options
    def within_section(...)
      within(:section, ...)
    end
  end
end
