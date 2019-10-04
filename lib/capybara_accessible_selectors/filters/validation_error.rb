# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:validation_error) do |node, value|
    state = true
    if Capybara.evaluate_script("arguments[0].validity.valid", node)
      add_error "Expected element validity.valid to be false."
      state = false
    end
    if node[:"aria-invalid"] == "false"
      add_error "aria-invalid cannot be false."
      state = false
    end
    ids = node[:"aria-describedby"]&.split(/\s+/)&.compact
    descriptions = [
      *node.all(:xpath, XPath.ancestor(:label)[1]),
      *(node[:id] && node.all(:xpath, XPath.anywhere(:label)[XPath.attr(:for) == node[:id]])),
      *node.all(:xpath, XPath.anywhere[ids.map { |id| XPath.attr(:id) == id }.reduce(:|)], wait: false)
    ]
    unless descriptions.any? { |d| d.has_text? value, wait: false }
      add_error "Expected to be described by \"#{value}\" but it was described by \"#{descriptions.map(&:text).join(' ')}\"."
      state = false
    end
    state
  end
end
