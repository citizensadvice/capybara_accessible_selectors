# frozen_string_literal: true

Capybara.add_selector(:combo_box, locator_type: [String, Symbol]) do
  label "combo box"

  xpath do |locator, allow_self: nil, **options|
    xpath = XPath.axis(allow_self ? :"descendant-or-self" : :descendant, :input)
    xpath = xpath[[
      XPath.attr(:role) == "combobox", # ARIA 1.0, ARIA 1.2
      XPath.ancestor[XPath.attr(:role) == "combobox"], # ARIA 1.1
      XPath.attr(:class).contains_word("tt-input") # DEPRECATED: Twitter typeahead
    ].reduce(:|)]
    locate_field(xpath, locator, **options)
  end

  filter_set(:_field, %i[disabled name placeholder valid])
  filter_set(:capybara_accessible_selectors, %i[aria fieldset described_by validation_error required])

  # with a value
  node_filter(:with, valid_values: [String, Regexp, Symbol]) do |node, with|
    val = node.value
    (with.is_a?(Regexp) ? with.match?(val) : val == with.to_s).tap do |res|
      add_error("Expected value to be #{with.inspect} but was #{val.inspect}") unless res
    end
  end

  # expanded or not - does not support twitter typeahead
  expression_filter(:expanded, :boolean) do |expr, value|
    expanded = XPath.attr(:"aria-expanded") == "true"
    conditions = [
      expanded,
      XPath.ancestor[XPath.attr(:role) == "combobox"][expanded]
    ]
    next expr[conditions.reduce(:|)] if value

    expr[conditions.map(&:!).reduce(:&)]
  end

  # with exact options
  node_filter(:options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil))
    match_all_options?(actual, options).tap do |res|
      add_error("Expected options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  # with parital options
  node_filter(:with_options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil))
    match_some_options?(actual, options).tap do |res|
      add_error("Expected with at least options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  # with exact enabled options
  node_filter(:enabled_options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil)) { |n| n["aria-disabled"] != "true" }
    match_all_options?(actual, options).tap do |res|
      add_error("Expected enabled options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  # with exact enabled options
  node_filter(:with_enabled_options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil)) { |n| n["aria-disabled"] != "true" }
    match_some_options?(actual, options).tap do |res|
      add_error("Expected with at least enabled options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  # with exact disabled options
  node_filter(:disabled_options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil)) { |n| n["aria-disabled"] == "true" }
    match_all_options?(actual, options).tap do |res|
      add_error("Expected disabled options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  # with exact enabled options
  node_filter(:with_disabled_options, valid_values: [Array, String, Regexp]) do |node, options|
    options = Array(options)
    actual = options_text(node, expression_for(:list_box_option, nil)) { |n| n["aria-disabled"] == "true" }
    match_some_options?(actual, options).tap do |res|
      add_error("Expected with at least disabled options #{options.inspect} found #{actual.inspect}") unless res
    end
  end

  describe_expression_filters do |expanded: nil, **|
    desc = ""
    desc += " that is#{expanded ? '' : ' not'} expanded" unless expanded.nil?
    desc
  end

  describe_node_filters do |**options|
    desc = ""
    desc += " with value #{options[:with].inspect}" if options.key?(:with)
    desc += " with options #{Array(options[:options]).inspect}" if options.key?(:options)
    desc += " with at least options #{Array(options[:with_options]).inspect}" if options.key?(:with_options)
    desc += " with enabled options #{Array(options[:enabled_options]).inspect}" if options.key?(:enabled_options)
    desc += " with at least enabled options #{Array(options[:with_enabled_options]).inspect}" if options.key?(:with_enabled_options)
    desc += " with disabled options #{Array(options[:disabled_options]).inspect}" if options.key?(:disabled_options)
    desc += " with at least disabled options #{Array(options[:with_disabled_options]).inspect}" if options.key?(:with_disabled_options)
    desc
  end

  def options_text(node, xpath, **opts, &block)
    opts[:wait] = false
    listbox = node.find(:combo_box_list_box, node, **opts)
    listbox.all(:xpath, xpath, **opts, &block).map(&:text).map { |t| t.gsub(/[[:space:]]+/, " ").strip }
  end

  def match_all_options?(actual, expected)
    actual.each_with_index.reject do |option, i|
      next expected[i].match?(option) if expected[i].is_a?(Regexp)

      expected[i] && option.include?(expected[i])
    end.empty?
  end

  def match_some_options?(actual, expected)
    actual = actual.clone
    expected.reject do |option|
      index = actual.find_index do |o|
        next option.match?(o) if option.is_a?(Regexp)

        o.include? option
      end
      next false unless index

      actual.delete_at(index)
      true
    end.empty?
  end
end

Capybara.add_selector(:combo_box_list_box, locator_type: Capybara::Node::Element) do
  xpath do |input|
    if input.matches_selector? :css, ".tt-input", wait: false
      ttmenu = XPath.attr(:class).contains_word("tt-menu")
      next XPath.descendant_or_self[XPath.attr(:class).contains_word("twitter-typeahead")].descendant[ttmenu] +
        XPath.ancestor[XPath.attr(:class).contains_word("twitter-typeahead")].descendant[ttmenu]
    end

    ids = (input[:"aria-owns"] || input[:"aria-controls"])&.split(/\s+/)&.compact

    raise Capybara::ElementNotFound, "listbox cannot be found without attributes aria-owns or aria-controls" if !ids || ids.empty?

    XPath.anywhere[[
      XPath.attr(:role) == "listbox",
      ids.map { |id| XPath.attr(:id) == id }.reduce(:|)
    ].reduce(:&)]
  end
end

Capybara.add_selector(:list_box_option, locator_type: String) do
  label "option"

  xpath do |value|
    find = (XPath.attr(:role) == "option") | XPath.attr(:class).contains_word("tt-selectable")
    find &= XPath.string.n.is(value.to_s) if value
    XPath.descendant[find]
  end

  expression_filter(:disabled, :boolean) do |expr, value|
    next expr[XPath.attr(:"aria-disabled") == "true"] if value

    expr[~(XPath.attr(:"aria-disabled") == "true")]
  end

  expression_filter(:selected, :boolean) do |expr, value|
    next expr[XPath.attr(:"aria-selected") == "true"] if value

    expr[~(XPath.attr(:"aria-selected") == "true")]
  end

  describe_expression_filters do |disabled: nil, **|
    next if disabled.nil?

    " that is #{disabled ? '' : 'not '}disabled"
  end
end

module CapybaraAccessibleSelectors
  module Actions
    # Selects an option from a combo box
    #
    # @param [String] with The option to select, or an empty string to clear the selected option
    # @option options [String] from Locator for the combo box
    # @option options [String] currently_with The current combo box selection
    # @option options [String] search Alternative search text to find the option
    # @option options [Hash] fill_options Additional driver specific fill options
    #   Option names prefixed with option_ will be used to find the option element. eg option_text
    # @yield [Capybara::Node::Element] An option considered for inclusion in the results
    # @yield [Boolean] Should the element be included
    #
    # @return [Capybara::Node::Element] The combo box
    def select_combo_box_option(with = nil, from: nil, currently_with: nil, search: with, fill_options: {}, **find_options, &block) # rubocop:disable Metrics/*
      find_options[:with] = currently_with if currently_with
      find_options[:allow_self] = true if from.nil?
      find_option_options = extract_find_option_options(find_options)
      input = find(:combo_box, from, **find_options)
      wait_options = { wait: find_options[:wait] }.compact
      if search
        input.set(search, **fill_options)
      else
        input.click
      end
      if with == ""
        # Clearing input can press the END key if the :backspace fill option is used
        # this may cause a combo box to open the list box and this can obscure other actions
        # Pressing escape will close an open listbox
        input.send_keys(:escape) if has_selector?(:combo_box_list_box, input, wait: 0)
      else
        listbox = find(:combo_box_list_box, input, **wait_options)
        option = listbox.find(:list_box_option, with, disabled: false, **find_option_options, &block)
        # Some drivers complain about clicking on a tr
        option = option.find(:css, "td", match: :first) if option.tag_name == "tr"
        # Work around occasional Chrome errors
        option.synchronize(errors: [Selenium::WebDriver::Error::ElementNotInteractableError]) { option.click }
      end
      input
    end

    def extract_find_option_options(options)
      found = { wait: options[:wait] }
      options.each_key do |name|
        found[:"#{name.to_s[7..]}"] = options.delete(name) if name.to_s.start_with?("option_")
      end
      found.compact
    end
  end
end
