# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module Nokogiri
    module Helpers
      R_WHITE_SPACE = /[\t\n\r\f ]+/
      ROLE_MAPPINGS = {
        "presentation" => "none", # none is preferred since aria 1.1
        "img" => "image", # browsers prefer "image"
        "directory" => "list" # deprecated in aria 1.2
      }.freeze
      PRESENTATIONAL_ROLES = %w[none presentation].freeze
    end
  end
end
