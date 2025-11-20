# frozen_string_literal: true

CapybaraAccessibleSelectors.add_role_selector(:grid, within: true)

CapybaraAccessibleSelectors.add_role_selector(:columnheader, within: true, content_fallback: true) do
  expression_filter(:colindex, valid_values: Integer, skip_if: nil) do |xpath, value|
    colindex = XPath.attr(:"aria-colindex") == value.to_s
    position = (!XPath.attr(:"aria-colindex")) & (XPath.local_name == "th") & (XPath.position == value.to_i)

    xpath[colindex | position]
  end
end

CapybaraAccessibleSelectors.add_role_selector(:gridcell, within: true, content_fallback: true) do
  expression_filter(:colindex, valid_values: Integer, skip_if: nil) do |xpath, value|
    row_ancestor = XPath.ancestor[(XPath.attr(:role) == "row") | (XPath.local_name == "tr")]
    colindex = row_ancestor & (XPath.attr(:"aria-colindex") == value.to_s)
    position = row_ancestor & !XPath.attr(:"aria-colindex") & (XPath.position == value.to_i)

    xpath[colindex | position]
  end

  node_filter(:rowindex, valid_values: Integer, skip_if: nil) do |gridcell, value|
    if gridcell.has_ancestor?(:row)
      row = gridcell.ancestor(:row)

      if row.has_selector?(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"], wait: false)
        grid = row.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"], wait: false)

        grid.find(:row, rowindex: value) == row
      else
        false
      end
    else
      false
    end
  end

  node_filter(:columnheader, valid_values: [String, Symbol], skip_if: nil) do |node, value|
    colindex = node[:"aria-colindex"] || (node.ancestor(:row).all(:gridcell, wait: false).index(node) + 1)
    grid = node.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"], wait: false)

    grid.has_selector?(:columnheader, value, colindex: colindex.to_i, wait: false)
  end
end

CapybaraAccessibleSelectors.add_role_selector(:row, within: true, content_fallback: true) do
  node_filter(:rowindex, valid_values: Integer, skip_if: nil) do |row, value|
    case row[:"aria-rowindex"]
    when value.to_s then true
    when NilClass
      if row.has_selector?(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"], wait: false)
        grid = row.find(:xpath, XPath.ancestor[XPath.attr(:role) == "grid"], wait: false)

        grid.all(:row).index(row) == value.to_i
      else
        false
      end
    end
  end

  filter_set(:capybara_accessible_selectors, %i[aria described_by])
end
