# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:validation_error, valid_types: String) do |node, value|
    state = true
    if Capybara.evaluate_script("arguments[0].willValidate === false", node)
      add_error " expected element validity.willValidate to be true"
      state = false
    end
    if Capybara.evaluate_script("'validity' in arguments[0] && arguments[0].validity.valid", node)
      add_error " expected element validity.valid to be false"
      state = false
    end
    if Capybara.evaluate_script("!('validity' in arguments[0])", node) && node[:"aria-invalid"] != "true"
      add_error " expected aria-invalid to be true"
      state = false
    elsif node[:"aria-invalid"] == "false"
      add_error " aria-invalid cannot be false"
      state = false
    end
    description = CapybaraAccessibleSelectors::Helpers.element_description(node)
    unless description.include? value
      add_error " expected to be described by \"#{value}\" but it was described by \"#{description}\"."
      state = false
    end
    state
  end
end
