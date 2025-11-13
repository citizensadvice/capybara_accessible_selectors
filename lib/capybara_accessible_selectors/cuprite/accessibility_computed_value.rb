# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Cuprite
    class AccessibilityComputedValue
      def self.resolve(...)
        new(...).resolve
      end

      def initialize(node, name)
        @node = node
        @name = name
      end

      def resolve
        accessibility_tree_node.dig(@name, "value")
      end

      protected

      def accessibility_tree_node
        @accessibility_tree_node ||= @node.browser.page
                                          .command("Accessibility.getPartialAXTree", nodeId: @node.node.node_id, fetchRelatives: true)["nodes"]
                                          .first { |n| n["ignored"] == false } || {}
      end
    end
  end
end
