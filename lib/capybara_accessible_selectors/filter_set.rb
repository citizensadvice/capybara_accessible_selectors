# frozen_string_literal: true

Capybara::Selector::FilterSet.add(:capybara_accessible_selectors)
require "capybara_accessible_selectors/filters/described_by"
require "capybara_accessible_selectors/filters/fieldset"
require "capybara_accessible_selectors/filters/focused"
require "capybara_accessible_selectors/filters/validation_error"

{
  button: %i[focused fieldset],
  checkbox: %i[focused fieldset described_by validation_error],
  css: %i[focused],
  datalist_input: %i[focused fieldset described_by validation_error],
  element: %i[focused],
  field: %i[focused fieldset described_by validation_error],
  file_field: %i[focused fieldset described_by validation_error],
  fillable_field: %i[focused fieldset described_by validation_error],
  link: %i[focused fieldset],
  link_or_button: %i[focused fieldset],
  radio_button: %i[focused fieldset described_by validation_error],
  select: %i[focused fieldset described_by validation_error],
  xpath: %i[focused]
}.each do |selector, filters|
  Capybara.modify_selector(selector) do
    filter_set(:capybara_accessible_selectors, filters)
  end
end
