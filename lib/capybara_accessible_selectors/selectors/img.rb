# frozen_string_literal: true

Capybara.add_selector(:img, locator_type: [String, Symbol]) do
  xpath do |*|
    XPath.descendant[
      [
        XPath.attr(:role) == "img",
        XPath.self(:img) & XPath.attr(:alt)
      ].reduce(&:|)
    ]
  end

  locator_filter do |node, locator, exact:, **|
    next true if locator.nil?

    method = exact ? :eql? : :include?
    if node.tag_name === "img"
      node[:"alt"]
    elsif node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node)
    elsif node[:"aria-label"]
      node[:"aria-label"]
    end&.public_send method, locator.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
