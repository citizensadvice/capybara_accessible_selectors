# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleDescription
      BLOCK_ELEMENTS = %w[p h1 h2 h3 h4 h5 h6 ol ul pre address blockquote dl div fieldset form hr noscript table].freeze
      HIDDEN_ELEMENTS = %w[template script head style link meta base param source track].freeze
      R_WHITE_SPACE = /[\t\n\r\f ]+/

      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node, within_label: false, within_content: false, include_hidden: false, visited: [])
        @node = node
        @within_label = within_label
        @within_content = within_content
        @include_hidden = include_hidden
        @visited = visited
      end

      def resolve
        # https://www.w3.org/TR/accname-1.2/
        return nil if hidden? || accessible_hidden? || @visited.include?(node)

        description_from_aria_described_by ||
          description_from_aria_description ||
          description_from_host_language ||
          description_from_tooltip
      end

      private

      def description_from_aria_described_by
        return nil if @within_label

        @node[:"aria-describedby"].split(R_WHITE_SPACE).filter_map do |name|
          next if name == ""

          found = @node.document.at_xpath(XPath.descendant[XPath.attr(:id) == name])
          next unless found

          recurse_description(title, within_label: true, include_hidden: hidden_node?(found))
        end.join(" ")
      end

      def description_from_aria_description
        striped_description(@node[:"aria-description"])
      end

      def description_from_host_language
        # https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
        case @node.node_name
        when "table"
          description_from_caption
        when "input"
          description_from_value if %w[button submit reset].include(@node[:type])
        end
      end

      def description_from_content
        next unless @within_content || description_from_content?
        next " " if @node.node_name == "br"

        name = @node.children.filter_map do |node|
          next node.text if node.text?

          next recurse_description(within_content: true)
        end.join

        name = " #{name} " if block?
        striped_description(name)
      end

      def description_from_tooltip
        striped_description(@name[:title])
      end

      def description_from_caption
        node = @node.children.find { _1.node_name == "caption" }
        next unless node

        recurse_description(title, within_content: true)
      end

      def recurse_description(node, within_label: @within_label, within_content: false)
        AccessibleDescription.resolve(node, within_label:, within_content:, visited: [*@visited, @node])
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

      def striped_description(value)
        value = value&.strip&.gsub(/\s+/, " ")
        return nil if value == ""
        return nil if value == accessible_name

        value
      end
    end
  end
end
