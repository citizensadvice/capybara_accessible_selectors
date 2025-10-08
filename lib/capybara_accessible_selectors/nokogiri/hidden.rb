# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    class Hidden
      def self.resolve?(node, **)
        new(node).resolve?(**)
      end

      def initialize(node)
        @node = node
      end

      def resolve?(visibility_override: false)
        @node.has_attribute?("hidden") ||
          @node.has_attribute?("inert") ||
          invisible? ||
          (!visibility_override && invisible?) ||
          parent_hidden(visibility_override) ||
          false
      end

      private

      def display_none?
        @node[:style]&.match?(/display:\s*none/)
      end

      def invisible?
        @node[:style]&.match?(/visibility:\s*(hidden|collapse)/)
      end

      def revisible?
        @node[:style]&.match?(/visibility:\s*(visible)/)
      end

      def parent_hidden(visibility_override)
        @node.parent && @node.parent.type == ::Nokogiri::XML::Node::ELEMENT_NODE && Hidden.resolve?(
          @node.parent,
          visibility_override: visibility_override || revisible?
        )
      end
    end
  end
end
