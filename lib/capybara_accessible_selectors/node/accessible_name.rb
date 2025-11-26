# frozen_string_literal: true

require "capybara_accessible_selectors/cuprite/accessibility_computed_value"
require "capybara_accessible_selectors/nokogiri/accessible_name"

module CapybaraAccessibleSelectors
  module DriverNodeExtensions
    def accessible_name
      raise NotImplementedError
    end
  end

  module NodeElementExtensions
    def accessible_name
      synchronize { base.accessible_name }
    end
  end

  module CupriteNodeExtensions
    def accessible_name
      Cuprite::AccessibilityComputedValue.resolve(native, "name") || ""
    end
  end

  module SeleniumNodeExtensions
    def accessible_name
      # Safari is not returning a flat string
      native.accessible_name.to_s.strip.gsub(/\s+/, " ")
    rescue ::Selenium::WebDriver::Error::UnknownError
      # Safari can throw this
      ""
    end
  end

  module RackTestNodeExtensions
    def accessible_name
      Nokogiri::AccessibleName.resolve(native) || ""
    end
  end
end
