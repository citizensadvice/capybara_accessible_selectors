# frozen_string_literal: true

require "capybara_accessible_selectors/nokogiri/accessible_description"

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
      CapybaraAccessibleSelectors::Helpers.element_description(self)
    end
  end

  module RackTestNodeExtensions
    def accessible_description
      Nokogiri::AccessibleDescription.resolve(native) || ""
    end
  end
end
