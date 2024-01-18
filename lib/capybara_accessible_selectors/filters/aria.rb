# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:aria, valid_values: [Hash], skip_if: nil) do |scope, nested_attributes|
    prefixed_attributes = nested_attributes.transform_keys { |key| "aria-#{key}" }

    case scope
    when String
      selectors = prefixed_attributes.map { |key, value| %([#{key}="#{value}"]) }

      [scope, *selectors].join
    else
      expressions = prefixed_attributes.map { |key, value| XPath.attr(key.to_sym) == value.to_s }

      scope[expressions.reduce(:&)]
    end
  end

  describe(:expression_filters) do |aria: {}, **|
    attributes = aria.map { |key, value| %(aria-#{key}="#{value}") }

    " with #{attributes.join(' and ')}" unless attributes.empty?
  end
end
