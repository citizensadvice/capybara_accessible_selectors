# frozen_string_literal: true

Capybara.add_selector :region, locator_type: [String, Regexp] do
  xpath do |*|
    XPath.descendant[[
      XPath.self(:section) & (XPath.attr(:"aria-label") | XPath.attr(:"aria-labelledby")),
      XPath.attr(:role) == "region"
    ].reduce(:|)]
  end

  locator_filter do |node, locator, exact:, **|
    accessible_name = node.accessible_name
    next false if node.tag_name == "section" && accessible_name == ""
    next true if locator.nil?

    case locator
    when String
      exact ? accessible_name == locator : accessible_name.include?(locator.to_s)
    when Regexp
      locator.match?(accessible_name)
    end
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a region
    #
    # @param [String] Name Region label
    # @param [Hash] options Finder options
    def within_region(...)
      within(:region, ...)
    end
  end
end
