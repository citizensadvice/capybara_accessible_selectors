# frozen_string_literal: true

%i[field xpath css button link link_or_button fillable_field radio_button checkbox select file_field element].each do |selector|
  Capybara.modify_selector(selector) do
    node_filter(:focused, :boolean) do |node, value|
      if value
        Capybara.evaluate_script("document.activeElement === arguments[0]", node)
      else
        Capybara.evaluate_script("document.activeElement !== arguments[0]", node)
      end
    end

    describe_node_filters do |**options|
      " that is focused" if options[:focused]
    end
  end
end
