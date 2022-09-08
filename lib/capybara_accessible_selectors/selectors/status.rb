# frozen_string_literal: true

Capybara.add_selector(:status) do
  xpath do |locator, *|
    XPath.descendant[XPath.attr(:role) == "status"][XPath.string.is(locator.to_s)]
  end
end
