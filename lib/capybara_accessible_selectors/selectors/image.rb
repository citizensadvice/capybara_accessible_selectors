# frozen_string_literal: true

CapybaraAccessibleSelectors.add_role_selector(:image) do
  expression_filter(:src, valid_values: [String, Regexp]) do |xpath, src|
    builder(xpath).add_attribute_conditions(src:)
  end

  describe(:expression_filters) do |src: nil, **|
    " expected to match src \"#{src}\"" unless src.nil?
  end
end
