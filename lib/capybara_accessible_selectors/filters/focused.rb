# frozen_string_literal: true

Capybara::Selector::FilterSet[:capybara_accessible_selectors].instance_eval do
  node_filter(:focused, :boolean) do |node, value|
    if value
      Capybara.evaluate_script("document.activeElement === arguments[0]", node)
    else
      Capybara.evaluate_script("document.activeElement !== arguments[0]", node)
    end
  end

  describe(:node_filters) do |**options|
    " that is focused" if options[:focused]
  end
end
