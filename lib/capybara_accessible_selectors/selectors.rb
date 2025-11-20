# frozen_string_literal: true

module CapybaraAccessibleSelectors
  def self.add_role_selector(name, role: name, named: true, content_fallback: false, within: false, &block)
    Capybara.add_selector(name, locator_type: named ? [String, Regexp] : nil) do
      xpath do |*, custom_elements: nil, **|
        roles = CapybaraAccessibleSelectors::Helpers.expand_roles(role)
        [
          *roles.flat_map { CapybaraAccessibleSelectors::Aria::IMPLICIT_ROLE_SELECTORS[_1.to_sym] || [] },
          *Array(custom_elements).map { XPath.descendant(_1.to_sym) }.map { _1[!XPath.attr(:role)] },
          *roles.map { XPath.descendant[XPath.attr(:role).contains_word(_1)] }
        ].inject(&:union)
      end

      locator_filter do |node, locator, exact:, **|
        next false unless CapybaraAccessibleSelectors::Helpers.expand_roles(role).include?(node.role)
        next true unless named
        next true if locator.nil?

        accessible_name = node.accessible_name
        # A few roles, notably gridcell and row, don't generate accessible names in all browsers
        accessible_name = node.text(normalize_ws: true) if content_fallback && accessible_name == ""
        case locator
        when String
          exact ? accessible_name == locator : accessible_name.include?(locator.to_s)
        when Regexp
          locator.match?(accessible_name)
        end
      end

      instance_eval(&block) if block_given?

      filter_set(:capybara_accessible_selectors, %i[aria described_by])
    end

    return unless within

    Session.define_method(:"within_#{role}") do |*args, **kwargs, &block|
      within(role, *args, **kwargs, &block)
    end
  end
end

require "capybara_accessible_selectors/selectors/alert"
require "capybara_accessible_selectors/selectors/article"
require "capybara_accessible_selectors/selectors/banner"
require "capybara_accessible_selectors/selectors/combo_box"
require "capybara_accessible_selectors/selectors/contentinfo"
require "capybara_accessible_selectors/selectors/dialog"
require "capybara_accessible_selectors/selectors/disclosure"
require "capybara_accessible_selectors/selectors/grid"
require "capybara_accessible_selectors/selectors/heading"
require "capybara_accessible_selectors/selectors/image"
require "capybara_accessible_selectors/selectors/img"
require "capybara_accessible_selectors/selectors/main"
require "capybara_accessible_selectors/selectors/menu"
require "capybara_accessible_selectors/selectors/microdata"
require "capybara_accessible_selectors/selectors/modal"
require "capybara_accessible_selectors/selectors/navigation"
require "capybara_accessible_selectors/selectors/region"
require "capybara_accessible_selectors/selectors/rich_text"
require "capybara_accessible_selectors/selectors/role"
require "capybara_accessible_selectors/selectors/section"
require "capybara_accessible_selectors/selectors/tab"
require "capybara_accessible_selectors/selectors/test_id"
