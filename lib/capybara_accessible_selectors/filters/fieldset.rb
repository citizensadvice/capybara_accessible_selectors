# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:fieldset, skip_if: nil) do |xpath, locator|
    fieldset = XPath.descendant(:fieldset)[XPath.child(:legend)[XPath.string.n.is(locator.to_s)]]
    if xpath.is_a? XPath::Union
      xpath.expressions.map do |x|
        fieldset.descendant(x)
      end.reduce(:+)
    else
      fieldset.descendant(xpath)
    end
  end

  describe(:expression_filters) do |fieldset: nil, **|
    " expected to be contained in fieldset labelled \"#{fieldset}\"" unless fieldset.nil?
  end
end
