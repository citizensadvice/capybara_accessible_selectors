# frozen_string_literal: true

Capybara.add_selector :navigation, locator_type: [String, Regexp] do
  xpath do |*|
    XPath.descendant_or_self[[
      XPath.local_name == "nav",
      XPath.attr(:role) == "navigation"
    ].reduce(:|)]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    accessible_name = node.accessible_name
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
    # Limit supplied block to within a navigation
    #
    # @param [String] Name Navigation label
    # @param [Hash] options Finder options
    def within_navigation(...)
      within(:navigation, ...)
    end
  end
end
