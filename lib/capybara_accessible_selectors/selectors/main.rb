# frozen_string_literal: true

Capybara.add_selector :main, locator_type: [String, Symbol] do
  xpath do |*|
    XPath.descendant_or_self[[
      XPath.local_name == "main",
      XPath.attr(:role) == "main"
    ].reduce(:|)]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
    end
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a main
    #
    # @param [String] Name Main label
    # @param [Hash] options Finder options
    def within_main(...)
      within(:main, ...)
    end
  end
end
