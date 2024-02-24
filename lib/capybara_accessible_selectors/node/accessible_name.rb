# frozen_string_literal: true

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

  module SeleniumNodeExtensions
    def accessible_name
      native.accessible_name&.strip || ""
    end
  end

  ::Capybara::Driver::Node.include DriverNodeExtensions
  ::Capybara::Node::Element.include NodeElementExtensions
  ::Capybara::Selenium::Node.include SeleniumNodeExtensions
end
