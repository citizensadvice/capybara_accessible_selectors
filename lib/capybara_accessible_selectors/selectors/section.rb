# frozen_string_literal: true

Capybara.add_selector(:section) do
  xpath do |locator, heading_level: (1..6), section_element: %i[section article aside footer header main form], **|
    # the nil function is to wrap the condition in brackets
    heading = XPath.function(nil, XPath.descendant(*Array(heading_level).map { |i| :"h#{i}" }))[1][XPath.string.n.is(locator)]
    XPath.descendant(*Array(section_element).map(&:to_sym))[heading]
  end
end
