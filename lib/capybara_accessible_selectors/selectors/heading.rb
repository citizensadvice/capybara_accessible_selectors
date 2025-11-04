# frozen_string_literal: true

Capybara.add_selector :heading, locator_type: [String, Regexp] do
  xpath do |*|
    XPath.descendant[[
      XPath.attr(:role) == "heading",
      *(1..6).map { XPath.self(:"h#{_1}") }
    ].reduce(:|)]
  end

  expression_filter(:level, valid_values: 1..6) do |xpath, level|
    filter = [
      XPath.self(:"h#{level}") & !XPath.attr(:"aria-level"),
      XPath.attr(:"aria-level") == level.to_s
    ]
    # Default level is 2 for role="heading"
    filter << [*(1..6).map { !XPath.self(:"h#{_1}") }, !XPath.attr(:"aria-level")].reduce(:&) if level == 2
    xpath[filter.reduce(:|)]
  end

  describe_expression_filters do |level: nil, **|
    next if level.nil?

    " level #{level}"
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
