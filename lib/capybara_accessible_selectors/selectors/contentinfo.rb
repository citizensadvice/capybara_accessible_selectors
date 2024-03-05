# frozen_string_literal: true

Capybara.add_selector :contentinfo, locator_type: [String, Symbol] do
  xpath do |*|
    contentinfo = XPath.descendant[[
      XPath.local_name == "footer",
      XPath.attr(:role) == "contentinfo"
    ].reduce(:|)]

    contentinfo[XPath.parent(:body)]
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
    # Limit supplied block to within a contentinfo
    #
    # @param [String] Name Contentinfo label
    # @param [Hash] options Finder options
    def within_contentinfo(...)
      within(:contentinfo, ...)
    end
  end
end
