# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/helpers"
require "capybara_accessible_selectors/nokogiri/accessible_name"

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleRole
      include Helpers

      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node)
        @node = node
      end

      def resolve
        return nil if hidden?(@node) || inert?(@node) || (aria_hidden?(@node) && !focusable?)

        role = explicit
        role ||= implicit unless presentational_child? && !focusable?
        ROLE_MAPPINGS[role] || role
      end

      private

      def role_attribute
        @node[:role].to_s.split(R_WHITE_SPACE).find do |role|
          next if role == ""

          VALID_ROLES.include?(role)
        end
      end

      def explicit
        role = role_attribute
        # if an element is focusable an explicit none/presentation is ignored
        # if an element has global states or properties none/presentation is ignored
        return nil if PRESENTATIONAL_ROLES.include?(role) && (focusable? || global_aria_attribute?)
        return nil if REQUIRES_NAME_FROM_AUTHOR_ELEMENTS.include?(role) && !accessible_name?(role)

        role
      end

      def implicit
        case @node.node_name
        when "a", "area"
          @node.has_attribute?("href") ? "link" : "generic"
        when "address", "details", "fieldset", "hgroup"
          "group"
        when "abbr", "audio", "base", "br", "canvas", "cite", "col", "colgroup", "dl", "embed", "figcaption", "head", "html", "iframe",
             "kbd", "label", "legend", "link", "map", "meta", "noscript", "object", "param", "picture", "rp", "rt", "ruby",
             "script", "slot", "source", "style", "template", "title", "track", "var", "video", "wbr"
          nil
        when "article"
          "article"
        when "aside"
          "complementary"
        when "blockquote"
          "blockquote"
        when "button"
          "button"
        when "caption"
          element_is?(@node.parent, "table") && role_is?(@node.parent, "table", "grid", "treegrid") ? "caption" : "generic"
        when "code"
          "code"
        when "datalist"
          "listbox"
        when "dd"
          "definition"
        when "del", "s"
          "deletion"
        when "dfn", "dt"
          "term"
        when "dialog"
          "dialog"
        when "em"
          "emphasis"
        when "figure"
          "figure"
        when "footer"
          sectioning_ancestor? ? "sectionfooter" : "contentinfo"
        when "form"
          accessible_name?("form") ? "form" : nil
        when "h1", "h2", "h3", "h4", "h5", "h6"
          "heading"
        when "header"
          sectioning_ancestor? ? "sectionheader" : "banner"
        when "hr"
          "separator"
        when "img"
          if !@node.has_attribute?("alt") || @node[:alt] != "" || accessible_name?("img")
            "image"
          else
            "none"
          end
        when "input"
          case @node[:type]
          when "button", "image", "file", "reset", "submit"
            "button"
          when "checkbox"
            "checkbox"
          when "color", "date", "datetime-local", "hidden", "month", "time", "week"
            nil
          when "number"
            "spinbutton"
          when "radio"
            "radio"
          when "range"
            "slider"
          when "search"
            "searchbox"
          when "password"
            # Safari and Chromium are now mapping to textbox (2025-10-27) and this is generally more useful
            "textbox"
          else
            valid_datalist? ? "combobox" : "textbox"
          end
        when "ins"
          "insertion"
        when "li"
          element_is?(@node.parent, "ul", "ol", "menu") && role_is?(@node.parent, "list") ? "listitem" : "generic"
        when "main"
          "main"
        when "mark"
          "mark"
        when "menu", "ol", "ul"
          "list"
        when "meter"
          "meter"
        when "nav"
          "navigation"
        when "optgroup"
          element_is?(@node.parent, "select") ? "group" : "generic"
        when "option"
          parent_listbox? ? "option" : nil
        when "output"
          "status"
        when "p"
          "paragraph"
        when "progress"
          "progressbar"
        when "search"
          "search"
        when "section"
          accessible_name?("section") ? "region" : nil
        when "select"
          !@node.has_attribute?("multiple") && @node[:size].to_i <= 1 ? "combobox" : "listbox"
        when "strong"
          "strong"
        when "sub"
          "subscript"
        when "sup"
          "superscript"
        when "summary"
          # Browsers do not expose these as buttons, although they currently have identical semantics
          @node.parent.node_name == "details" ? "button" : nil
        when "svg"
          # By the spec it should should be graphics-document, but image is more useful and is what Chromium returns
          "image"
        when "table"
          "table"
        when "tbody", "tfoot", "thead"
          # Some browsers require the tbody/tfoot or thead to be named to have a role
          element_is?(@node.parent, "table") && role_is?(@node.parent, "table", "grid", "treegrid") ? "rowgroup" : "generic"
        when "td"
          if element_is?(@node.parent, "tr") && role_is?(@node.parent, "row")
            parent_grid? ? "gridcell" : "cell"
          else
            "generic"
          end
        when "textarea"
          "textbox"
        when "th"
          return "generic" unless element_is?(@node.parent, "tr") && role_is?(@node.parent, "row")

          if %w[col colgroup].include?(@node[:scope])
            "columnheader"
          elsif %w[row rowgroup].include?(@node[:scope])
            "rowheader"
          elsif @node.parent.at_xpath("./td") # rubocop:disable Lint/DuplicateBranch
            "rowheader"
          else # rubocop:disable Lint/DuplicateBranch
            "columnheader"
          end
        when "time"
          "time"
        when "tr"
          if element_is?(@node.parent, "tbody", "thead", "tfoot", "table") &&
             role_is?(@node.parent, "table", "grid", "treegrid", "rowgroup")
            "row"
          else
            "generic"
          end
        else
          "generic"
        end
      end

      def global_aria_attribute?
        GLOBAL_ARIA_ATTRIBUTES.any? { @node.has_attribute?("aria-#{_1}") }
      end

      def presentational_child?
        # These should not be exposed as roles, unless focusable
        # This is however under discussion and inconsistently implemented https://github.com/w3c/aria/issues/2509
        @node.ancestors("*").any? { CHILDREN_PRESENTATIONAL_ROLES.include?(AccessibleRole.resolve(_1)) }
      end

      def accessible_name?(role)
        !AccessibleName.resolve(@node, role: role).nil?
      end

      def sectioning_ancestor?
        @node.ancestors("*").any? do |ancestor|
          role = AccessibleRole.resolve(ancestor)
          next true if SECTIONING_ROLES.include?(role)
          next false unless ancestor.node_name == "section"

          role.nil? || role == "region"
        end
      end

      def valid_datalist?
        id = @node[:list].to_s
        return false if id == ""

        !@node.document.at_xpath(XPath.anywhere(:datalist)[XPath.attribute(:id) == id].to_s).nil?
      end

      def role_is?(element, *roles)
        roles.include?(AccessibleRole.resolve(element))
      end

      def element_is?(element, *names)
        names.include?(element.node_name)
      end

      def parent_listbox?
        listbox = @node.parent
        listbox = listbox.parent if listbox.node_name == "optgroup"
        element_is?(listbox, "datalist", "select")
      end

      def parent_grid?
        table = @node.parent.parent
        table = @node.parent unless table.node_name == "table"
        role_is?(table, "grid", "treegrid")
      end

      def focusable?
        return @focusable if defined?(@focusable)

        @focusable = super(@node)
      end
    end
  end
end
