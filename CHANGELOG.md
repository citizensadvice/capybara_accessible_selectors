# Change log

## v0.11.0

### Added

- `:img` selector and matcher [Phillip Kessels]
- `:dialog` selector and matcher
- `:heading` selector and matcher
- `aria` filter to `:combo_box`, `:disclosure`, and `:disclosure_button` [Sean Doyle]

### Fixed

- `:region` selector was finding `<section>` elements without an accessible name
- `:section` selector was matching sections with no headings resulting in ambiguous matcher errors

### Changed

- All filters will now validate their inputs more strictly
- `described_by` and `validation_error` filters will also accept a regular expression
- The `:modal` selector will now check a native modal is displaying as a modal
- `:section` selector will also match aria headings
- `validation_error` filter
  - now checks for `validity.valid` _or_ the `aria-invalid=true` attribute
    Previously it required `aria-invalid=true` attribute
  - now allows the error message to be in the `aria-labelledby` name
  - now also takes a boolean allowing you to check if a field is or isn't invalid
- `have_validation_errors`:
  - allows use of `within` and `within_fieldset` within the block
  - allows you to use `radio_group` to match multiple radios by a fieldset legend
  - added some missing selectors
  - corrected logic for finding invalid fields
- `current` filter will now accept `nil` to match having no `aria-current` [Sean Doyle]

### Removed

- Removed support for Ruby 2.7. Minimum supported Ruby version is now 3.0

## v0.10.0

- Added a `required` filter to all form input selectors
- The `described_by` filter is now available on all selectors
- Fix an issue with filling in a iframe rich text and the Gecko driver

## v0.9.0

- Add `role:` filter [Sean Doyle]
- Add `aria:` Hash filter [Sean Doyle]
- Add `:article` selector and `have_article` matcher [Sean Doyle]
- Add `:grid`, `:gridcell`, `:columnheader`, and `:row`[Sean Doyle]
- Add `:menu` and `:menuitem` selector [Sean Doyle]
- Add `current:` filter for `:link` and `:link_or_button` selectors [Sean Doyle]
- Add `:banner`, `:contentinfo`, `:main`, `:navigation` and `:region` selectors [Sean Doyle]
- Removed `focused:` in favour of the "native" capybara focus
- Allow the `:modal` selector to select open `<dialog>` elements
- Added a `select_disclosure` method, that will open a disclosure and run a block within it.
- Fix `fill_in_rich_text` can enter an infinite loop when clearing

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
