# frozen_string_literal: true

Capybara.add_selector(:item, locator_type: [String, Symbol]) do
  css do |locator, **|
    "[itemprop~=\"#{locator}\"]"
  end

  expression_filter(:type, valid_values: [String, Symbol, Array]) do |css, types|
    Array(types).map do |type|
      "[itemscope][itemtype~=\"#{type}\"]"
    end.join(" ") + " #{css}"
  end

  describe_expression_filters do |type: nil, **|
    " within scope#{type.is_a?(Array) ? 's' : ''} #{Array(type).join(', ')}" if type
  end
end

Capybara.add_selector(:item_type, locator_type: [String, Symbol]) do
  css do |locator, **|
    "[itemscope][itemtype~=\"#{locator}\"]"
  end
end
