# frozen_string_literal: true

Capybara.add_selector(:modal, locator_type: [String, Regexp]) do
  xpath do |*|
    XPath.descendant[
      [
        XPath.self(:dialog)[XPath.attr(:open)],
        [
          XPath.attr(:"aria-modal") == "true",
          (XPath.attr(:role) == "dialog") | (XPath.attr(:role) == "alertdialog")
        ].reduce(:&)
      ].reduce(&:|)
    ]
  end

  locator_filter do |node, locator, exact:, **|
    # The only way to determine an open dialog is modal is via a CSS selector
    next false if node.tag_name == "dialog" && node.not_matches_css?(":modal", wait: 0)
    next true if locator.nil?

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
    # Limit supplied block to within a modal
    #
    # @param [String] Name Modal label
    # @param [Hash] options Finder options
    def within_modal(...)
      within(:modal, ...)
    end
  end
end
