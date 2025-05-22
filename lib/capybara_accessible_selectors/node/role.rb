# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module DriverNodeExtensions
    def role
      raise NotImplementedError
    end
  end

  module NodeElementExtensions
    def role
      synchronize { base.role }.then do |role|
        # generic is an implementation detail not exposed to users
        # none/presentation is an instruction to remove the implicit role and not exposed to users
        next nil if %w[generic none presentation].include?(role)

        role
      end
    end
  end

  module SeleniumNodeExtensions
    def role
      resolved = native.aria_role
      # Chrome returns non-standard internal identifiers for elements without mapped roles
      # These are always in PascalCase so ignore roles with capital letters
      return "math" if resolved == "MathMLMath"
      return nil if resolved&.match?(/[A-Z]/)

      resolved == "" ? nil : resolved
    rescue ::Selenium::WebDriver::Error::UnknownError
      # Safari can throw this
      nil
    end
  end

  ::Capybara::Driver::Node.include DriverNodeExtensions
  ::Capybara::Node::Element.include NodeElementExtensions
  ::Capybara::Selenium::Node.include SeleniumNodeExtensions
end
