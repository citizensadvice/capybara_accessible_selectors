# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:current, skip_if: nil) do |xpath, value|
    xpath[XPath.attr(:"aria-current") == value.to_s]
  end
end
