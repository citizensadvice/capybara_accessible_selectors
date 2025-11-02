# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/accessible_role"
require "capybara_accessible_selectors/nokogiri/helpers"

# https://www.w3.org/TR/accname-1.2/
# https://www.w3.org/TR/html-aam-1.0/
# https://www.w3.org/TR/wai-aria-1.3/

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleName
      include Helpers

      attr_reader :from_tooltip

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

      # Return the computed accessible name, or nil if no name is found
      def resolve
        return nil if inert?(@node)
        return nil if !@include_hidden && (hidden?(@node) || aria_hidden?(@node))
        return nil if !@recurse && NAME_DISALLOWED_ROLES.include?(role)

        name_from_aria_labelled_by ||
          name_from_embedded_control ||
          name_from_aria_label ||
          name_from_host_language ||
          name_from_content ||
          name_from_tooltip
      end

      private

      def name_from_aria_labelled_by
        return nil if @within_label

        parts = @node[:"aria-labelledby"].to_s.split(R_WHITE_SPACE).filter_map do |name|
          next if name == ""

          found = @node.document.at_xpath(XPath.anywhere[XPath.attr(:id) == name].to_s)
          next unless found

          recurse_name(found, within_label: true, include_hidden: hidden?(found) || aria_hidden?(found))
        end
        parts.join(" ").then { normalised_name(_1) }
      end

      def name_from_embedded_control
        return nil unless @recurse

        case role
        when "textbox"
          case @node.node_name
          when "input"
            @node[:value]
          else
            @node.text
          end
        when "combobox"
          return @node[:value] if @node.node_name == "input"
          return name_from_listbox_value(@node) if @node.node_name == "select"

          "#{@node[:"aria-controls"]} #{@node[:"aria-owns"]}".split(R_WHITE_SPACE).lazy.map do |id|
            listbox = @node.document.at_xpath(XPath.anywhere[XPath.attr(:role).contains_word("listbox")][XPath.attr(:id) == id].to_s)

            name_from_listbox_value(listbox) if listbox && AccessibleRole.resolve(listbox) == "listbox"
          end.find(&:itself)
        when "listbox"
          name_from_listbox_value(@node)
        when "spinbutton", "slider"
          name_from_attribute(:"aria-valuetext") ||
            name_from_attribute(:"aria-valuenow") ||
            name_from_attribute(:value) ||
            ""
        end
      end

      def name_from_aria_label
        normalised_name(@node[:"aria-label"])
      end

      def name_from_host_language
        case @node.node_name
        when "input"
          case input_type
          when nil, "text", "password", "number", "search", "tel", "email", "url"
            name_from_html_label || name_from_attribute(:title) || name_from_placeholder
          when "button"
            name_from_html_label || name_from_attribute(:value)
          when "submit"
            name_from_html_label || name_from_attribute(:value) || "Submit"
          when "reset"
            name_from_html_label || name_from_attribute(:value) || "Reset"
          when "image"
            # This calculation is inconsistent within browsers
            name_from_html_label || name_from_attribute(:alt) || name_from_attribute(:title) || "Submit"
          else
            name_from_html_label
          end
        when "button", "output", "select"
          name_from_html_label
        when "textarea"
          name_from_html_label || name_from_attribute(:title) || name_from_placeholder
        when "fieldset"
          name_from_legend
        when "img"
          name_from_attribute(:alt) || name_from_attribute(:title) || name_from_figcaption
        when "table"
          name_from_caption
        when "area"
          name_from_attribute(:alt)
        when "option", "optgroup"
          name_from_attribute(:label)
        when "svg"
          name_from_title
        when "details"
          name_from_content || "Details"
        end
      end

      def name_from_content
        return unless @recurse || name_from_content?

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

        normalised_name(name)
      end

      def name_from_tooltip
        title = name_from_attribute(:title)
        # Needed for the accessible name calculation
        @from_tooltip = true if title
        title = " #{title} " if title && @recurse
        title
      end

      def name_from_content?
        NAME_FROM_CONTENT_ROLES.include?(role)
      end

      def name_from_html_label
        id = @node[:id]
        explicit_labels = @node.document.xpath(XPath.anywhere(:label)[XPath.attr(:for) == id].to_s) if id
        implicit_label = @node.ancestors.find { _1.node_name == "label" }

        normalised_name([*explicit_labels, implicit_label].compact.uniq.filter_map do |node|
          recurse_name(node)
        end.join(" "))
      end

      def name_from_attribute(attr)
        normalised_name(@node[attr])
      end

      def name_from_placeholder
        normalised_name(@node[:placeholder]) || normalised_name(@node[:"aria-placeholder"])
      end

      def name_from_title
        title = @node.at_xpath(XPath.descendant(:title).to_s)
        return unless title

        recurse_name(title, include_hidden: true)
      end

      def name_from_legend
        node = @node.children.find { _1.node_name == "legend" }
        return unless node

        recurse_name(node)
      end

      def name_from_figcaption
        # the img is a descendant of a figure element with a child figcaption
        # but no other non-whitespace flow content descendants, then use the text equivalent
        # computation of the figcaption element's subtree.
        caption = @node.ancestors("figure").first
        return unless caption

        figcaption = caption.children.find { _1.node_name == "figcaption" }
        return unless figcaption && caption.children.reject { _1 == figcaption || (_1.text? && _1.text.strip == "") } == [@node]

        recurse_name(figcaption)
      end

      def name_from_caption
        caption = @node.children.find { _1.node_name == "caption" }
        return unless caption

        recurse_name(caption)
      end

      def name_from_listbox_value(listbox)
        if listbox.node_name == "select"
          return @node.xpath(XPath.descendant(:option)[XPath.attr(:selected)].to_s).map do |option|
            recurse_name(option)
          end.join(" ")
        end

        listbox.xpath(XPath.descendant[XPath.attr(:role).contains_word("option")].to_s).filter_map do |option|
          next unless AccessibleRole.resolve(option) == "option"
          next unless option[:"aria-selected"] == "true"

          recurse_name(option)
        end.join(" ")
      end

      def recurse_name(node, within_label: @within_label, include_hidden: @include_hidden)
        @visited << @node
        name = AccessibleName.resolve(node, within_label:, recurse: true, include_hidden:, visited: @visited)
        @visited << node
        name
      end

      def block?(node)
        BLOCK_ELEMENTS.include?(node.node_name)
      end

      def role
        @role ||= AccessibleRole.resolve(@node)
      end

      def input_type
        @input_type ||=
          begin
            type = @node[:type]
            if %w[button checkbox color date datatime-local email file hidden image
                  month number password radio range reset search submit tel time url week].include?(type)
              type
            else
              "text"
            end
          end
      end

      def normalised_name(value)
        value = value&.strip&.gsub(/\s+/, " ")
        return nil if value == ""

        value
      end
    end
  end
end
