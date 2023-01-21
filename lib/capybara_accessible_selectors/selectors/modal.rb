# frozen_string_literal: true

Capybara.add_selector(:modal, locator_type: [String, Symbol]) do
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
    next true if locator.nil?

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
    # Limit supplied block to within a modal
    #
    # @param [String] Name Modal label
    # @param [Hash] options Finder options
    def within_modal(name, **options, &block)
      within(:modal, name, **options, &block)
    end
  end
end
