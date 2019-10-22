# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:fieldset, skip_if: nil, valid_values: [Array, String, Symbol]) do |xpath, locator|
    CapybaraAccessibleSelectors::Helpers.within_fieldset(xpath, locator)
  end

  describe(:expression_filters) do |fieldset: nil, **|
    " expected to be contained in fieldset labelled \"#{fieldset}\"" unless fieldset.nil?
  end
end
