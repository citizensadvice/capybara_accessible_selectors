# frozen_string_literal: true

Capybara.add_selector(:combo_box, locator_type: [String, Symbol]) do
  label "combo box"

  xpath do |locator, allow_self: nil, **options|
    xpath = XPath.axis(allow_self ? :"descendant-or-self" : :descendant, :input)
    xpath = xpath[[
      XPath.attr(:role) == "combobox", # ARIA 1.0
      XPath.ancestor[XPath.attr(:role) == "combobox"], # ARIA 1.1
      XPath.attr(:class).contains_word("tt-input") # DEPRECATED: Twitter typeahead
    ].reduce(:|)]
    locate_field(xpath, locator, options)
  end

  filter_set(:_field, %i[disabled name placeholder valid])
  filter_set(:capybara_accessible_selectors, %i[focused fieldset described_by validation_error])

  node_filter(:with) do |node, with|
    val = node.value
    (with.is_a?(Regexp) ? with.match?(val) : val == with.to_s).tap do |res|
      add_error("Expected value to be #{with.inspect} but was #{val.inspect}") unless res
    end
  end

  describe_node_filters do |**options|
    " with value #{options[:with].to_s.inspect}" if options.key?(:with)
  end
end

Capybara.add_selector(:combo_box_list_box, locator_type: Capybara::Node::Element) do
  xpath do |input|
    next XPath.anywhere[XPath.attr(:class).contains_word("tt-menu")] if input.matches_selector? :css, ".tt-input", wait: false

    XPath.anywhere[[
      XPath.attr(:role) == "listbox",
      XPath.attr(:id) == (input[:"aria-owns"] || input[:"aria-controls"])
    ].reduce(:&)]
  end
end

Capybara.add_selector(:list_box_option, locator_type: String) do
  xpath do |value|
    find = (XPath.attr(:role) == "option") | XPath.attr(:class).contains_word("tt-selectable")
    find &= XPath.string.n.is(value) if value
    XPath.descendant[find]
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Selects an option from a combo box
    #
    # @param [String] with The option to select
    # @option options [String] from Locator for the combo box
    # @option options [String] currently_with The current combo box selection
    # @option options [String] search Alternative search text to find the option
    # @option options [Hash] fill_options Additional driver specific fill options
    #
    # Option names prefixed with option_ will be used to find the option element. eg option_text
    #
    # @return [Capybara::Node::Element] The combo box
    def select_combo_box_option(with = nil, from: nil, currently_with: nil, search: with, fill_options: {}, **find_options) # rubocop:disable Metrics/ParameterLists
      find_options[:with] = currently_with if currently_with
      find_options[:allow_self] = true if from.nil?
      find_option_options = extract_find_option_options(find_options)
      input = find(:combo_box, from, find_options)
      input.set(search, fill_options)
      unless input.matches_selector? :css, "[aria-controls],[aria-owns],.tt-input", wait: false
        raise Capybara::ExpectationNotMet, "input must use aria-controls or aria-owns"
      end

      listbox = find(:combo_box_list_box, input)
      option = listbox.find(:list_box_option, with, **find_option_options)
      option.click
      input
    end

    def extract_find_option_options(options)
      found = {}
      options.each_key do |name|
        found[:"#{name.to_s[7..-1]}"] = options.delete(name) if name.to_s.start_with?("option_")
      end
      found
    end
  end
end
