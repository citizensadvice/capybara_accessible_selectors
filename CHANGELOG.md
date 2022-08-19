# Change log

## Unreleased

- Add `:menu` and `:menuitem` selector

## v0.8.2

- Focus rich text when editing it
- Remove old fix for [Chrome driver bug](https://bugs.chromium.org/p/chromedriver/issues/detail?id=3214&q=sendKeys&can=2)

## v0.7.0

- Add an optional block to `select_tab`
- Fix documentation for `select_tab`

## v0.6.1

- Fix incompatibility with Ruby < 3.1

## v0.6.0

- When passed a block, `toggle_disclosure` will forward the block to a
  `within_disclosure` call with the same set of locator arguments and options
- Add `item_type` selector
- `type` selector now uses css and works on a space separated items

## v0.5.0

- Fix selecting a modal or rich text by aria-label was using the exact text
- Support the `extact` option for selecting a modal or rich text
- add `focused` filter to `disclosure_button` and `modal`

## v0.4.2

- Fix Ruby 3 errors
- Filter `list_box_option` nodes based on whether or not `aria-selected="true"`

## v0.4.1

- Fixes Ruby 2.7 warnings when passing options

## v0.4.0

- Combo box option matching now uses normalised white-space

## v0.3.0

- Fix `select_combo_box_option` should click on a td when the option is a tr
- Add modal to cheat sheet

## v0.2.0

- Added additional selector options to combo box
- `select_combo_box_option` will not longer try to select a disabled option
- Added cheat sheet

## v0.1.0

- Fix rich text areas not clearing when filled in [Chrome driver bug](https://bugs.chromium.org/p/chromedriver/issues/detail?id=3214&q=sendKeys&can=2)
- Added option to not clear the rich text area
- added `search` option to `select_combo_box_option`
- added find options for the option element to `select_combo_box_option`
