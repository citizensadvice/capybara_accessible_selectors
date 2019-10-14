# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Helpers
    module_function

    def element_description(node) # rubocop:disable Metrics/AbcSize
      ids = node[:"aria-describedby"]&.split(/\s+/)&.compact
      [
        *node.all(:xpath, XPath.ancestor(:label)[1], wait: false),
        *(node[:id] && node.all(:xpath, XPath.anywhere(:label)[XPath.attr(:for) == node[:id]], wait: false)),
        *(node.all(:xpath, XPath.anywhere[ids.map { |id| XPath.attr(:id) == id }.reduce(:|)], wait: false) if ids)
      ].compact.map { |n| n.text(normalize_ws: true) }.join(" ")
    end

    def within_fieldset(xpath, locator)
      fieldset = XPath.descendant(:fieldset)[XPath.child(:legend)[XPath.string.n.is(locator.to_s)]]
      if xpath.is_a? XPath::Union
        xpath.expressions.map do |x|
          fieldset.descendant(x)
        end.reduce(:+)
      else
        fieldset.descendant(xpath)
      end
    end
  end
end
