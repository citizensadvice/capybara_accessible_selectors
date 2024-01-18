# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:described_by, valid_values: [String, Regexp]) do |node, value|
    next false unless node[:"aria-describedby"]

    description = CapybaraAccessibleSelectors::Helpers.element_describedby(node)
    next true if value.is_a?(String) && description.include?(value)
    next true if value.is_a?(Regexp) && value.match?(description)

    add_error " expected to be described by #{value.inspect} but it was described by \"#{description}\"."
    false
  end
end
