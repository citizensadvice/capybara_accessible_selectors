# frozen_string_literal: true

Capybara.add_selector(:disclosure) do
  def aria_or_real_button
    XPath.self(:button) | (XPath.attr(:role) == "button")
  end

  xpath do |name, **|
    button = aria_or_real_button & XPath.string.n.is(name.to_s)
    aria = XPath.descendant[XPath.attr(:id) == XPath.anywhere[button][XPath.attr(:"aria-expanded")].attr(:"aria-controls")]
    details = XPath.descendant(:details)[XPath.child(:summary)[XPath.string.n.is(name.to_s)]]
    aria + details
  end

  expression_filter(:expanded, :boolean) do |xpath, expanded|
    open = expanded ? XPath.attr(:open) : !XPath.attr(:open)
    button = XPath.anywhere[aria_or_real_button][XPath.attr(:"aria-expanded") == expanded.to_s]
    xpath[open | (button.attr(:"aria-controls") == XPath.attr(:id))]
  end

  describe_expression_filters do |expanded: nil, **|
    next if expanded.nil?

    expanded ? " expanded" : " closed"
  end
end

# Specifically selects the disclosure button
#
# find(:disclosure_button, "name").click
Capybara.add_selector(:disclosure_button) do
  xpath do |name, **|
    XPath.descendant[[
      (XPath.self(:button) | (XPath.attr(:role) == "button")),
      XPath.attr(:"aria-expanded"),
      XPath.string.n.is(name.to_s)
    ].reduce(:&)] + XPath.descendant(:summary)[XPath.string.n.is(name.to_s)]
  end

  expression_filter(:expanded, :boolean) do |xpath, expanded|
    open = expanded ? XPath.parent.attr(:open) : !XPath.parent.attr(:open)
    xpath[(XPath.attr(:"aria-expanded") == expanded.to_s) | open]
  end

  describe_expression_filters do |expanded: nil, **|
    next if expanded.nil?

    expanded ? " expanded" : " closed"
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Toggle a disclosure open or closed
    #
    # @param [String] locator The text of the button
    # @option options [Boolean] expand Set true to open, false to close, or nil to toggle
    #
    # @return [Capybara::Node::Element] The element clicked
    def toggle_disclosure(name, expand: nil)
      button = find(:disclosure_button, name)
      if expand.nil?
        button.click
      elsif button.tag_name == "summary"
        button.click if button.find(:xpath, "..")[:open] == expand
      elsif button[:"aria-expanded"] != (expand ? "true" : "false")
        button.click
      end
    end
  end
end
