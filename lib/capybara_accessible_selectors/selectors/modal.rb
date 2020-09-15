# frozen_string_literal: true

Capybara.add_selector(:modal, locator_type: [String, Symbol]) do
  xpath do |*|
    XPath.descendant[[
      XPath.attr(:"aria-modal") == "true",
      (XPath.attr(:role) == "dialog") | (XPath.attr(:role) == "alertdialog")
    ].reduce(:&)]
  end

  locator_filter do |node, locator|
    next true if locator.nil?

    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).include?(locator)
    elsif node[:"aria-label"]
      node[:"aria-label"] == locator.to_s
    end
  end
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a modal
    #
    # @param [String] Name Modal label
    # @param [Hash] options Finder options
    def within_modal(name, **options)
      within(:modal, name, **options) { yield }
    end
  end
end
