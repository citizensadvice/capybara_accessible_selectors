# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:current, valid_values: [nil, String]) do |xpath, value|
    value = value.nil? ? false : value.to_s

    builder(xpath).add_attribute_conditions("aria-current": value)
  end
end
