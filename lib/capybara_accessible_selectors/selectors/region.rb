# frozen_string_literal: true

Capybara.add_selector :region, locator_type: [String, Symbol] do
  xpath do |*|
    XPath.descendant[[
      XPath.local_name == "section",
      XPath.attr(:role) == "region"
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
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a region
    #
    # @param [String] Name Region label
    # @param [Hash] options Finder options
    def within_region(*arguments, **options, &block)
      within(:region, *arguments, **options, &block)
    end
  end
end
