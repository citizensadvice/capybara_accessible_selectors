# frozen_string_literal: true

module CapybaraAccessibleSelectors
  # Based on https://www.w3.org/TR/html-aria/
  module Aria
    ROLE_SYNONYMS = [
      %w[img image graphics-document]
    ].freeze

    IMPLICIT_ROLE_SELECTORS = {
      link: [
        XPath.descendant(:a, :area)[XPath.attr(:href)]
      ],
      group: [
        XPath.descendant(:address, :hgroup, :optgroup, :details, :fieldset)
      ],
      article: [
        XPath.descendant(:article)
      ],
      complementary: [
        XPath.descendant(:aside)
      ],
      blockquote: [
        XPath.descendant(:blockquote)
      ],
      button: [
        XPath.descendant(:button),
        XPath.descendant(:input)[%w[button reset image submit].map { XPath.attr(:type) == _1 }.inject(:|)]
      ],
      caption: [
        XPath.descendant(:caption)
      ],
      code: [
        XPath.descendant(:code)
      ],
      deletion: [
        XPath.descendant(:del, :s)
      ],
      definition: [
        XPath.descendant(:dd)
      ],
      listbox: [
        XPath.descendant(:select)[XPath.attr(:multiple) | (XPath.attr(:size) > 1)]
      ],
      term: [
        XPath.descendant(:dfn, :dt)
      ],
      dialog: [
        XPath.descendant(:dialog)
      ],
      emphasis: [
        XPath.descendant(:em)
      ],
      figure: [
        XPath.descendant(:figure)
      ],
      contentinfo: [
        XPath.descendant(:footer)[![
          *%i[article aside main nav section].map { XPath.ancestor(_1) },
          *%w[article complimentary main navigation region].map { XPath.attr(:role) == _1 }
        ].inject(:|)]
      ],
      form: [
        XPath.descendant(:form)
      ],
      heading: [
        XPath.descendant(:h1, :h2, :h3, :h4, :h5, :h6)
      ],
      banner: [
        XPath.descendant(:header)[![
          *%i[article aside main nav section].map { XPath.ancestor(_1) },
          *%w[article complimentary main navigation region].map { XPath.attr(:role) == _1 }
        ].inject(:|)]
      ],
      separator: [
        XPath.descendant(:hr)
      ],
      image: [
        XPath.descendant(:img),
        XPath.descendant(:svg),
        # svg is on a different namespace in browsers
        XPath.descendant[XPath.function(:"local-name") == "svg"][XPath.function(:"namespace-uri") == "http://www.w3.org/2000/svg"]
      ],
      textbox: [
        XPath.descendant(:input)[
          !XPath.attr(:type) |
          [*%w[button checkbox color date datetime-local file hidden image month
               number radio range reset search submit time week].map { XPath.attr(:type) != _1 }].inject(:|)
        ][!XPath.attr(:list)],
        XPath.descendant(:textarea)
      ],
      searchbox: [
        XPath.descendant(:input)[XPath.attr(:type) == "search"][!XPath.attr(:list)]
      ],
      checkbox: [
        XPath.descendant(:input)[XPath.attr(:type) == "checkbox"]
      ],
      radio: [
        XPath.descendant(:input)[XPath.attr(:type) == "radio"]
      ],
      slider: [
        XPath.descendant(:input)[XPath.attr(:type) == "range"]
      ],
      spinbutton: [
        XPath.descendant(:input)[XPath.attr(:type) == "number"]
      ],
      combobox: [
        XPath.descendant(:input)[[
          !XPath.attr(:type) |
          [*%w[button checkbox color date datetime-local file hidden image month
               number password radio range reset submit time week].map { XPath.attr(:type) != _1 }].inject(:|)
        ].inject(:|)][XPath.attr(:list)],
        XPath.descendant(:select)[!XPath.attr(:multiple)][!XPath.attr(:size) | (XPath.attr(:size) <= 1)]
      ],
      insertion: [
        XPath.descendant(:ins)
      ],
      main: [
        XPath.descendant(:main)
      ],
      math: [
        XPath.descendant(:math),
        # Math is on a different namespace in browsers
        XPath.descendant[XPath.function(:"local-name") == "math"][XPath.function(:"namespace-uri") == "http://www.w3.org/1998/Math/MathML"]
      ],
      meter: [
        XPath.descendant(:meter)
      ],
      navigation: [
        XPath.descendant(:nav)
      ],
      listitem: [
        XPath.descendant(:li)[XPath.parent(:ul, :ol, :menu)]
      ],
      list: [
        XPath.descendant(:ul, :ol, :menu)
      ],
      option: [
        XPath.descendant(:option)[XPath.ancestor(:select)]
      ],
      status: [
        XPath.descendant(:output)
      ],
      paragraph: [
        XPath.descendant(:p)
      ],
      progressbar: [
        XPath.descendant(:progress)
      ],
      search: [
        XPath.descendant(:search)
      ],
      region: [
        XPath.descendant(:section)
      ],
      strong: [
        XPath.descendant(:strong)
      ],
      subscript: [
        XPath.descendant(:sub)
      ],
      superscript: [
        XPath.descendant(:sup)
      ],
      table: [
        XPath.descendant(:table)
      ],
      rowgroup: [
        # tbody is to spec but not recognised by any browsers
        XPath.descendant(:thead, :tbody, :tfoot)
      ],
      cell: [
        XPath.descendant(:td, :th)
      ],
      gridcell: [
        XPath.descendant(:td, :th)
      ],
      columnheader: [
        XPath.descendant(:th)
      ],
      rowheader: [
        XPath.descendant(:th)[(XPath.attr(:scope) == "row") | (XPath.attr(:scope) == "rowgroup")]
      ],
      time: [
        XPath.descendant(:time)
      ],
      row: [
        XPath.descendant(:tr)
      ]
    }.freeze
  end
end
