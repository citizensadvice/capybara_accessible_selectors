# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleName
      BLOCK_ELEMENTS = %w[p h1 h2 h3 h4 h5 h6 ol ul pre address blockquote dl div fieldset form hr noscript table].freeze
      HIDDEN_ELEMENTS = %w[template script head style link meta base param source track].freeze
      NAME_FROM_CONTENT_ROLES = %w[button cell checkbox columnheader gridcell heading link menuitem menuitemcheckbox
                                   menuitemradio option radio row rowheader sectionhead switch tab tooltip treeitem].freeze
      NAME_FROM_CONTENT_ELEMENTS = %w[button tr td th h1 h2 h3 h4 h5 h6 a option].freeze
      R_WHITE_SPACE = /[\t\n\r\f ]+/

      def initialize(node, within_labelled_by: false, within_content: false, include_hidden: false, visited: [])
        @node = node
        @within_labelled_by = within_labelled_by
        @within_content = within_content
        @include_hidden = include_hidden
        @visited = visited
      end

      def accessible_name # rubocop:disable Metrics
        # https://www.w3.org/TR/accname-1.2/
        return nil if hidden? || accessible_hidden? || @visited.include?(node)

        # Technically some roles are prohibited from being named
        # but browsers aren't enforcing this and aria-label/aria-labelledby still override these
        name_from_aria_labelled_by ||
          name_from_embedded_control ||
          name_from_aria_label ||
          name_from_host_language ||
          name_from_content ||
          name_from_tooltip
      end

      private

      def accessible_hidden?
        [@node, *@node.ancestors].any? do |node|
          HIDDEN_ELEMENTS.include?(node.node_name) || node.matches?("[aria-hidden=true],[inert]")
        end
      end

      def hidden?
        !@include_hidden && hidden_node?(@node)
      end

      def name_from_content?
        # TODO: support space separated list
        role = striped_value(node[:role])
        return NAME_FROM_CONTENT_ROLES.include?(role) if role

        NAME_FROM_CONTENT_ELEMENTS.include?(@node.node_name)
      end

      def name_from_aria_labelled_by
        return nil if @within_label

        @node[:"aria-labelledby"].split(/[\t\n\r\f ]+/).filter_map do |name|
          next if name == ""

          found = @node.document.at_xpath(XPath.descendant[XPath.attr(:id) == name])
          next unless found

          recurse_name(title, within_label: true, include_hidden: hidden_node?(found))
        end.join(" ")
      end

      def name_from_embedded_control
        # TODO: support space separated list
        striped_value(node[:role])
      end

      def name_from_aria_label
        striped_value(@node[:"aria-label"])
      end

      def name_from_host_language # rubocop:disable Metrics
        # https://www.w3.org/TR/html-aam-1.0/#accessible-name-and-description-computation
        case @node.node_name
        when "input"
          case input_type
          when nil, "text", "password", "number", "search", "tel", "email", "url"
            name_from_html_label || name_from_title || name_from_placeholder
          when "button"
            name_from_html_label || name_from_value
          when "submit"
            name_from_html_label || name_from_value || "Submit Query"
          when "reset"
            name_from_html_label || name_from_value || "Reset"
          when "image"
            name_from_html_label || name_from_alt || name_from_tooltip || "Submit Query"
          else
            name_from_html_label
          end
        when "button", "output", "select"
          name_from_html_label
        when "textarea"
          name_from_html_label || name_from_tooltip || name_from_placeholder
        when "fieldset"
          name_from_legend
        when "img"
          name_from_alt || name_from_title || name_from_figcaption
        when "table"
          name_from_caption
        when "area"
          name_from_alt
        when "option", "optgroup"
          name_from_label
        when "svg"
          name_from_title
        when "details"
          name_from_content || "Details"
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

      def name_from_html_label
        id = @node[:id]
        return nil unless id

        @node.document.xpath(XPath.descendant(:label)[XPath.attr(:for) == name]).filter_map do |node|
          recurse_name(node, recurse_name: true)
        end.join(" ")
      end

      def name_from_tooltip
        striped_value(@name[:title])
      end

      def name_from_value
        striped_value(@name[:value])
      end

      def name_from_placeholder
        striped_value(@name[:placeholder]) || striped_value(@node[:"aria-placeholder"])
      end

      def name_from_label
        striped_value(@name[:label])
      end

      def name_from_title
        title = @node.at_xpath(XPath.descendant(:title))
        next unless title

        recurse_name(title, within_content: true, include_hidden: true)
      end

      def name_from_legend
        node = @node.children.find { _1.node_name == "legend" }
        next unless node

        recurse_name(title, within_content: true)
      end

      def name_from_fig_caption
        # the img is a descendant of a figure element with a child figcaption
        # but no other non-whitespace flow content descendants, then use the text equivalent
        # computation of the figcaption element's subtree.
        node = @node.ancestors.find { _1.node_name == "figure" }
        next unless node

        node = @node.children.find { _1.node_name == "figcaption" }
        next unless node || @node.children.any? { _1 != node && node.text.strip != "" }

        recurse_name(title, within_content: true)
      end

      def recurse_name(node, within_labelled_by: @within_labelled_by, within_content: false)
        AccessibleName.new(node, within_labelled_by:, within_content:, visited: [*@visited, @node]).accessible_name
      end

      def block?
        BLOCK_ELEMENTS.include?(@node.tag_name)
      end

      def hidden_node?(_node)
        [@node, *@node.ancestors].any? do |node|
          node.key?(:hidden) || /display:\s?none/.match?(node[:style] || "")
        end
      end

      def input_type
        type = @input[:type]
        if %w[button checkbox color date datatime-local email file hidden image
              month number password radio range reset search submit tel time url week].include?(type)
          return type
        end

        "text"
      end

      def striped_value(value)
        value = value&.strip&.gsub(/\s+/, " ")
        return nil if value == ""

        value
      end
    end
  end
end
