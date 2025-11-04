# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # This is hacked into SelectorQuery to the "exact" option can be supported

  module AccessibleDescriptionFilter
    def description(*)
      desc = super
      desc << " with accessible description #{options[:accessible_description].inspect}" if options[:accessible_description]
      desc
    end

    private

    def matches_system_filters?(node)
      super && matches_accessible_description_filter?(node)
    end

    def matches_accessible_description_filter?(node)
      return true unless use_default_accessible_description_filter?

      accessible_description = node.accessible_description
      value = options[:accessible_description]
      case options[:accessible_description]
      when String
        options[:exact] ? accessible_description == value : accessible_description.include?(value)
      when Regexp
        value.match?(accessible_description)
      end
    end

    def use_default_accessible_description_filter?
      options.key?(:accessible_description) && !custom_keys.include?(:accessible_description)
    end
  end

  ::Capybara::Queries::SelectorQuery::VALID_KEYS << :accessible_description
  ::Capybara::Queries::SelectorQuery.prepend AccessibleDescriptionFilter
end
