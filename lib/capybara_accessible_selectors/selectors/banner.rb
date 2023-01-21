# frozen_string_literal: true

Capybara.add_selector :banner, locator_type: [String, Symbol] do
  xpath do |*|
    banner = XPath.descendant[[
      XPath.local_name == "header",
      XPath.attr(:role) == "banner"
    ].reduce(:|)]

    banner[XPath.parent(:body)]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
    end
  end

  filter_set(:capybara_accessible_selectors, %i[described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a banner
    #
    # @param [String] Name Banner label
    # @param [Hash] options Finder options
    def within_banner(*arguments, **options, &block)
      within(:banner, *arguments, **options, &block)
    end
  end
end
