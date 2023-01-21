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

  filter_set(:capybara_accessible_selectors, %i[described_by])
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

  filter_set(:capybara_accessible_selectors, %i[described_by])
end

module CapybaraAccessibleSelectors
  module Actions
    # Opens a tab
    #
    # @param [String] locator The text of the button
    #
    # @return [Capybara::Node::Element] The element clicked
    def select_tab(name = nil, **find_options, &block)
      if name.nil? && is_a?(Capybara::Node::Element) && matches_selector?(:tab_button)
        self
      else
        find(:tab_button, name, **find_options)
      end.click

      within_tab_panel(name, **find_options, &block) if block_given?
    end
  end

  module Session
    # Limit supplied block to within a tab panel
    #
    # @param [String] name The tab button label
    # @param [Hash] options Finder options
    def within_tab_panel(name, **options, &block)
      within(:tab_panel, name, **options, &block)
    end
  end
end
