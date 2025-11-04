# frozen_string_literal: true

Capybara.add_selector(:menu, locator_type: [String, Regexp]) do
  def aria_or_real_button
    XPath.self(:button) | (XPath.attr(:role) == "button")
  end

  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "menu"]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    accessible_name = node.accessible_name
    case locator
    when String
      exact ? accessible_name == locator : accessible_name.include?(locator.to_s)
    when Regexp
      locator.match?(accessible_name)
    end
  end

  expression_filter(:expanded, :boolean) do |xpath, expanded|
    button = XPath.anywhere[aria_or_real_button][XPath.attr(:"aria-expanded") == expanded.to_s]
    xpath[button.attr(:"aria-controls") == XPath.attr(:id)]
  end

  node_filter(:orientation, valid_values: [String, Symbol]) do |node, value|
    orientation = (node[:"aria-orientation"] || "vertical").to_s

    orientation == value.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

Capybara.add_selector(:menuitem, locator_type: [String, Regexp]) do
  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "menuitem"]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    accessible_name = node.accessible_name
    case locator
    when String
      exact ? accessible_name == locator : accessible_name.include?(locator.to_s)
    when Regexp
      locator.match?(accessible_name)
    end
  end

  node_filter(:disabled, :boolean, default: false) do |node, value|
    (node[:"aria-disabled"] || "false") == value.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
