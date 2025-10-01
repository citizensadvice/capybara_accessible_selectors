# frozen_string_literal: true

Capybara.add_selector :banner, locator_type: [String, Symbol] do
  xpath do |*|
    implicit = XPath.self(:header)[!XPath.ancestor[[
      *%i[article aside main nav section].map { XPath.self(_1) },
      *%w[article complimentary main navigation region].map { XPath.attr(:role) == _1 }
    ].inject(:|)]]
    explicit = XPath.attr(:role) == "banner"
    XPath.descendant_or_self[implicit | explicit]
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
    # Limit supplied block to within a banner
    #
    # @param [String] Name Banner label
    # @param [Hash] options Finder options
    def within_banner(...)
      within(:banner, ...)
    end
  end
end
