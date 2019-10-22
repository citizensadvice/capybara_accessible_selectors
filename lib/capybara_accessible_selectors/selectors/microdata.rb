# frozen_string_literal: true

Capybara.add_selector(:item, locator_type: [String, Symbol]) do
  xpath do |locator, **|
    XPath.descendant[XPath.attr(:itemprop) == locator.to_s]
  end

  expression_filter(:type, valid_values: [String, Symbol, Array]) do |xpath, types|
    Array(types).reverse.reduce(xpath) do |current_xpath, type|
      XPath.descendant_or_self[[
        XPath.attribute(:itemscope),
        XPath.attribute(:itemtype) == type.to_s
      ].reduce(:&)].descendant(current_xpath)
    end
  end

  describe_expression_filters do |type: nil, **|
    " within scope#{type.is_a?(Array) ? 's' : ''} #{Array(type).join(', ')}" if type
  end
end
