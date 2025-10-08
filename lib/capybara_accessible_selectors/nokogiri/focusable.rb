# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/hidden"

module CapybaraAccessibleSelectors
  module Nokogiri
    class Focusable
      R_INTEGER = /\A[+-]?[0-9]+\z/

      def self.resolve?(...)
        new(...).resolve?
      end

      attr_reader :node

      def initialize(node)
        @node = node
      end

      def resolve? # rubocop:disable Metrics
        return false if Hidden.resolve?(node)

        # Overflowing scrollable elements are also focusable in some browsers, but not in rack test
        tabindex? ||
          (%w[button select textarea].include?(node.node_name) && !node.has_attribute?("disabled")) ||
          (node.node_name == "input" && !node.has_attribute?("disabled") && node[:type] != "hidden") ||
          (%w[a area].include?(node.node_name) && node.has_attribute?("href")) ||
          %w[object iframe].include?(node.node_name) ||
          (%w[video audio].include?(node.node_name) && node.has_attribute?("controls")) ||
          (node.node_name == "summary" && node.parent.node_name == "details") ||
          ["", "true", "plaintext-only"].include?(node[:contenteditable])
      end

      private

      def tabindex?
        node[:tabindex]&.strip&.match?(R_INTEGER)
      end
    end
  end
end
