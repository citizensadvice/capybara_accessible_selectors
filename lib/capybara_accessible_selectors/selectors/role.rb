# frozen_string_literal: true

require "capybara_accessible_selectors/aria"

Capybara.add_selector :role do
  xpath do |locator, custom_elements: nil, **|
    roles = CapybaraAccessibleSelectors::Helpers.expand_roles(locator)
    [
      *roles.flat_map { CapybaraAccessibleSelectors::Aria::IMPLICIT_ROLE_SELECTORS[_1.to_sym] || [] },
      *Array(custom_elements).map { XPath.descendant(_1.to_sym) }.map { _1[!XPath.attr(:role)] },
      *roles.map { XPath.descendant[XPath.attr(:role).contains_word(_1)] }
    ].inject(&:union)
  end

  locator_filter do |node, locator, **|
    CapybaraAccessibleSelectors::Helpers.expand_roles(locator).include?(node.role)
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a role
    #
    # @param [String|String[]] role Roles to find
    # @param [Hash] options Finder options
    def within_role(...)
      within(:role, ...)
    end
  end
end
