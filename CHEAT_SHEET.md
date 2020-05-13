# Cheat sheet

_A work in progress_

## Combo box

Selectors and helpers for finding and filling in an [ARIA compliant combo box](https://www.w3.org/TR/wai-aria-practices-1.1/#combobox).
Supports ARIA 1.0, 1.1 and 1.2 combo boxes.

```ruby
# Find a combo box
page.find(:combo_box, "Label")

# Asset displayed value
expect(page).to have_combo_box "Label", with: "Apple"

# Assert displayed options
fill_in("Label", with: "text") # Need to search first for the options to show
expect(page).to have_combo_box "Label", options: ["Apple", "Orange", "Banana"]
# Also supports `with_options`, `enabled_options`, `with_enabled_options`, `disabled_options` and `with_disabled_options`

# Select a combo box option
select_combo_box_option "Apple", from: "Label"

# Select a combo box option, asserting the current option
select_combo_box_option "Apple", from: "Label", currently_with: "Apple"

# Select a combo box option using a different search term
select_combo_box_option "Apple", search: "ap", from: "Label"

# Select the first matching option
select_combo_box_option "Apple", from: "Label", option_match: :first
```

[Combo box documentation](README.md#combo_box)
