# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Helpers
    module_function

    def within_fieldset(xpath, fieldsets)
      Array(fieldsets).reverse.reduce(xpath) do |current_xpath, locator|
        fieldset = XPath.descendant(:fieldset)[XPath.child(:legend)[XPath.string.n.is(locator.to_s)]]
        if current_xpath.is_a? XPath::Union
          current_xpath.expressions.map { fieldset.descendant(_1) }.reduce(:union)
        else
          fieldset.descendant(current_xpath)
        end
      end
    end

    def expand_roles(locator)
      roles = Array(locator).map(&:to_s)
      CapybaraAccessibleSelectors::Aria::ROLE_SYNONYMS.each do |s|
        roles.push(*s) if s.intersect?(roles)
      end
      roles.uniq
    end
  end
end
