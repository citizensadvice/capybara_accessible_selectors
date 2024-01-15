# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Helpers
    module_function

    def element_description(node)
      ids = node[:"aria-describedby"]&.split(/\s+/)&.compact
      [
        *node.all(:xpath, XPath.ancestor(:label)[1], wait: false),
        *(node[:id] && node.all(:xpath, XPath.anywhere(:label)[XPath.attr(:for) == node[:id]], wait: false)),
        *elements_by_ids_in_order(node, ids)
      ].compact.map { |n| n.text(normalize_ws: true) }.join(" ")
    end

    def element_labelledby(node)
      ids = node[:"aria-labelledby"]&.split(/\s+/)&.compact
      elements_by_ids_in_order(node, ids).map { |n| n.text(normalize_ws: true) }.join(" ")
    end

    def element_describedby(node)
      ids = node[:"aria-describedby"]&.split(/\s+/)&.compact
      elements_by_ids_in_order(node, ids).map { |n| n.text(normalize_ws: true) }.join(" ")
    end

    def elements_by_ids_in_order(node, ids)
      return [] if ids.nil? || ids.empty?

      node.all(:xpath, XPath.anywhere[ids.map { |id| XPath.attr(:id) == id }.reduce(:|)], wait: false)
          .each_with_index.map { |n, i| [i, n[:id], n] }
          .sort { |(ai, aid), (bi, bid)| (bi - ids.find_index(bid)) - (ai - ids.find_index(aid)) }
          .map { |(_, _, n)| n }
    end

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
  end
end
