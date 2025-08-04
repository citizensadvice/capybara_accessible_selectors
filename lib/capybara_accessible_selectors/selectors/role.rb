# frozen_string_literal: true

require "capybara_accessible_selectors/aria/implicit_role_selectors"

Capybara.add_selector :role do
  xpath do |locator, custom_elements: nil, **|
    roles = expand_roles(locator)
    [
      *roles.flat_map { CapybaraAccessibleSelectors::Aria::IMPLICIT_ROLE_SELECTORS[_1.to_sym] || [] },
      *Array(custom_elements).map { XPath.descendant(_1.to_sym) }.map { _1[!XPath.attr(:role)] },
      *roles.map { XPath.descendant[XPath.attr(:role).contains_word(_1)] }
    ].inject(&:union)
  end

  locator_filter do |node, locator, **|
    expand_roles(locator).include?(node.role)
  rescue NotImplementedError
    # If not implemented just go with the simple resolution
    # using the first role in the list
    !node[:role] || expand_roles(locator).include?(node[:role].to_s.strip.split(/\s/).first)
  end

  def expand_roles(locator)
    roles = Array(locator).map(&:to_s)
    CapybaraAccessibleSelectors::Aria::ROLE_SYNONYMS.each do |s|
      roles.push(*s) if s.intersect?(roles)
    end
    roles.uniq
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
