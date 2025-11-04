# frozen_string_literal: true

# Finds an element by its test id
# This requires Capybara.test_id to be set
#
# This is the equivalent of `find :xpath, '//*[@data-test-id="my_id"]'`
# Its only benefit is a clearer intent
#
Capybara.add_selector :test_id, locator_type: [String, Symbol] do
  xpath do |locator|
    raise "Capybara.test_id must be set" unless Capybara.test_id

    XPath.descendant_or_self[XPath.attr(Capybara.test_id.to_sym) == locator.to_s]
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Find an element by the attribute set in `Capybara.test_id`.
    #
    # @param [String|Symbol] id The value to search for
    #
    # @return [Capybara::Node::Element]
    def find_by_test_id(id, **)
      find(:test_id, id, **)
    end
  end
end
