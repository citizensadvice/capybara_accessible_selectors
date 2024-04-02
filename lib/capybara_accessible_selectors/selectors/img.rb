# frozen_string_literal: true

Capybara.add_selector(:img, locator_type: [String, Symbol]) do
  expression_filter(:src, valid_values: [String, Regexp]) do |xpath, src|
    builder(xpath).add_attribute_conditions(src:)
  end

  describe(:expression_filters) do |src: nil, **|
    " expected to match src \"#{src}\"" unless src.nil?
  end

  xpath do |*|
    XPath.descendant[
      ((XPath.attr(:role) == "img") & (
        XPath.attr(:"aria-label") | XPath.attr(:"aria-labelledby")
      )) |
      XPath.self(:img)[XPath.attr(:alt)]
    ]
  end

  locator_filter do |node, locator, exact:, **|
    next true if locator.nil?

    method = exact ? :eql? : :include?
    if node.tag_name == "img" && !node[:alt].empty?
      node[:alt]
    elsif node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node)
    elsif node[:"aria-label"]
      node[:"aria-label"]
    end&.public_send method, locator.to_s
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
