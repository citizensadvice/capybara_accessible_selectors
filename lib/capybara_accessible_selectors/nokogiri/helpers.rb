# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    module Helpers
      R_WHITE_SPACE = /[\t\n\r\f ]+/
      R_INTEGER = /\A[+-]?[0-9]+\z/

      VALID_ROLES = %w[button checkbox gridcell link menuitem menuitemcheckbox menuitemradio option progressbar radio scrollbar searchbox
                       separator slider spinbutton switch tab tabpanel textbox treeitem combobox grid listbox menu menubar
                       radiogroup tablist tree treegrid application article blockquote caption cell code columnheader
                       comment definition deletion directory document emphasis feed figure generic group heading img image insertion
                       list listitem mark math meter none note paragraph presentation row rowgroup rowheader sectionfooter sectionheader
                       separator strong subscript suggestion superscript table term time toolbar tooltip banner complementary
                       contentinfo form main navigation region search alert log marquee status timer alertdialog dialog].freeze
      PRESENTATIONAL_ROLES = %w[none presentation].freeze
      CHILDREN_PRESENTATIONAL_ROLES = %w[button checkbox img image menuitemcheckbox menuitemradio meter option
                                         progressbar radio scrollbar separator slider switch tab].freeze
      SECTIONING_ROLES = %w[main article complementary navigation].freeze
      NAME_FROM_CONTENT_ROLES = %w[button cell checkbox columnheader comment gridcell heading link menuitem menuitemcheckbox
                                   menuitemradio option radio row rowheader switch tab tooltip treeitem].freeze
      NAME_DISALLOWED_ROLES = %w[caption code definition deletion emphasis generic insertion mark
                                 none paragraph strong subscript suggestion superscript term time presentation].freeze
      ROLE_MAPPINGS = {
        "presentation" => "none", # none is preferred since aria 1.1
        "img" => "image", # browsers prefer "image"
        "directory" => "list" # deprecated in aria 1.2
      }.freeze

      GLOBAL_ARIA_ATTRIBUTES = %w[atomic braillelabel brailleroledescription busy controls current describedby description details
                                  dropeffect flowto grabbed hidden keyshortcuts label labelledby live owns relevant roledescription].freeze

      REQUIRES_NAME_FROM_AUTHOR_ELEMENTS = %w[form region].freeze
      HIDDEN_ELEMENTS = %w[template script head style link meta base param source track].freeze
      BLOCK_ELEMENTS = %w[p h1 h2 h3 h4 h5 h6 ol ul pre address blockquote dl div fieldset form hr noscript table input textarea select
                          button img td th].freeze

      def hidden?(node)
        visibility = nil
        [node, *node.ancestors("*")].any? do |n|
          visibility ||= n[:style].to_s[/\bvisibility:\s?(visible|hidden|collapse)\b/, 1]
          HIDDEN_ELEMENTS.include?(n.node_name) ||
            n.has_attribute?("hidden") ||
            /\bdisplay:\s?none\b/.match?(n[:style]) ||
            (visibility && visibility != "visible")
        end
      end

      def inert?(node)
        [node, *node.ancestors("*")].any? { _1.has_attribute?("inert") }
      end

      def aria_hidden?(node)
        [node, *node.ancestors("*")].any? { _1[:"aria-hidden"] == "true" }
      end

      def focusable?(node)
        # Overflowing scrollable elements are also focusable in some browsers, but not in rack test
        node[:tabindex]&.strip&.match?(R_INTEGER) ||
          (%w[button select textarea].include?(node.node_name) && !node.has_attribute?("disabled")) ||
          (node.node_name == "input" && !node.has_attribute?("disabled") && node[:type] != "hidden") ||
          (%w[a area].include?(node.node_name) && node.has_attribute?("href")) ||
          %w[object iframe].include?(node.node_name) ||
          (%w[video audio].include?(node.node_name) && node.has_attribute?("controls")) ||
          (node.node_name == "summary" && node.parent.node_name == "details") ||
          ["", "true", "plaintext-only"].include?(node[:contenteditable])
      end
    end
  end
end
