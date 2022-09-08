# frozen_string_literal: true

Capybara.add_selector(:grid, locator_type: [String, Symbol]) do
  xpath do |*|
    XPath.descendant[XPath.attr(:role) == "grid"]
  end

  locator_filter skip_if: nil do |node, locator, exact:, **|
    method = exact ? :eql? : :include?
    if node[:"aria-labelledby"]
      CapybaraAccessibleSelectors::Helpers.element_labelledby(node).public_send(method, locator)
    elsif node[:"aria-label"]
      node[:"aria-label"].public_send(method, locator.to_s)
    end
  end

  node_filter(:described_by, valid_values: String) do |node, value|
    if node.tag_name == "table" && node.has_css?("caption") && (caption = node.find("caption")) && caption.text.include?(value)
      true
    else
      next false unless node[:"aria-describedby"]

      description = CapybaraAccessibleSelectors::Helpers.element_describedby(node)
      next true if description.include? value

      add_error " expected to be described by \"#{value}\" but it was described by \"#{description}\"."
      false
    end
  end
end

Capybara.add_selector(:columnheader, locator_type: [String, Symbol]) do
  xpath do |locator|
    columnheader = XPath.descendant[(XPath.local_name == "th") | (XPath.attr(:role) == "columnheader")]

    if locator
      columnheader[XPath.string.n.is(locator.to_s)]
    else
      columnheader
    end
  end

  expression_filter(:colindex, [Integer, String], skip_if: nil) do |xpath, value|
    colindex = XPath.attr(:"aria-colindex") == value.to_s
    position = (!XPath.attr(:"aria-colindex")) & (XPath.local_name == "th") & (XPath.position == value.to_i - 1)

    xpath[colindex | position]
  end
end

# rubocop:disable Metrics/BlockLength
Capybara.add_selector(:gridcell, locator_type: [String, Symbol]) do
  xpath do |locator|
    gridcell = XPath.descendant[(XPath.local_name == "td") | (XPath.attr(:role) == "gridcell")]

    if locator
      gridcell[XPath.string.n.is(locator.to_s)]
    else
      gridcell
    end
  end

  expression_filter(:colindex, [Integer, String], skip_if: nil) do |xpath, value|
    row_ancestor = XPath.ancestor[(XPath.attr(:role) == "row") | (XPath.local_name == "tr")]
    colindex = row_ancestor & (XPath.attr(:"aria-colindex") == value.to_s)
    position = row_ancestor & (!XPath.attr(:"aria-colindex")) & (XPath.position == value.to_i)

    xpath[colindex | position]
  end

  node_filter(:rowindex, [Integer, String], skip_if: nil) do |gridcell, value|
    if gridcell.has_ancestor?(:row)
      row = gridcell.ancestor(:row)

      if row.has_selector?(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"])
        grid = row.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"])

        grid.find(:row, rowindex: value) == row
      else
        false
      end
    else
      false
    end
  end

  node_filter(:columnheader, [String, Symbol], skip_if: nil) do |node, value|
    colindex = node[:"aria-colindex"] || node.ancestor(:row).all(:gridcell).index(node)
    grid = node.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"])

    grid.has_selector?(:columnheader, value, colindex: colindex)
  end
end
# rubocop:enable Metrics/BlockLength

Capybara.add_selector(:row, locator_type: [String, Symbol]) do
  xpath do |locator|
    row = XPath.descendant[(XPath.local_name == "tr") | (XPath.attr(:role) == "row")]

    if locator
      row[XPath.string.n.is(locator.to_s)]
    else
      row
    end
  end

  node_filter(:rowindex, [Integer, String], skip_if: nil) do |row, value|
    case row[:"aria-rowindex"]
    when value.to_s then true
    when NilClass
      if row.has_selector?(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"])
        grid = row.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"])

        grid.all(:row).index(row) == value.to_i - 1
      else
        false
      end
    end
  end
end

module CapybaraAccessibleSelectors
  module Session
    # Limit supplied block to within a columnheader
    #
    # @param [String] Name Columnheader label
    # @param [Hash] options Finder options
    def within_columnheader(*arguments, **options, &block)
      within(:columnheader, *arguments, **options, &block)
    end

    # Limit supplied block to within a grid
    #
    # @param [String] Name Grid label
    # @param [Hash] options Finder options
    def within_grid(*arguments, **options, &block)
      within(:grid, *arguments, **options, &block)
    end

    # Limit supplied block to within a gridcell
    #
    # @param [String] Name Gridcell label
    # @param [Hash] options Finder options
    def within_gridcell(*arguments, **options, &block)
      within(:gridcell, *arguments, **options, &block)
    end

    # Limit supplied block to within a row
    #
    # @param [String] Name Row label
    # @param [Hash] options Finder options
    def within_row(*arguments, **options, &block)
      within(:row, *arguments, **options, &block)
    end
  end
end
