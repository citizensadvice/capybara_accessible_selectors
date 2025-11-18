# frozen_string_literal: true

CapybaraAccessibleSelectors.add_role_selector(:heading) do
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
end
