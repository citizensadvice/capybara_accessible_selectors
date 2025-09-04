# frozen_string_literal: true

Capybara.add_selector(:disclosure) do
  def aria_or_real_button
    XPath.self(:button) | (XPath.attr(:role) == "button")
  end

  xpath do |name = nil, **|
    # Any summary and details
    summary = XPath.child(:summary)
    summary = summary[XPath.string.n.is(name.to_s)] if name
    details = XPath.descendant(:details)[summary]

    # Find the ids of buttons with `aria-expanded`
    button = aria_or_real_button
    button &= XPath.string.n.is(name.to_s) if name
    button = XPath.anywhere[button][XPath.attr(:"aria-expanded")][XPath.attr(:"aria-controls")]
    # Preload the ids in a separate operation as xpath dynamic selectors are SLOW
    ids = Capybara.page.all(:xpath, button, wait: false).map { _1[:"aria-controls"] }

    if ids.any?
      aria = XPath.descendant[ids.map { XPath.attr(:id) == _1 }.reduce(:|)]
      aria + details
    else
      details
    end
  end

  expression_filter(:expanded, :boolean) do |xpath, expanded|
    open = expanded ? XPath.attr(:open) : !XPath.attr(:open)
    button = XPath.anywhere[aria_or_real_button][XPath.attr(:"aria-expanded") == expanded.to_s]
    xpath[open | (button.attr(:"aria-controls") == XPath.attr(:id))]
  end

  node_filter(:accessible_name, valid_values: [String, Regexp], skip_nil: true) do |node, value|
    # As a disclosure isn't actually named, we need to re-find the button
    button = node.first(:element, :summary, wait: false) if node.tag_name == "details"
    unless button
      id = node[:id]
      return false unless id

      button = node.first(
        :xpath,
        XPath.anywhere[XPath.self(:button) | XPath.attr(:role) == "button"][XPath.attr(:"aria-controls") == id]
      )
    end
    next false unless button

    case value
    when String
      button.accessible_name.include?(value)
    when Regexp
      value.match?(button.accessible_name)
    end
  end

  describe_expression_filters do |expanded: nil, **|
    next if expanded.nil?

    expanded ? " expanded" : " closed"
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

# Specifically selects the disclosure button
#
# find(:disclosure_button, "name").click
Capybara.add_selector(:disclosure_button) do
  xpath do |name, **|
    XPath.descendant[[
      (XPath.self(:button) | (XPath.attr(:role) == "button")),
      XPath.attr(:"aria-expanded"),
      XPath.string.n.is(name.to_s)
    ].reduce(:&)] + XPath.descendant(:summary)[XPath.string.n.is(name.to_s)]
  end

  expression_filter(:expanded, :boolean) do |xpath, expanded|
    open = expanded ? XPath.parent.attr(:open) : !XPath.parent.attr(:open)
    xpath[(XPath.attr(:"aria-expanded") == expanded.to_s) | open]
  end

  describe_expression_filters do |expanded: nil, **|
    next if expanded.nil?

    expanded ? " expanded" : " closed"
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end

module CapybaraAccessibleSelectors
  module Actions
    # Toggle a disclosure open or closed
    #
    # An optional block will be run in the disclosure context
    #
    # @param [String] locator The text of the button
    # @option options [Boolean] expand Set true to open, false to close, or nil to toggle
    #
    # @return [Capybara::Node::Element] The element clicked
    def toggle_disclosure(name = nil, expand: nil, **find_options, &block)
      button = _locate_disclosure_button(name, **find_options)
      _toggle_disclosure_button(button, expand)

      if block
        if is_a?(Capybara::Node::Element) && name.nil?
          Capybara.page.within(_locate_disclosure(name, **find_options), &block)
        else
          Capybara.page.within_disclosure(name, **find_options, &block)
        end
      end
      button
    end

    # Find and return a disclosure, opening it if not already open
    #
    # An optional block will be run in the disclosure context
    #
    # @param [String] locator The text of the button
    #
    # @return [Capybara::Node::Element] The disclosure
    def select_disclosure(name = nil, **find_options, &block)
      button = _locate_disclosure_button(name, **find_options)
      _toggle_disclosure_button(button, true)

      if block
        if is_a?(Capybara::Node::Element) && name.nil?
          Capybara.page.within(_locate_disclosure(name, **find_options), &block)
        else
          Capybara.page.within_disclosure(name, **find_options, &block)
        end
      else
        _locate_disclosure(name, **find_options)
      end
    end

    private

    def _locate_disclosure_button(name, **find_options)
      if is_a?(Capybara::Node::Element) && name.nil?
        return self if matches_selector?(:disclosure_button, wait: false)
        return find(:element, :summary, **find_options) if tag_name == "details"
        if matches_selector?(:disclosure, wait: false)
          return find(:xpath, XPath.anywhere[XPath.attr(:"aria-controls") == self[:id]], **find_options)
        end
      end
      find(:disclosure_button, name, **find_options)
    end

    def _locate_disclosure(name, **find_options)
      if is_a?(Capybara::Node::Element) && name.nil?
        return self if matches_selector?(:disclosure, wait: false)
        return find(:xpath, "..") if tag_name == "summary"
        if matches_selector?(:disclosure_button, wait: false)
          return find(:xpath, XPath.anywhere[XPath.attr(:id) == self[:"aria-controls"]], visible: :all, **find_options)
        end
      end
      find(:disclosure, name, **find_options)
    end

    def _toggle_disclosure_button(button, expand)
      if expand.nil?
        button.click
      elsif button.tag_name == "summary"
        button.click if button.find(:xpath, "..")[:open] != expand.to_s
      elsif button[:"aria-expanded"] != (expand ? "true" : "false") # rubocop:disable Lint/DuplicateBranch
        button.click
      end
    end
  end

  module Session
    # Limit supplied block to within a disclosure
    #
    # @param [String] Name Fieldset label
    # @param [Hash] options Finder options
    def within_disclosure(...)
      within(:disclosure, ...)
    end
  end
end
