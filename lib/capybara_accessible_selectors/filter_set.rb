# frozen_string_literal: true

Capybara::Selector::FilterSet.add(:capybara_accessible_selectors)
require "capybara_accessible_selectors/filters/aria"
require "capybara_accessible_selectors/filters/current"
require "capybara_accessible_selectors/filters/described_by"
require "capybara_accessible_selectors/filters/fieldset"
require "capybara_accessible_selectors/filters/validation_error"

{
  button: %i[fieldset aria],
  checkbox: %i[fieldset described_by aria validation_error],
  css: %i[aria],
  datalist_input: %i[fieldset described_by validation_error],
  element: %i[aria],
  field: %i[fieldset described_by aria validation_error],
  file_field: %i[fieldset described_by aria validation_error],
  fillable_field: %i[fieldset described_by aria validation_error],
  link: %i[current fieldset aria],
  link_or_button: %i[current fieldset aria],
  radio_button: %i[fieldset described_by aria validation_error],
  select: %i[fieldset described_by aria validation_error],
  xpath: %i[aria]
}.each do |selector, filters|
  Capybara.modify_selector(selector) do
    filter_set(:capybara_accessible_selectors, filters)
  end
end
