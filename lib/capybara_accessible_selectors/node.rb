# frozen_string_literal: true

module CapybaraAccessibleSelectors
  module DriverNodeExtensions; end
  module NodeElementExtensions; end
  module SeleniumNodeExtensions; end
  module RackTestNodeExtensions; end

  ::Capybara::Driver::Node.include DriverNodeExtensions
  ::Capybara::Node::Element.include NodeElementExtensions
  ::Capybara::Selenium::Node.include SeleniumNodeExtensions
  ::Capybara::RackTest::Node.include RackTestNodeExtensions
  ::Capybara::Node::Simple.include RackTestNodeExtensions
end

require "capybara_accessible_selectors/node/accessible_name"
require "capybara_accessible_selectors/node/role"
