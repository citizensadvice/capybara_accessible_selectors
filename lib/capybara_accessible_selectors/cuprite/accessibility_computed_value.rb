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

      # NOTE: name/description/role are each resolved by a separate
      # instance, so this issues one getPartialAXTree call per lookup.
      # Batching the three into a single CDP request is left as a future
      # optimisation. Degrades to {} on a missing tree or a CDP/node
      # error, mirroring the Selenium path's rescue behaviour.
      def accessibility_tree_node
        ferrum_node = @node.node
        nodes = ferrum_node.page.command("Accessibility.getPartialAXTree",
                                         nodeId: ferrum_node.node_id,
                                         fetchRelatives: false)["nodes"]
        Array(nodes).find { |n| n["ignored"] == false } || {}
      rescue ::Ferrum::Error
        {}
      end
    end
  end
end
