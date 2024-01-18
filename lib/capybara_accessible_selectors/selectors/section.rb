# frozen_string_literal: true

Capybara.add_selector(:section) do
  xpath do |locator, heading_level: (1..6), section_element: %i[section article aside form main header footer], **|
    # Simplified xpath
    # //section[(.//*[self::h2 | self::section])[1][self::h2][contains(normalize-space(string(.)), 'Name')]]
    heading = [
      (XPath.attr(:role) == "heading") & Array(heading_level).map { XPath.attr(:"aria-level") == _1.to_s }.reduce(:|),
      ((XPath.attr(:role) == "heading") & !XPath.attr(:"aria-level") if Array(heading_level).include?(2)),
      Array(heading_level).map { XPath.self(:"h#{_1}") & !XPath.attr(:"aria-level") }.reduce(:|),
      Array(heading_level).map { XPath.attr(:"aria-level") == _1.to_s }.reduce(:|) & %i[h1 h2 h3 h4 h5 h6].map { XPath.self(_1) }.reduce(:|)
    ].compact.reduce(:|)
    has_heading = XPath.function(
      nil,
      XPath.descendant[[
        *[:section, :article, :aside, :form, :main, :header, :footer, *(1..6).map { :"h#{_1}" }].map { XPath.self(_1) },
        XPath.attr(:role) == "heading"
      ].reduce(:|)]
    )[1][heading]
    has_heading = has_heading[XPath.string.n.is(locator.to_s)] if locator
    XPath.descendant(*Array(section_element).map(&:to_sym))[has_heading]
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
