# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:required, :boolean, skip_if: nil) do |xpath, value|
    next xpath[XPath.attr(:required) | XPath.attr(:"aria-required") == "true"] if value

    xpath[~XPath.attr(:required) & ~(XPath.attr(:"aria-required") == "true")]
  end

  describe(:expression_filters) do |required: nil, **|
    next " that is required" if required
    next " that is not required" if required == false

    ""
  end
end
