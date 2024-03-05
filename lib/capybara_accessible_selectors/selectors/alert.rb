# frozen_string_literal: true

Capybara.add_selector(:alert) do
  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "alert"]
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
