# Capybara accessible selectors

A set of Capybara selectors that allow you to
find common UI elements by labels and using screen-reader compatible mark-up.

[Cheat sheet](CHEAT_SHEET.md)

## Philosophy

All feature tests should interact with the browser in the same way a screen-reader user would. This both tests the feature, and ensures the application is accessible.

To be accessible to a screen-reader, a page should be built from the native html elements with the semantics and behaviour required for each feature. For example if the page contains a button it should use `<button>` element rather than adding a `onClick` handler to a `<span>`.

Where a feature does not exist in HTML, such as tabs, then ARIA roles and states can be used to convey the meaning to a screen-reader.

For a better overview see [Using aria](https://www.w3.org/TR/using-aria/).

As a result all tests should be built from the visible labels on the page, and the semantic meaning of elements, and ARIA roles and attribute.

CSS and XPATH selectors based on classes, ids and nesting elements with no semantic meaning, should not be used.

This gem contains a set of selectors and filters for common UI elements and element states that are not already included in Capybara. These selectors follow the guidelines in [ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices-1.1/).

Examples:

```ruby
# Bad selectors
# - fragile and does not check the control is correctly labelled

page.find(:css, "#widget > div > .field").set("Bob")

fill_in "field_name_1", with: "Bob"

page.find(:css, "#tab_1").click

within(:css, "#tabs > div > div.panel:first-child") do
  expect(page).to have_text "Client name Bob"
end

# Good selectors
# - based on how a screen reader would hear and navigate a page

within_fieldset "User details" do
  fill_in "First name", with: "Bob"
end

select_tab "Client details"

expect(page).to have_tab_panel "Client details", text: "Client name Bob"

within_modal "Are you sure?" do
  click_button "OK"
end
```

## Usage

Include in your Gemfile:

```ruby
group :test do
  # It is recommended you use a tag as the main branch may contain breaking changes
  gem "capybara_accessible_selectors", git: "https://github.com/citizensadvice/capybara_accessible_selectors", tag: "v0.12.0"
end
```

## Documentation

See the [Capybara cheatsheet](https://devhints.io/capybara) for an overview of built-in Capybara selectors and actions.

### Filters

#### `accessible_description` [String, Regexp]

Added to all selectors.

Filters for an element's [computed accessible description](https://www.w3.org/TR/accname-1.2/).

The rack test driver will use a fairly accurate calculation.

The selenium drivers do not provide a way to request this value from the browser. The calculation
used does not take account of `aria-hidden` or `aria-label`.

For example:

```html
<label>
  My field
  <input aria-describedby="id1 id2" />
</label>
<span id="id1">My</span>
<span id="id2">description</span>
```

```ruby
expect(page).to have_field "My field", accessible_description: "My description"
```

#### `accessible_name` [String, Regexp]

Added to all selectors.

Filters for an element's [computed accessible name](https://www.w3.org/TR/accname-1.2/).

A string will do a partial match, unless the `exact` option is set.

The are subtle differences in how each browser calculate names, therefore the results for some of the newer roles
and some edge cases are not consistent across all drivers. However the results are good for common use cases.

This method must request the accessible name from the driver for each node found by the selector individually.
Therefore, using this with a selector that returns a large number of elements will be inefficient.

```html
<button id="id1" aria-labelledby="id1 id2">Delete</button>
<a id="id2" href="./files/Documentation.pdf">Documentation.pdf</a>
```

```ruby
click_button accessible_name: "Delete Documentation.pdf"
```

#### `aria` [Hash]

Added to all selectors.

Filters for an element that declares [ARIA attributes](https://www.w3.org/TR/wai-aria/#introstates)

```html
<button aria-controls="some-state" aria-pressed="true">A pressed button</button>
```

```ruby
expect(page).to have_selector :button, "A pressed button", aria: { controls: "some-state", pressed: true }

# If the value is nil it will select elements with the attribute
expect(page).to have_selector :button, "A pressed button", aria: { selected: nil }
```

#### `current` [String, Symbol]

Added to: `link`, `link_or_button`.

Is the element the current item within a container or set of related elements using [`aria-current`](https://www.w3.org/TR/wai-aria/#aria-current).

For example:

```html
<ul>
  <li>
    <a href="/">Home</a>
  </li>
  <li>
    <a href="/about-us" aria-current="page">About us</a>
  </li>
</ul>
```

```ruby
expect(page).to have_link "Home", current: nil
expect(page).to have_link "About us", current: "page"
```

**Note:** The `[aria-current]` attribute supports both `"true"` and `"false"`
values. A `current: true` will match against `[aria-current="true"]`, and a
`current: false` will match against `[aria-current="false"]`. To match an
element **without any** `[aria-current]` attribute, pass `current: nil`.

#### `fieldset` [String, Symbol, Array]

Added to: `button`, `link`, `link_or_button`, `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box` and `rich_text`.

Filter for controls within a `<fieldset>` by `<legend>` text. This can also take an array of fieldsets for multiple nested fieldsets.

For example:

```html
<fieldset>
  <legend>My question</legend>
  <label>
    <input type="radio" name="radios" />
    Answer 1
  </label>
  <label>
    <input type="radio" name="radios" />
    Answer 2
  </label>
</fieldset>
```

```ruby
find :radio_button, "Answer 1", fieldset: "My question"
choose "Answer 1", fieldset: "My question"
```

Also see [↓ Locating fields](#locating-fields)

#### `required` [Boolean]

Added to: `button`, `link`, `link_or_button`, `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box` and `rich_text`.

Filter for controls with a `required` or `aria-required` attribute.

For example:

```html
<label>
  <input requied />
  Text
</label>
```

```ruby
find :field, required: true
```

#### `role` [String, Symbol, nil]

Added to all selectors

Filters for an element with a matching calculated [role](https://www.w3.org/TR/wai-aria/#introroles),
taking into account [implicit role mappings](https://www.w3.org/TR/html-aria/), or with no role if `nil` is supplied.

The roles "none", "presentation" and "generic" are returned as `nil` as they are implementation details not
exposed to users.

The are subtle differences in how each browser calculate roles, therefore the results for some of the newer roles
and some edge cases are not consistent across all drivers. However the results are good for common use cases.

This method must request the role from the driver for each node found by the selector individually.
Therefore, using this with a selector that returns a large number of elements will be inefficient.

```html
<label for="switch-input">A switch input</label>
<input id="switch-input" type="checkbox" role="switch" />
```

```ruby
expect(page).to have_field "A switch input", role: "switch"
```

[Capybara.string]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara#string-class_method

#### `validation_error` [String, Regexp, true, false]

Added to: `field`, `fillable_field`, `datalist_input`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box` and `rich_text`.

Filters for an element being both invalid, and has a description or label containing the error message.

This differs from the Capybara `valid` and `validation_message` filters which only consider the HTML validation API.

To be invalid, the element must

- Not have [`willValidate === false`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLObjectElement/willValidate)
- Have [`validity.valid === false`](https://developer.mozilla.org/en-US/docs/Web/API/ValidityState) **or** or have `aria-invalid="true"`
- Not have the `validity.valid === false` and `aria-invalid="false"

For the error description, this can be contained in the accessible description, or the accessible name.

```html
<label>
  My field
  <input required aria-describedby="error-id" />
</label>
<span id="error-id">This is required</span>
```

```ruby
expect(page).to have_field "My field", validation_error: "This is required"

# Just check the field is invalid
expect(page).to have_field "My field", validation_error: true

# Just check the field is not invalid
expect(page).to have_field "My field", validation_error: false
```

Also see:

- [↓ `have_validation_errors` expectation](#have_validation_errorsblock)
- [↓ `have_no_validation_errors` expecation](#have_no_validation_errors)

### Selectors

#### Locating fields

The following selectors have been extended so you can use an array as the locator to select within a fieldset. The last element of the array is the field label, and the other elements are fieldsets.

Extended selectors: `button`, `link`, `link_or_button`, `field`, `fillable_field`, `datalist_input`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box`, `rich_text`.

```html
<fieldset>
  <legend>My question</legend>
  <label>
    <input type="radio" name="radios" />
    Answer 1
  </label>
  <label>
    <input type="radio" name="radios" />
    Answer 2
  </label>
</fieldset>
```

```ruby
find :radio_button, ["My question", "Answer 1"]
choose ["My question", "Answer 1"]
```

Also see [↑ `fieldset` filter](#fieldset-string-symbol-array)

#### `alert`

Selects an element with the role of [`alert`](https://www.w3.org/WAI/ARIA/apg/patterns/alert/).

```html
<div role="alert">Important message</div>
```

```ruby
expect(page).to have_selector :alert, text: "Successfully saved"
expect(page).to have_alert, text: "Successfully saved"
```

Also see [↓ Expectation shortcuts](#expectation-shortcuts)

#### `article`

Finds an [article structural role](https://www.w3.org/WAI/ARIA/apg/practices/structural-roles/#all-structural-roles). The selector will match either an [`<article>` element](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/article) or an element with [role="article"](https://www.w3.org/TR/wai-aria/#article).

- `locator` [String, Regexp] Match the accessible name of the article

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `banner`

Finds a [banner landmark](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/#x4-3-1-banner).

- `locator` [String, Regexp] Match the accessible name of the article

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `columnheader`

Finds a [columnheader](https://w3c.github.io/aria/#columnheader) cell that's either a `<th>` element descendant of a `<table>`, or a `[role="columnheader"]` element.

- `locator` [String, Symbol] The text contents of the element
- filters:
  - `colindex` [Integer, String] Filters elements based on their position amongst their siblings, or elements with a matching [aria-colindex](https://w3c.github.io/aria/#aria-colindex)

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

Example:

```html
<table role="grid">
  <tr>
    <th>A columnheader</th>
  </tr>
</table>

<div role="grid">
  <div role="row">
    <div role="columnheader">A columnheader</div>
  </div>
</div>
```

```ruby
expect(page).to have_selector :columnheader, "A columnheader", count: 2
```

#### `combo_box`

Finds a [combo box](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/).
This will find ARIA 1.0 and ARIA 1.1 combo boxes. A combo box is an input with a popup list of options.

This also finds select based on [Twitter typeahead](https://twitter.github.io/typeahead.js/) classes, but this behaviour is deprecated and will be removed in a future release.

Locator and options are the same as the [field selector](https://www.rubydoc.info/github/jnicklas/capybara/Capybara/Selector) with the following additional filters:

- Filters:
  - `expanded` [Boolean] - Is the combo box expanded
  - `options` [Array\<String, Regexp\>] - Has exactly these options in order. This, and other other filters, will match if the option includes the string
  - `with_options` [Array\<String, Regexp\>] - Includes these options
  - `enabled_options` [Array\<String, Regexp\>] - Has exactly these enabled options in order
  - `with_enabled_options` [Array\<String, Regexp\>] - Includes these enabled options
  - `disabled_options` [Array\<String, Regexp\>] - Has exactly these disabled options in order
  - `with_disabled_options` [Array\<String, Regexp\>] - Includes these disabled options

Option text is normalised to single white spaces.

Note that the built-in Capybara selector `datalist_input` will find a [native html `list` attribute based combo-box](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/datalist).

Also see:

- [↓ `select_combo_box_option` action](#select_combo_box_optionwith-options)
- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `contentinfo`

Finds a [contentinfo landmark](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/#x4-3-3-contentinfo).

- `locator` [String, Symbol] The landmark's `[aria-label]` attribute or contents
  of the element referenced by its `[aria-labelledby]` attribute

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `dialog`

Finds a dialog.

This checks for either

- an element with the role `dialog` or `alertdialog`
- or, an open `<dialog>` element

- `locator` [String, Regexp] The accessible name of the modal
- Filters:
  - `modal` [Boolean] Is dialog a modal. Modals are either opened with `showModal()`, or have the `aria-modal="true"` attribute

Also see:

- [↓ `modal` selector](#modal)
- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_dialog`](#within_dialogname-find_options-block)

#### `disclosure`

Finds a [disclosure](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/). This will find both a [native disclosure](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) (`<details>`/`<summary>`) and an ARIA disclosure.

- `locator` [String, Symbol] The text label of the disclosure
- Filters:
  - `expanded` [Boolean] Is the disclosure expanded

Note that an ARIA disclosure is typically hidden when closed. Using `expanded: false` will only find an element where `visible:` is set to `false` or `:all`.

Also see:

- [↓ `select_disclosure` action](#select_disclosure)
- [↓ `toggle_disclosure` action](#toggle_disclosurename-expand)
- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_disclosure`](#within_disclosurename-find_options-block)

#### `disclosure_button`

Finds the open and close button associated with a [disclosure](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/). This will be a `<summary>`, a `<button>` or an element with the role of button.

- `locator` [String, Symbol] The text label of the disclosure
- Filters:
  - `expanded` [Boolean] Is the disclosure expanded

Also see:

- [↓ `select_disclosure` action](#select_disclosure)
- [↓ `toggle_disclosure` action](#toggle_disclosurename-expand)
- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `grid`

Finds a [grid](https://www.w3.org/WAI/ARIA/apg/patterns/grid/) element that declares `[role="grid"]`.

- `locator` [String, Symbol] Either the grid's `[aria-label]` value, or the
  text contents of the elements referenced by its `[aria-labelledby]` attribute

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

Example:

```html
<table role="grid" aria-label="A grid"></table>
<div role="grid" aria-label="A grid"></div>
```

```ruby
expect(page).to have_selector :grid, "A table grid", count: 2
```

#### `gridcell`

Finds a [gridcell](https://w3c.github.io/aria/#gridcell) element that's either a `<td>` descendant of a `<table>` or declares `[role="gridcell"]`.

- `locator` [String, Symbol]
- filters:
  - `columnheader` [String, Symbol] Filters elements based on their matching columnheader's text content
  - `rowindex` [Integer, String] Filters elements based on their ancestor row's positing amongst its siblings
  - `colindex` [Integer, String] Filters elements based on their position amongst their siblings

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

Example:

```html
<table role="grid">
  <tr>
    <td>A gridcell</td>
  </tr>
</table>

<div role="grid">
  <div role="row">
    <div role="gridcell">A gridcell</div>
  </div>
</div>
```

```ruby
expect(page).to have_selector :gridcell, "A gridcell", count: 2
```

#### `heading`

Finds a heading. This can be either an element with the role "heading" or `h1` to `h6`.

- `locator` [String, Symbol]
- filters:
  - `level` [1..6] Filter for a heading level

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

Example:

```html
<div role="heading">Heading</div>
<h2>Heading</h2>
```

```ruby
expect(page).to have_selector :heading, "Heading", count: 2
```

#### `item` and `item_type`

Finds a [microdata](https://developer.mozilla.org/en-US/docs/Web/HTML/Microdata) item.

Microdata isn't exposed to users, including screen-readers. However this can still be a useful way to check a page has the expected information in the expected place.

- `locator` [String, Symbol] The `itemprop` name of the item
- Filters:
  - `type` [String, Symbol, Array] The `itemtype`. Also accepts and array of item types, for selecting nested item types

Example:

```html
<dl itemscope itemtype="application:person">
  <dt>First name</dt>
  <dd itemprop="first-name">Bob</dd>
  <dt>Last name</dt>
  <dd itemprop="last-name">Hoskins</dd>
</dl>
```

```ruby
expect(page).to have_selector :item, "first-name", type: "application:person", text: "Bob"
expect(page).to have_selector :item_type, "application:person"
```

Also see [↓ Expectation shortcuts](#expectation-shortcuts)

#### `main`

Finds a [main landmark](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/#x4-3-5-main).

- `locator` [String, Symbol] The landmark's `[aria-label]` attribute or contents
  of the element referenced by its `[aria-labelledby]` attribute

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `menu`

Finds a [menu](https://www.w3.org/WAI/ARIA/apg/patterns/menu/).

- `locator` [String, Symbol] Either the menu's `[aria-label]` value, the
  contents of the `[role="menuitem"]` or `<button>` referenced by its
  `[aria-labelledby]`
- Filters:
  - `expanded` [Boolean] Is the menu expanded
  - `orientation` [String] The menu's orientation, either `horizontal` or
    `vertical` (defaults to `vertical` when omitted

```html
<div role="menu" aria-label="Actions">
  <button type="button" role="menuitem">Share</li>
  <button type="button" role="menuitem">Save</li>
  <button type="button" role="menuitem">Delete</li>
</div>
```

```ruby
expect(page).to have_selector :menu, "Actions"
expect(page).to have_selector :menu, "Actions", expanded: true
```

#### `menuitem`

Finds a [menuitem](https://w3c.github.io/aria/#menuitem).

- `locator` [String, Symbol] The menuitem content or the
- `locator` [String, Symbol] Either the menuitem's contents, its `[aria-label]`
  value, or the contents of the element referenced by its `[aria-labelledby]`
- Filters:
  - `disabled` [Boolean] Is the menuitem disabled

```html
<div role="menu" aria-label="Actions">
  <button type="button" role="menuitem">Share</li>
  <button type="button" role="menuitem" aria-disabled="true">Save</li>
  <button type="button" role="menuitem">Delete</li>
</div>
```

```ruby
within :menu, "Actions", expanded: true do
  expect(page).to have_selector :menuitem, "Share"
  expect(page).to have_selector :menuitem, "Save", disabled: true
  expect(page).to have_no_selector :menuitem, "Do something else"
end
```

#### `modal`

Finds a [modal dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialogmodal/).

This checks for either

- a modal with the `dialog` or `alertdialog` role and `aria-modal="true"` attribute
- or, a `<dialog>` element opened with `showModal()`

- `locator` [String, Symbol] The title of the modal

Also see:

- [↑ `dialog` selector](#dialog)
- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_modal`](#within_modalname-find_options-block)

#### `navigation`

Finds a [navigation landmark](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/#x4-3-6-navigation).

- `locator` [String, Symbol] The landmark's `[aria-label]` attribute or contents
  of the element referenced by its `[aria-labelledby]` attribute

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `row`

Finds a [row](https://w3c.github.io/aria/#row) element that's either a `<tr>` descendant of a `<table>` or declares `[role="row"]`.

- `locator` [String, Symbol] The text contents of the element
- filters:
  - `rowindex` [Integer, String] Filters elements based on their position amongst their siblings, or elements with a matching [aria-rowindex](https://w3c.github.io/aria/#aria-rowindex)

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

Example:

```html
<table role="grid">
  <tr>
    <td>Within a row</td>
  </tr>
</table>

<div role="grid">
  <div role="row">
    <div role="gridcell">Within a row</div>
  </div>
</div>
```

```ruby
expect(page).to have_selector :row, "Within a row", count: 2
```

#### `region`

Finds a [region landmark](https://www.w3.org/WAI/ARIA/apg/practices/landmark-regions/#x4-3-7-region).

- `locator` [String, Symbol] The landmark's `[aria-label]` attribute or contents
  of the element referenced by its `[aria-labelledby]` attribute

Also see:

- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `rich_text`

Finds a rich text editor.

This should be compatible with most browser based rich text editors. It searches for an element with the [`contenteditable` attribute][] marked up with the [`textbox` role][]. It is also compatible with `<iframe>` based editors such as CKEditor 4 and TinyMCE.

- `locator` [String, Symbol] The label for the editor. This can be an `aria-label` or `aria-labelledby`. For iframe editors this is the `title` attribute.

For testing the content of an iframe based editor you need to use `within_frame`, or you can use `within_rich_text`.

```ruby
# non-iframe based editors
expect(page).to have_selector :rich_text, "Label", text: "My content"

# iframe based editors
within_frame find(:rich_text, "Label") do
  expect(page).to have_text "My content"
end
```

Also see:

- [↓ `fill_in_rich_text` action](#fill_in_rich_textlocator-options)
- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_rich_text`](#within_rich_textname-find_options-block)

[`contenteditable` attribute]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/contenteditable
[`textbox` role]: https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/textbox_role

#### `role`

Finds element by their aria role.

This will find elements by both their implicit and explict roles.

- `locator` [String, Symbol, String[], Symbol[]] a role or array of roles
- filters:
  - `custom_elements` [String, String[]] custom elements to include in the search

```html
<button>Press me</button>
```

```ruby
expect(page).to have_selector :role, :button
```

The selector will try to match the [ARIA in HTML spec](https://www.w3.org/TR/html-aria/)
however different drivers can return slightly different roles. For example Safari
currently returns "button" instead of "combobox" for a `<select>`.

You can work around this by providing a list of acceptable roles.

```ruby
expect(page).to have_selector :role, %i[combobox button]
```

If you use [`ElementInternals`](https://developer.mozilla.org/en-US/docs/Web/API/ElementInternals)
on custom elements to set the aria role, you will need to tell the the selector to include
these elements in the search. Use the `custom_elements` filter for this.

```ruby
expect(page).to have_selector :role, :textbox, custom_elements: "custom-textbox"
```

#### `section`

Finds a section of the site based on the first heading in the section.

A section is html sectioning element: `<section>`, `<article>`, `<aside>`, `<footer>`, `<header>`, `<main>` or `<form>`.

- `locator` [String, Symbol] The text of the first heading
- filters:
  - `heading_level` [Integer, Enumerable] The heading level to find. Defaults to `(1..6)`
  - `section_element` [String, Symbol, Array] The section element to use. Defaults to `%i[section article aside footer header main form]`

```html
<section>
  <div>
    <h2>My section</h2>
  </div>
  Some content
</section>
```

```ruby
within :section, "My section" do
	expect(page).to have_text "Some content"
end
```

Also see

- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_section`](#within_sectionname-find_options-block)

#### `tab_panel`

Finds a [tab panel](https://www.w3.org/WAI/ARIA/apg/patterns/tabpanel/).

- `locator` [String, Symbol] The text label of the tab button associated with the panel
- Filters:
  - `open` [Boolean] Is the tab panel open.

Note that a closed tab panel is not visible. Using `open: false` will only find an element where `visible:` is set to `false` or `:all`.

Also see

- [↓ `select_tab` action](#select_tabname-block)
- [↓ Expectation shortcuts](#expectation-shortcuts)
- [↓ `within_tab_panel`](#within_tab_panelname-find_options-block)

#### `tab_button`

Finds the button that opens a tab.

- `locator` [String, Symbol] The text label of the tab button
- Filters:
  - `open` [Boolean] Is the tab panel open.

Also see:

- [↓ `select_tab` action](#select_tabname-block)
- [↓ Expectation shortcuts](#expectation-shortcuts)

#### `test_id

Finds an element by the attribute set in `Capybara.test_id`.

- `locator` [String, Symbol] The id to find

This is equivalent to `find :xpath, '//*[@data-test-id="my_id"]'`

It's only benefit is a clearer intent.

```html
<div data-test-id="foo"></div>
```

```ruby
# Global setup
Capybara.test_id = "data-test-id"

find(:test_id, "foo")
# or using the shortcut
find_by_test_id("foo")
```

Also see [↓ `find_by_test_id` action](#find_by_test_id-id-options)

### Actions

#### `fill_in_rich_text(locator, **options)`

Fill in a rich text field with plain text.

- `locator` [String] - Find the rich text area
- `options`:
  - `with` [String] - The text to fill the field, or nil to empty
  - `clear` [Boolean] - Clear the rich text area first, defaults to true

```ruby
fill_in_rich_text "Diary entry", with: "Today I published a gem"
```

Also see [↑ `rich_text` selector](#rich_text)

#### `find_by_test_id(id, **options)`

Shortcut for `find(:test_id, "id")`

Also see [↑ `test_id` selector](#test_id)

#### `select_tab(name, &block)`

Opens a tab by name.

- `name` [String] - The tab label to open
- `block` [Block] - Optional block to run within the tab

```ruby
select_tab "Client details"
```

Also see [↑ `tab_panel` selector](#tab_panel)

#### `select_combo_box_option(with, **options)`

Fill in a combo box and select an option

- `with` [String] - Option to select, or an empty string to clear the combo box
- `options`:
  - `from` [String, Symbol, Array] - Locator for the field
  - `search` [String] - Alternative text to search for in the input
  - `currently_with` [String] - Current value for the field
  - options prefixed with `option_` will be used to find the option. eg `option_text`, `option_match`
  - other options will be used to find the combo box

```ruby
select_combo_box_option "Apple", from: "Fruits"
```

Also see [↑ `combo_box` selector](#combo_box)

#### `select_disclosure(name)`

Open disclosure if not already open, and return the disclosure.

- `name` [String] - Locator for the disclosure button
- options:
- `block` - When present, the `block` argument is forwarded to a
  [`within_disclosure`](#within_disclosurename-find_options-block) call

```ruby
select_disclosure("Client details")
select_disclosure "Client details" do
  expect(page).to have_text "The Client details contents"
end
```

Also see [↑ `disclosure` selector](#disclosure)

#### `toggle_disclosure(name, expand:)`

Toggle a disclosure open or closed, and return the button

- `name` [String] - Locator for the disclosure button
- options:
  - `expand` [Boolean] - Force open or closed rather than toggling.
- `block` - When present, the `block` argument is forwarded to a
  [`within_disclosure`](#within_disclosurename-find_options-block) call

```ruby
toggle_disclosure("Client details")
toggle_disclosure "Client details", expand: true do
  expect(page).to have_text "The Client details contents"
end
```

Also see [↑ `disclosure` selector](#disclosure)

### Limiting

#### `within_disclosure(name, **find_options, &block)`

Executing the block within a disclosure.

```ruby
within_disclosure "Client details" do
  expect(page).to have_text "Name: Frank"
end
```

Also see [↑ `disclosure` selector](#disclosure)

#### `within_dialog(name, **find_options, &block)`

Execute the block within a dialog

```ruby
within_dialog "Settings" do
  check "Dark mode"
end
```

Also see [↑ `dialog` selector](#dialog)

#### `within_modal(name, **find_options, &block)`

Execute the block within a modal.

```ruby
within_modal "Are you sure?" do
  click_button "Confirm"
end
```

Also see [↑ `modal` selector](#modal)

#### `within_rich_text(name, **find_options, &block)`

Execute within the rich text. If the rich text is iframe based this will execute "`within_frame`".

```ruby
within_rich_text "Journal entry" do
  expect(page).to have_text "Today I went to the zoo"
end
```

Also see [↑ `rich_text` selector](#rich_text)

#### `within_section(name, **find_options, &block)`

Execute the block within a section.

```ruby
within_section "Heading" do
  expect(page).to have_text "Section content"
end
```

Also see [↑ `section` selector](#section)

#### `within_tab_panel(name, **find_options, &block)`

Executing the block within a tab panel.

```ruby
within_tab_panel "Client details" do
  expect(page).to have_text "Name: Fred"
end
```

Also see [↑ `tab_panel` selector](#tab_panel)

### Expectations

#### `have_validation_errors(&block)`

Checks if a page has a set of validation errors.

This will compare all the validation errors on a page with an expected set of errors.
If the errors do not match it will not pass.

- `&block` - this takes a block. In the block each validation error exception should be added using the following DSL:

```ruby
expect(page).to have_validation_errors do
  field "Name", validation_error: "This is required"
  select "Gender", validation_error: "This is required"
  field "Age", validation_error: "Choose a number less than 120"
  radio_group "Radio questions", validation_error: "Select an option"

  # You can use all the field selectors in the block
  # checkbox datalist_input field file_field fillable_field radio_button select combo_box rich_text

  # Additionally a "radio_group" selector will find all radios in a fieldset
  # You can also use "within" and "within_fieldset" methods
end
```

Also see [↑ `validation_error` filter](#validation_error-string)

#### `have_no_validation_errors`

Checks if a page has no invalid fields.

```ruby
expect(page).to have_no_validation_errors
```

Also see [↑ `validation_error` filter](#validation_error-string)

#### Expectation shortcuts

The following expectation shortcuts are also added for both `have_selector_` and `have_no_selector_`:

- `have_alert`
- `have_article`
- `have_banner`
- `have_columnheader`
- `have_combo_box`
- `have_contentinfo`
- `have_disclosure`
- `have_disclosure_button`
- `have_grid`
- `have_gridcell`
- `have_heading`
- `have_item`
- `have_main`
- `have_modal`
- `have_navigation`
- `have_region`
- `have_row`
- `have_section`
- `have_tab_panel`
- `have_tab_button`

For example the following two are equivalent:

```ruby
expect(page).to have_selector :combo_box, "Foo"
expect(page).to have_combo_box, "Foo"
```

### Node methods

#### `accessible_description`

The computed accessible description

See [↑ `accessible_description` filter](#accessible_description-string-regexp)

#### `accessible_name`

The computed accessible name

See [↑ `accessible_name` filter](#accessible_name-string-regexp)

#### `role`

The computed accessible role

See [↑ `role` filter](#role-string-symbol-nil)

## Local development

```bash
# install
bundle install

# lint
bundle exec rubocop

# test
# A local install of Chrome is required for the selenium web driver
bundle exec rspec
```
