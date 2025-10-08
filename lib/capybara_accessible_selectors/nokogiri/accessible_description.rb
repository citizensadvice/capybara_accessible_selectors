# frozen_string_literal: true

# TODO: Move into accessible name
module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleDescription < AccessibleName
      def initialize(node, within_described_by: false, within_content: false, include_hidden: false, visited: [])
        @node = node
        @within_described_by = within_described_by
        @within_content = within_content
        @include_hidden = include_hidden
        @visited = visited
      end

      def accessible_description
        # https://www.w3.org/TR/accname-1.2/
        return nil if hidden? || accessible_hidden? || @visited.include?(node)

        # Technically some roles are prohibited from being named
        # but browsers aren't enforcing this and aria-label/aria-labelledby still override these
        name_from_aria_described_by ||
          name_from_aria_description ||
          name_from_host_language ||
          name_from_tooltip
      end

      private

      def name_from_aria_described_by
        return nil if @within_label

        @node[:"aria-describedby"].split(/[\t\n\r\f ]+/).filter_map do |name|
          next if name == ""

          found = @node.document.at_xpath(XPath.descendant[XPath.attr(:id) == name])
          next unless found

          recurse_name(title, within_label: true, include_hidden: hidden_node?(found))
        end.join(" ")
      end

      def description_from_aria_description
        striped_value(@node[:"aria-description"])
      end

      def description_from_host_language
        # https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
        case @node.node_name
        when "table"
          name_from_caption
        when "input"
          name_from_value if %w[button submit reset].include(@node[:type])
        end
      end

      def name_from_content
        next unless @within_content || name_from_content?
        next " " if @node.node_name == "br"

        name = @node.children.filter_map do |node|
          next node.text if node.text?

          next recurse_name(within_content: true)
        end.join

        name = " #{name} " if block?
        striped_value(name)
      end

      def name_from_tooltip
        striped_value(@name[:title])
      end

      def name_from_caption
        node = @node.children.find { _1.node_name == "caption" }
        next unless node

        recurse_name(title, within_content: true)
      end

      def recurse_node, within_described_by: @within_described_by, within_content: false)
        AccessibleDescription.new(node, within_described_by:, within_content:, visited: [*@visited, @node]).accessible_description
      end

      def block?
        BLOCK_ELEMENTS.include?(@node.tag_name)
      end

      def hidden_node?(_node)
        [@node, *@node.ancestors].any? do |node|
          node.key?(:hidden) || /display:\s?none/.match?(node[:style] || "")
        end
      end

      def accessible_name
        @accessible_name ||= AccessibleName.new(@node).accessible_name
      end

      def striped_value(value)
        value = value&.strip&.gsub(/\s+/, " ")
        return nil if value == ""
        return nil if value == accessible_name

        value
      end
    end
  end
end
