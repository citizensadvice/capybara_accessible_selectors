# frozen_string_literal: true

%i[field file_field checkbox radio_button fillable_field select button link
   link_or_button datalist_input combo_box rich_text].each do |selector|
  Capybara.modify_selector(selector) do
    @locator_type |= [Array]
    block = @expressions[:xpath]
    @expressions[:xpath] = lambda do |locator, *args, **options|
      *fieldsets, locator = locator if locator.is_a? Array
      xpath = instance_exec(locator, *args, options, &block)
      xpath = CapybaraAccessibleSelectors::Helpers.within_fieldset(xpath, fieldsets) if fieldsets&.any?
      xpath
    end
  end
end
