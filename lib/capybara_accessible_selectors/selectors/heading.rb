# frozen_string_literal: true

Capybara.add_selector :heading, locator_type: [String, Symbol] do
  xpath do |locator, **|
    xpath = XPath.descendant[[
      XPath.attr(:role) == "heading",
      *(1..6).map { XPath.self(:"h#{_1}") }
    ].reduce(:|)]
    xpath = xpath[XPath.string.n.is(locator) | XPath.attr(:"aria-label") | XPath.attr(:"aria-labelledby")] unless locator.nil?
    xpath
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
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
    else
      true
    end
  end

  filter_set(:capybara_accessible_selectors, %i[described_by])
end
