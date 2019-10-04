# frozen_string_literal: true

Capybara.add_selector(:modal) do
  xpath do |name|
    label = XPath.descendant[XPath.string.n.is(name)]
    XPath.descendant[[
      XPath.attr(:"aria-modal") == "true",
      (XPath.attr(:role) == "dialog") | (XPath.attr(:role) == "alertdialog"),
      XPath.attr(:"aria-labelledby") == label.attr(:id)
    ].reduce(:&)]
  end
end
