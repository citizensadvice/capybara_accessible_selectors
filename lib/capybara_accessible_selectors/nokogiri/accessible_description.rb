# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/accessible_role"
require "capybara_accessible_selectors/nokogiri/helpers"

# https://www.w3.org/TR/accname-1.2/#mapping_additional_nd_description
# https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
# https://www.w3.org/TR/wai-aria-1.3/

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleDescription
      include Helpers

      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node)
        @node = node
      end

      def resolve
        return nil if inert?(@node)
        return nil if !@include_hidden && (hidden?(@node) || aria_hidden?(@node))
        return nil if NAME_DISALLOWED_ROLES.include?(role)

        @accessible_name = AccessibleName.new(@node).resolve

        description = description_from_aria_described_by ||
                      description_from_aria_description ||
                      description_from_host_language ||
                      description_from_attribute(:title)

        @accessible_name == description ? nil : description
      end

      private

      def description_from_aria_described_by
        return if @recurse
        return unless @node.has_attribute?("aria-describedby")

        parts = @node[:"aria-describedby"].to_s.split(R_WHITE_SPACE).filter_map do |id|
          next if id == ""

          found = @node.document.at_xpath(XPath.anywhere[XPath.attr(:id) == id].to_s)
          next unless found

          recurse_name(found, within_label: true, include_hidden: hidden?(found) || aria_hidden?(found))
        end
        parts.join(" ").then { normalised_description(_1) }
      end

      def description_from_aria_description
        return if @recurse
        return unless @node.has_attribute?("aria-description")

        normalised_description(@node[:"aria-description"])
      end

      def description_from_host_language
        return if @recurse

        case @node.node_name
        when "table"
          description_from_caption
        when "input"
          description_from_attribute(:value) if %w[button submit reset].include?(@node[:type])
        end
      end

      def description_from_attribute(name)
        normalised_description(@node[name])
      end

      def description_from_value(name)
        value = normalised_description(@node[name])

        return if ["", @accessible_name].include?(value)

        value
      end

      def description_from_caption
        node = @node.children.find { _1.node_name == "caption" }
        return unless node

        caption = recurse_name(node)
        return if ["", @accessible_name].include?(caption)

        caption
      end

      def recurse_name(node, within_label: false, include_hidden: @include_hidden)
        AccessibleName.resolve(node, recurse: true, within_label:, include_hidden:, visited: Set[@node])
      end

      def block?(node)
        BLOCK_ELEMENTS.include?(node.node_name)
      end

      def accessible_name
        @accessible_name ||= AccessibleName.new(@node).resolve
      end

      def normalised_description(value)
        value.to_s.strip.gsub(/\s+/, " ")
      end

      def role
        AccessibleRole.resolve(@node)
      end
    end
  end
end
