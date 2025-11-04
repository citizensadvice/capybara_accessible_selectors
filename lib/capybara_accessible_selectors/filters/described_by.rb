# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:described_by, valid_values: [String, Regexp]) do |node, value|
    Capybara::Helpers.warn("described_by is deprecated in favour of accessible_description")

    next false unless node[:"aria-describedby"]

    description = node.accessible_description
    next true if value.is_a?(String) && description.include?(value)
    next true if value.is_a?(Regexp) && value.match?(description)

    add_error " expected to be described by #{value.inspect} but it was described by \"#{description}\"."
    false
  end
end
