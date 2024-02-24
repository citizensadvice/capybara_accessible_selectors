# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:role, valid_values: [String, Symbol, nil]) do |node, value|
    role = node.role
    next true if role == value

    add_error " expected to have #{value ? "role #{value.inspect}" : 'no role'} but it had #{role ? "role #{role.inspect}" : 'no role'}."
    false
  end
end
