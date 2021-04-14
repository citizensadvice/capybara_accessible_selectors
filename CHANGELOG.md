# Change log

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
