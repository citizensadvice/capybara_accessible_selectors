# frozen_string_literal: true

Capybara::Selector::FilterSet.add(:capybara_accessible_selectors)
require "capybara_accessible_selectors/filters/current"
require "capybara_accessible_selectors/filters/described_by"
require "capybara_accessible_selectors/filters/fieldset"
require "capybara_accessible_selectors/filters/role"
require "capybara_accessible_selectors/filters/validation_error"

{
  button: %i[fieldset role],
  checkbox: %i[fieldset described_by role validation_error],
  css: %i[role],
  datalist_input: %i[fieldset described_by validation_error],
  element: %i[role],
  field: %i[fieldset described_by role validation_error],
  file_field: %i[fieldset described_by role validation_error],
  fillable_field: %i[fieldset described_by role validation_error],
  link: %i[current fieldset role],
  link_or_button: %i[current fieldset role],
  radio_button: %i[fieldset described_by role validation_error],
  select: %i[fieldset described_by role validation_error],
  xpath: %i[role]
}.each do |selector, filters|
  Capybara.modify_selector(selector) do
    filter_set(:capybara_accessible_selectors, filters)
  end
end
