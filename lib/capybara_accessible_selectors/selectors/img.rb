# frozen_string_literal: true

Capybara.add_selector(:img, locator_type: [String, Regexp]) do
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

  locator_filter skip_if: nil do |node, locator, exact:, **|
    accessible_name = node.accessible_name
    case locator
    when String
      exact ? accessible_name == locator : accessible_name.include?(locator.to_s)
    when Regexp
      locator.match?(accessible_name)
    end
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
