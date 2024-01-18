# frozen_string_literal: true

Capybara.add_selector :region, locator_type: [String, Symbol] do
  xpath do |*|
    XPath.descendant[[
      XPath.self(:section) & (XPath.attr(:"aria-label") | XPath.attr(:"aria-labelledby")),
      XPath.attr(:role) == "region"
    ].reduce(:|)]
  end

  locator_filter do |node, locator, exact:, **|
    next true if !locator && node.tag_name != "section"

    name = if node[:"aria-labelledby"]
             CapybaraAccessibleSelectors::Helpers.element_labelledby(node)
           else
             node[:"aria-label"]
           end
    if locator
      name&.public_send(exact ? :eql? : :include?, locator)
    else
      name && !name.strip.empty?
    end
  end

  filter_set(:capybara_accessible_selectors, %i[described_by])
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
