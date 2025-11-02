# frozen_string_literal: true

# https://www.w3.org/TR/accname-1.2/#mapping_additional_nd_description
# https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
# https://www.w3.org/TR/wai-aria-1.3/

module CapybaraAccessibleSelectors
  module Selenium
    class AccessibleDescription
      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node)
        @node = node
      end

      def resolve
        @accessible_name = @node.accessible_name

        resolved = description_from_aria_described_by ||
                   description_from_attribute(:"aria-description") ||
                   description_from_host_language ||
                   description_from_attribute(:title)

        resolved == @accessible_name ? nil : resolved
      end

      private

      def description_from_aria_described_by
        described_by = @node[:"aria-describedby"]
        return unless described_by

        ids = described_by.split(/\s+/).compact
        normalised(elements_by_ids_in_order(ids).map { _1.visible? ? _1.visible_text : _1.all_text }.join(" "))
      end

      def description_from_host_language
        case @node.tag_name
        when "table"
          description_from_caption
        when "input"
          description_from_value if %w[button submit reset].include?(@node[:type])
        end
      end

      def description_from_caption
        text = normalised(@node.find_xpath(XPath.child(:caption))&.visible_text)
        return if text == ""
        return if text == @accessible_nam

        text
      end

      def description_from_value
        value = description_from_attribute(:value)
        return if value == ""
        return if value == @accessible_name

        value
      end

      def description_from_attribute(name)
        value = @node[name]
        return unless value

        normalised(value)
      end

      def normalised(value)
        value.to_s.strip.gsub(/\s+/, " ")
      end

      def elements_by_ids_in_order(ids)
        return [] if ids.nil? || ids.empty?

        @node.find_xpath(XPath.anywhere[ids.map { |id| XPath.attr(:id) == id }.reduce(:|)].to_s)
             .each_with_index.map { |n, i| [i, n[:id], n] }
             .sort { |(ai, aid), (bi, bid)| (bi - ids.find_index(bid)) - (ai - ids.find_index(aid)) }
             .map { |(_, _, n)| n }
      end
    end
  end
end
