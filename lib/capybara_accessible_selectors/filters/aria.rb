# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:aria, valid_values: [Hash], skip_if: nil) do |scope, nested_attributes|
    prefixed_attributes = nested_attributes.transform_keys { |key| "aria-#{key}" }

    case scope
    when String # CSS
      selectors = prefixed_attributes.map do |key, value|
        if value.nil?
          %(:not([#{key}]))
        else
          %([#{key}="#{Capybara::Selector::CSS.escape(value.to_s)}"])
        end
      end

      [scope, *selectors].join
    else # XPath
      expressions = prefixed_attributes.map do |key, value|
        if value.nil?
          !XPath.attr(key.to_sym)
        else
          XPath.attr(key.to_sym) == value.to_s
        end
      end

      scope[expressions.reduce(:&)]
    end
  end

  describe(:expression_filters) do |aria: {}, **|
    attributes = aria.map { |key, value| %(aria-#{key}="#{value}") }

    " with #{attributes.join(' and ')}" unless attributes.empty?
  end
end
