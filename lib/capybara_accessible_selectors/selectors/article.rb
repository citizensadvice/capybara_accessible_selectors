# frozen_string_literal: true

Capybara.add_selector :article, locator_type: [String, Symbol] do
  xpath do |*|
    XPath.descendant[[
      XPath.attr(:role) == "article",
      XPath.self(:article)
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
    # Limit supplied block to within a article
    #
    # @param [String] Name Article label
    # @param [Hash] options Finder options
    def within_article(*arguments, **options, &block)
      within(:article, *arguments, **options, &block)
    end
  end
end
