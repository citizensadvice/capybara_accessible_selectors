# frozen_string_literal: true

Capybara.add_selector(:tab_button) do
  xpath do |name|
    XPath.anywhere[[
      XPath.attr(:role) == "tab",
      XPath.parent[XPath.attr(:role) == "tablist"],
      XPath.string.n.is(name.to_s)
    ].reduce(:&)]
  end

  expression_filter(:open, :boolean) do |xpath, open|
    xpath[XPath.attr(:"aria-selected") == open.to_s]
  end

  describe_expression_filters do |open: nil, **|
    next if open.nil?

    open ? " open" : " closed"
  end
end

Capybara.add_selector(:tab_panel) do
  xpath do |name|
    tab = XPath.anywhere[[
      XPath.attr(:role) == "tab",
      XPath.parent[XPath.attr(:role) == "tablist"],
      XPath.string.n.is(name.to_s)
    ].reduce(:&)]
    XPath.descendant[XPath.attr(:role) == "tabpanel"][XPath.attr(:id) == tab.attr(:"aria-controls")]
  end

  node_filter(:open, :boolean) do |node, value|
    node.find(:xpath, XPath.anywhere[XPath.attr(:"aria-controls") == node[:id]])[:"aria-selected"] == value.to_s
  end

  describe_node_filters do |open: nil, **|
    next if open.nil?

    " expected to be #{open ? :open : :closed}"
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Opens a tab
    #
    # @param [String] locator The text of the button
    #
    # @return [Capybara::Node::Element] The element clicked
    def select_tab(name)
      find(:tab_button, name).click
    end
  end
end
