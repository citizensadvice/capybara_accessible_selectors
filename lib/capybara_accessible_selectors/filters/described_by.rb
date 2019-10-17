# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:described_by, valid_values: String) do |node, value|
    next false unless node[:"aria-describedby"]

    descriptions = node[:"aria-describedby"]
                   .split(/\s+/)
                   .compact
                   .map { |id| node.first(:xpath, XPath.anywhere[XPath.attr(:id) == id]) }

    next true if descriptions.any? { |d| d.has_text? value }

    add_error "Expected to be described by \"#{value}\" but it was described by \"#{descriptions.map(&:text).join(' ')}\"."
    false
  end
end
