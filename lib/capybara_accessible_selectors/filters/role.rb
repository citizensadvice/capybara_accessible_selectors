# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  expression_filter(:role, skip_if: nil) do |scope, value|
    case scope
    when String then %(#{scope}[role="#{value}"])
    else             scope[XPath.attr(:role) == value.to_s]
    end
  end
end
