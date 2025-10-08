# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    class AccessibleRole
      R_WHITE_SPACE = /[\t\n\r\f ]+/
      PRESENTATION = %w[none presentation].freeze

      def initialize(node)
        @node = node
      end

      def accessible_role
        role = explicit || implict
        return if PRESENTATION.include?(role)

        role
      end

      private

      def explicit
        @node[:role]&.downcase&.split(R_WHITE_SPACE)&.find do |role|
          ROLES.include?(role)
        end
      end

      def implicit
        case @node.node_name
        end
      end
    end
  end
