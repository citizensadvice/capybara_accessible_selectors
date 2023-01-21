# frozen_string_literal: true

Capybara::Selector::FilterSet.add(:capybara_accessible_selectors)
require "capybara_accessible_selectors/filters/aria"
require "capybara_accessible_selectors/filters/current"
require "capybara_accessible_selectors/filters/described_by"
require "capybara_accessible_selectors/filters/fieldset"
require "capybara_accessible_selectors/filters/required"
require "capybara_accessible_selectors/filters/role"
require "capybara_accessible_selectors/filters/validation_error"

{
  button: %i[fieldset],
  checkbox: %i[fieldset validation_error required],
  css: [],
  datalist_input: %i[fieldset validation_error required],
  element: [],
  field: %i[fieldset validation_error required],
  fieldset: [],
  file_field: %i[fieldset validation_error required],
  fillable_field: %i[fieldset validation_error required],
  frame: [],
  id: [],
  label: [],
  link: %i[current fieldset],
  link_or_button: %i[current fieldset],
  radio_button: %i[fieldset validation_error required],
  select: %i[fieldset validation_error required],
  table: [],
  table_row: [],
  xpath: []
}.each do |selector, filters|
  Capybara.modify_selector(selector) do
    filter_set(:capybara_accessible_selectors, [*filters, :aria, :role, :described_by])
  end
end
