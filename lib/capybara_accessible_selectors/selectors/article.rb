# frozen_string_literal: true

Capybara.add_selector :article, locator_type: [String, Regexp] do
  xpath do |*|
    XPath.descendant[[
      XPath.attr(:role) == "article",
      XPath.self(:article)
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
    # Limit supplied block to within a article
    #
    # @param [String] Name Article label
    # @param [Hash] options Finder options
    def within_article(...)
      within(:article, ...)
    end
  end
end
