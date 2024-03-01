# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # This is hacked into SelectorQuery to the "exact" option can be supported

  module AccessibleNameFilter
    def description(*)
      desc = super
      desc << " with accessible name #{options[:accessible_name].inspect}" if options[:accessible_name]
      desc
    end

    private

    def matches_system_filters?(node)
      super && matches_accessible_name_filter?(node)
    end

    def matches_accessible_name_filter?(node)
      return true unless options.key?(:accessible_name)

      accessible_name = node.accessible_name
      value = options[:accessible_name]
      case options[:accessible_name]
      when String
        options[:exact] ? accessible_name == value : accessible_name.include?(value)
      when Regexp
        value.match?(accessible_name)
      end
    end
  end

  ::Capybara::Queries::SelectorQuery::VALID_KEYS << :accessible_name
  ::Capybara::Queries::SelectorQuery.prepend AccessibleNameFilter
end
