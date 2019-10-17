# frozen_string_literal: true

Capybara.add_selector(:rich_text, locator_type: [String, Symbol]) do
  xpath do |locator, *|
    XPath.descendant[[
      XPath.attribute(:role) == "textbox",
      XPath.attribute(:contenteditable) == "true"
    ].reduce(:&)] + XPath.descendant(:iframe)[XPath.attr(:title).is(locator.to_s)]
  end

  locator_filter do |node, locator|
    next true if locator.nil?

    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).include?(locator)
    elsif node[:"aria-label"]
      node[:"aria-label"] == locator.to_s
    else
      node.tag_name == "iframe"
    end
  end
end

module CapybaraAccessibleSelectors
  module Actions
    def fill_in_rich_text(locator, with:, **find_options)
      input = find(:rich_text, locator, find_options)
      with = nil if with == ""
      if input.tag_name == "iframe"
        within_frame input do
          page.execute_script("document.execCommand('selectAll',false,null)")
          page.find(:css, "[contenteditable=true]").send_keys with || :backspace
        end
      else
        page.execute_script("document.execCommand('selectAll',false,null)")
        input.send_keys with || :backspace
      end
    end
  end
end
