# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:described_by, valid_values: [String]) do |node, value|
    next false unless node[:"aria-describedby"]

    description = CapybaraAccessibleSelectors::Helpers.element_describedby(node)
    next true if description.include? value

    add_error " expected to be described by \"#{value}\" but it was described by \"#{description}\"."
    false
  end
end
