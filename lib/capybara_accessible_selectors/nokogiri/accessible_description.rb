# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/accessible_role"
require "capybara_accessible_selectors/nokogiri/helpers"

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleDescription
      include Helpers

      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node, role: nil, within_label: false, recurse: false, include_hidden: false, visited: Set.new)
        @node = node
        @within_label = within_label
        @recurse = recurse
        @include_hidden = include_hidden
        @visited = visited
        @role = role
      end

      def resolve
        # https://www.w3.org/TR/accname-1.2/
        return nil if inert?(@node)
        return nil if !@include_hidden && (hidden?(@node) || aria_hidden?(@node))

        description_from_aria_described_by ||
          description_from_aria_description ||
          description_from_host_language ||
          description_from_content ||
          description_from_tooltip
      end

      private

      def description_from_aria_described_by
        return nil if @within_label

        parts = @node[:"aria-describedby"].to_s.split(R_WHITE_SPACE).filter_map do |id|
          next if id == ""

          found = @node.document.at_xpath(XPath.anywhere[XPath.attr(:id) == id].to_s)
          next unless found

          recurse_description(found, within_label: true, include_hidden: hidden?(found) || aria_hidden?(found))
        end
        parts.join(" ").then { normalised_description(_1) }
      end

      def description_from_aria_description
        normalised_description(@node[:"aria-description"])
      end

      def description_from_host_language
        # https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
        case @node.node_name
        when "table"
          description_from_caption
        when "input"
          description_from_attribute(:value) if %w[button submit reset].include?(@node[:type])
        end
      end

      def description_from_content
        return unless @recurse

        name = @node.children.filter_map do |node|
          next if @visited.include?(node)

          if node.text?
            @visited << node
            next node.text
          end

          text = recurse_name(node)
          text = " #{text} " if block?(node)
          text
        end.join

        normalised_description(name)
      end

      def description_from_tooltip
        title = description_from_attribute(:title)
        title = " #{title} " if title && @recurse
        title
      end

      def description_from_attribute(name)
        normalised_description(@node[name])
      end

      def description_from_caption
        node = @node.children.find { _1.node_name == "caption" }
        return unless node

        recurse_description(title, within_content: true)
      end

      def recurse_description(node, within_label: @within_label, include_hidden: @include_hidden)
        @visited << @node
        description = AccessibleDescription.resolve(node, within_label:, recurse: true, include_hidden:, visited: @visited)
        @visited << node
        description
      end

      def block?
        BLOCK_ELEMENTS.include?(@node.tag_name)
      end

      def accessible_name
        @accessible_name ||= AccessibleName.new(@node).resolve
      end

      def normalised_description(value)
        value = value&.strip&.gsub(/\s+/, " ")
        return nil if value == ""
        return nil if value == accessible_name

        value
      end
    end
  end
end
