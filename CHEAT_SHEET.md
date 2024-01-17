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

## Modal

Find a [modal dialog](https://www.w3.org/TR/wai-aria-practices-1.1/#dialog_modal) by title.   

```ruby
# Find a modal
page.find(:modal, "Are you sure?")

# Perform action within a modal
within_modal "Are you sure?" do
  click_button "Confirm"
end

# Assert the page has a modal
expect(page).to have_modal "Are you sure?"
```

## Rich text

Find a rich text editing area.  This supports either `<div contenteditable="true" role="textbox" />` or
the older style using an iframe with `document.designmode`.

```ruby
# Find a rich text
page.find(:rich_text, "Description")

# Add some content to the rich text. Currently only supports plain text
fill_in_rich_text("Description", "my text")
# Replace content in rich text
fill_in_rich_text("Description", "my text", clear: true)

# Assert the rich text has content
expect(page).to have_selector :rich_text, "Description", text: "my text"

# Assert within a rich text - mostly useful for the iframe version where you need to enter the frame first
within_rich_text("Description") do
  expect(page).to have_text "my text"
end
```

## Img

Selectors and helpers for finding an [ARIA compliant image](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/img_role).

```ruby
# find an image
page.find(:img, "Label") # `aria-label`, `aria-labelledby` and for img tags `alt` attributes are supported

# expect displayed value
expect(page).to have_img "Label"

# using expression filter to expect a specific `src` attribute
expect(page).to have_img("Label", src: /image\.png/)
```

[Combo box documentation](README.md#combo_box)
