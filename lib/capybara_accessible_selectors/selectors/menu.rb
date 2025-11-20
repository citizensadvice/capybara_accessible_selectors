# frozen_string_literal: true

CapybaraAccessibleSelectors.add_role_selector(:menu) do
  expression_filter(:expanded, :boolean) do |xpath, expanded|
    button = XPath.anywhere[XPath.self(:button) | (XPath.attr(:role) == "button")][XPath.attr(:"aria-expanded") == expanded.to_s]
    xpath[button.attr(:"aria-controls") == XPath.attr(:id)]
  end

  node_filter(:orientation, valid_values: [String, Symbol]) do |node, value|
    orientation = (node[:"aria-orientation"] || "vertical").to_s

    orientation == value.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

CapybaraAccessibleSelectors.add_role_selector(:menuitem) do
  node_filter(:disabled, :boolean, default: false) do |node, value|
    (node[:"aria-disabled"] || "false") == value.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
