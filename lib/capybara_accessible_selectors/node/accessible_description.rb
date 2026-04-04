# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/accessible_description"
require "capybara_accessible_selectors/selenium/accessible_description"

module CapybaraAccessibleSelectors
  module DriverNodeExtensions
    def accessible_description
      raise NotImplementedError
    end
  end

  module NodeElementExtensions
    def accessible_description
      synchronize { base.accessible_description }
    end
  end

  module SeleniumNodeExtensions
    def accessible_description
      Selenium::AccessibleDescription.resolve(self) || ""
    end
  end

  module RackTestNodeExtensions
    def accessible_description
      Nokogiri::AccessibleDescription.resolve(native) || ""
    end
  end

  module CupriteNodeExtensions
    def accessible_description
      # The accname-1.2 description algorithm is driver-agnostic (it only uses
      # the generic Capybara node API), so reuse it instead of Chrome's raw
      # computed description, keeping results consistent with Selenium
      Selenium::AccessibleDescription.resolve(self) || ""
    end
  end
end
