# frozen_string_literal: true

Capybara.add_selector(:dialog, locator_type: [String, Symbol]) do
  xpath do |*|
    XPath.descendant[
      [
        XPath.self(:dialog)[XPath.attr(:open)],
        (XPath.attr(:role) == "dialog") | (XPath.attr(:role) == "alertdialog")
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

  node_filter(:modal, :boolean) do |node, value|
    if node.tag_name == "dialog"
      if value
        node.matches_css?(":modal", wait: 0)
      else
        node.not_matches_css?(":modal", wait: 0) && node[:role] != "alertdialog"
      end
    elsif value
      node[:"aria-modal"] == "true"
    else
      [nil, "false"].include?(node[:"aria-modal"]) && node[:role] != "alertdialog"
    end
  end

  describe(:node_filters) do |modal: true|
    modal ? " that is a modal" : ""
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a dialog
    #
    # @param [String] Name Dialog label
    # @param [Hash] options Finder options
    def within_dialog(...)
      within(:dialog, ...)
    end
  end
end
