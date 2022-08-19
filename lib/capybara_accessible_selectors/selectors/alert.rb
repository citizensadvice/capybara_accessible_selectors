# frozen_string_literal: true

Capybara.add_selector(:alert) do
  xpath do |locator, *|
    XPath.descendant[XPath.attr(:role) == "alert"][XPath.string.n.is(locator.to_s)]
  end
end
