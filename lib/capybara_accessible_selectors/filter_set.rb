# frozen_string_literal: true

Capybara::Selector::FilterSet.add(:capybara_accessible_selectors) {}
Dir[File.join(__dir__, "filters", "*.rb")].each { |f| require f }

{
  field: %i[focused fieldset described_by validation_error],
  xpath: %i[focused],
  css: %i[focused],
  button: %i[focused fieldset],
  link: %i[focused],
  link_or_button: %i[focused],
  fillable_field: %i[focused fieldset described_by validation_error],
  radio_button: %i[focused fieldset described_by validation_error],
  checkbox: %i[focused fieldset described_by validation_error],
  select: %i[focused fieldset described_by validation_error],
  file_field: %i[focused fieldset described_by validation_error],
  element: %i[focused]
}.each do |selector, filters|
  Capybara.modify_selector(selector) do
    filter_set(:capybara_accessible_selectors, filters)
  end
end
