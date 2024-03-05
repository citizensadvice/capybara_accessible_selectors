# frozen_string_literal: true

Capybara.add_selector(:menu, locator_type: [String, Symbol]) do
  def aria_or_real_button
    XPath.self(:button) | (XPath.attr(:role) == "button")
  end

  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "menu"]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
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

Capybara.add_selector(:menuitem, locator_type: [String, Symbol]) do
  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "menuitem"]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    method = exact ? :eql? : :include?
    label =
      if node[:"aria-labelledby"]
        CapybaraAccessibleSelectors::Helpers.element_labelledby(node)
      elsif node[:"aria-label"]
        node[:"aria-label"]
      else
        node.text
      end

    label.public_send(method, locator.to_s)
  end

  node_filter(:disabled, :boolean, default: false) do |node, value|
    (node[:"aria-disabled"] || "false") == value.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
