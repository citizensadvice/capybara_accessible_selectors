# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:validation_error, valid_values: [String, true, false]) do |node, value|
    if value.is_a?(String) && value.strip == ""
      Capybara::Helpers.warn("Checking for a validation message of an empty string is confusing and/or pointless as it will always match")
      value = true
    end
    error_messages = []
    will_validate = node.evaluate_script("this.willValidate")
    aria_invalid = node[:"aria-invalid"]
    native_invalid = node.evaluate_script("this.validity?.valid === false")
    error_messages << " expected element to be a candidate for constraint validation" if will_validate == false
    error_messages << " expected element to be invalid" if value && will_validate && aria_invalid != "true" && !native_invalid
    error_messages << " expected element to have aria-invalid=true" if value && !will_validate && aria_invalid != "true"
    error_messages << " expected element not to be invalid" if !value && native_invalid
    error_messages << " expected element not to have aria-invalid=true" if !value && aria_invalid
    error_messages << " expected aria-invalid not to be false if the element is invalid" if native_invalid && aria_invalid == "false"

    if value.is_a?(String)
      description = CapybaraAccessibleSelectors::Helpers.element_description(node)
      unless description.include?(value)
        error_messages << " expected to be described by \"#{value}\" but it was described by \"#{description}\"."
      end
    end

    errors.push(*error_messages)
    error_messages.empty?
  end
end
