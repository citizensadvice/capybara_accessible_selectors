# frozen_string_literal: true

require "capybara_accessible_selectors/version"
require "capybara"

##
# ### Filters
#
# #### focused: (Boolean)
#
# Filters for an element that is focused.  Compatible with all selectors.
#
# #### fieldset: (String)
#
# Filters for an element in a `<fieldset>`.  The `<fieldset>` is selected by `<legend>` text.
#
# ```ruby
# find :field, "Foo", fieldset: "Bar"
# # is equivalent to
# find(:fieldset, "Bar").find(:field, "Foo")
# ```
#
# ### Selectors
#
# #### alert
#
# Selects an element with a role of alert
#
# ```html
# <div role="alert">Important message</div>
# ```
#
# ```ruby
# page.find(:alert, text: "Successfully saved")
# ```
#
# #### combo_box
#
# Finds a [combo box](https://www.w3.org/TR/wai-aria-practices-1.1/#combobox).
# This will find ARIA 1.0 and ARIA 1.1 combo boxes
#
# * Locator: Same as field
# * Filters:
#   * :disabled (Boolean) - disabled status
#   * :name (String) - input name
#   * :placeholder (String) - input placeholder
#   * :with (String) - Current input value
#   * :valid (Boolean) - Input is valid
#
# #### disclosure
#
# Selects a disclosure - also known as collapsible or revealable
#
# These can either be a [`<details>`/`<summary>` pair](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details)
# or use the [`ARIA disclosure` pattern](https://www.w3.org/TR/wai-aria-practices-1.1/#disclosure)
#
# For the aria pattern note that the disclosure is not visible if when not expanded and cannot be selected
#
# * Locator: Matches against the button or summary text
# * Filters
#   * :expanded (Boolean) - Is the disclosure expanded
#
# #### disclosure_button
#
# Selects a disclosure button
#
# This is either a `<summary>` element, button, or element with a button role associated with a disclosure
#
# * Locator: Matches against the button or summary text
# * Filters
#   * :expanded (Boolean) - Is the disclosure expanded
#
# #### section
#
# Selects any sectional element by its first heading.  The heading can be deeply nested.
#
# Section elements are `<main>`, `<header>`, `<footer>`, `<section>`, `<article>` and `<aside>`.
#
# * Locator: Matches the text of the first heading
# * Filters
#   * :heading_level (Number or array) - The heading level to match against.  Default `(1..6)`
#   * :section_element (String or array) - Section elements to match against.
#
# #### tab_button
#
# Selects a tab button
#
# * Locator: Matches the text of the tab button
# * Filters
#   * :open (Boolean) - If supplied, select on the tab being open or closed
#
# #### tab_panel
#
# Selects a tab panel from the tab button text
#
# The panel must be open to select, and it must match the design described in [ARIA practices](https://www.w3.org/TR/wai-aria-practices-1.1/#tabpanel).
# In particular, ensure the roles and aria-controls are correctly set.
#
# As a closed panel is hidden, you cannot selected a closed panel without specifying visible: :any or visible: false
#
# * Locator: Matches the text of the tab button
#   * :open (Boolean) - If supplied, select on the tab being open or closed
module CapybaraAccessibleSelectors
  class << self
    attr_accessor :locate_fields_on_labels
  end
end

require "capybara_accessible_selectors/helpers"
require "capybara_accessible_selectors/actions"
require "capybara_accessible_selectors/filter_set"
Dir[File.join(__dir__, "capybara_accessible_selectors", "selectors", "*.rb")].each { |f| require f }
require "capybara_accessible_selectors/rspec/matchers"
