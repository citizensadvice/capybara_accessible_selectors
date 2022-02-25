# frozen_string_literal: true

Capybara.add_selector(:rich_text, locator_type: [String, Symbol, Array]) do
  xpath do |locator, *|
    XPath.descendant[[
      XPath.attribute(:role) == "textbox",
      XPath.attribute(:contenteditable) == "true"
    ].reduce(:&)] + XPath.descendant(:iframe)[XPath.attr(:title).is(locator.to_s)]
  end

  filter_set(:capybara_accessible_selectors, %i[focused fieldset described_by validation_error])

  locator_filter do |node, locator, exact:, **|
    next true if locator.nil?

    *, locator = locator if locator.is_a? Array
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
    else
      node.tag_name == "iframe"
    end
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Fill in a rich text area with text
    #
    # @param [String] locator Rich text label
    # @param [Hash] find_options Finder options
    # @option options [String] :with The text to use
    def fill_in_rich_text(locator, with:, clear: true, **find_options)
      input = find(:rich_text, locator, **find_options)
      with = nil if with == ""
      if input.tag_name == "iframe"
        fill_in_iframe_rich_text(input, with, clear)
      else
        # TODO: Bug in current Chromium, select all does not work https://bugs.chromium.org/p/chromedriver/issues/detail?id=3214&q=sendKeys&can=2
        input.send_keys :backspace while input.text != "" && clear
        input.send_keys with
      end
    end

    # Limit supplied block to within a rich text editable area
    #
    # @param [String] locator Rich text label
    # @param [Hash] find_options Finder options
    def within_rich_text(locator = nil, **find_options, &)
      if is_a? Capybara::Node::Element
        return Capybara.page.within self do
          return Capybara.page.within_frame(self, &) if tag_name == "iframe"
          return yield if matches_selector?(:rich_text, wait: false)

          Capybara.page.within_rich_text(locator, **find_options, &)
        end
      end
      within_iframe_rich_text(locator, **find_options, &)
    end

    private

    def fill_in_iframe_rich_text(frame, text, clear)
      within_frame frame do
        editable = page.find(:css, "[contenteditable=true]")
        return if text == editable.text

        editable.send_keys :backspace while editable.text != "" && clear
        editable.send_keys text
      end
    end

    def within_iframe_rich_text(locator, **find_options, &)
      within(:rich_text, locator, **find_options) do
        return within_frame(current_scope, &) if current_scope.tag_name == "iframe"

        yield
      end
    end
  end
end
