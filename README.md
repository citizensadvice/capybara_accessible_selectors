# Capybara accessible selectors

A set of Capybara selectors that allow you to
find common UI elements by labels and using aria compatible markup.

## Philosophy

All feature tests should interact with the browser in the same a screen-reader user would.  This both tests the feature, and ensures the application is accessible.

This means all the selectors should be based on semantic markup, page outline structure and form labels only.

For standard user interface elements that have no HTML native equivalent. For example tabs and modals. The selectors should be based on how a screen reader interacts with a page.  This is generally by aria roles and attributes.

For example:

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
```

## Usage

Include in your Gemfile:

```ruby
group :test do
  gem "capybara_accessible_selectors", git: "https://github.com/citizensadvice/capybara_accessible_selectors"
end
```

## Documentation

### Filters

#### `described_by` [String]

Added to: `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box`, `rich_text`.

Is the field described by some text using [`aria-describedby`](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_aria-describedby_attribute).

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
expect(page).to have_field "My field", described_by: "My description"
```

#### `fieldset` [String, Symbol, Array]

Added to: `button`, `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box`, `rich_text`.

Filter for controls within a `<fieldset>`.  This can also take an array of fieldsets for multiple nested fieldsets.

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

#### `focused` [Boolean]

Added to all selectors.

Filters for an element that currently has focus.

```html
<label>My field <input /></label>
```

```ruby
expect(page).to have_field "My field", focused: true
```

#### `validation_error` [String]

Added to: `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box`, `rich_text`.

Filters for an element being both invalid, and has a description or label with the error message.

To be invalid, the element must [`willValidate`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLObjectElement/willValidate) and have a [`validity.valid`](https://developer.mozilla.org/en-US/docs/Web/API/ValidityState) that is false.  Additionally the `aria-invalid` must not contradict the validity state.

For the error description, this can be contained in the ARIA description, or the label.

```html
<label>
	My field
	<input required aria-describedby="error-id" />
</label>
<span id="error-id">This is required</span>
```

```ruby
expect(page).to have_field "My field", validation_error: "This is required"
```

Also see:

- [↓ `have_validation_errors` expectation](have_validation_errors)
- [↓ `have_no_validation_errors` expecation](have_no_validation_errors)

### Selectors

#### Locating fields

The following selectors have been extended so you can use an array as an locator to select within a fieldset.  eg `["Outer fieldset legend", "optionally a nested fieldset legend", "field label"]`.

Extended selectors: `field`, `fillable_field`, `radio_button`, `checkbox`, `select`, `file_field`, `combo_box`, `rich_text`.

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

Also see [↑ `fieldset` filter](#fieldset)

#### `alert`

Selects an element with the role of [`alert`](https://www.w3.org/TR/wai-aria-practices-1.1/#alert).

```html
<div role="alert">Important message</div>
```

```ruby
expect(page).to have_selector :alert, text: "Successfully saved"
expect(page).to have_alert, text: "Successfully saved"
```

Also see [↓ `expectation shortcuts`](expectation_shortcuts)

#### `combo_box`

Finds a [combo box](https://www.w3.org/TR/wai-aria-practices-1.1/#combobox).
This will find ARIA 1.0 and ARIA 1.1 combo boxes.

This also finds select based on [Twitter typeahead](https://twitter.github.io/typeahead.js/) classes, but this behaviour is deprecated and will be removed in a future release.

Locator and options are the same as the [field selector](https://www.rubydoc.info/github/jnicklas/capybara/Capybara/Selector).

Also see:

- [↓ `select_combo_box_option` action](#select_combo_box_option)
- [↓ `expectation shortcuts`](expectation_shortcuts)

#### `disclosure`

Finds a [disclosure](https://www.w3.org/TR/wai-aria-practices-1.1/#disclosure).  This will find both a [native disclosure](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/details) (`<details>`/`<summary>`) and an ARIA disclosure.

- `locator` [String, Symbol] The text label of the disclosure
- Filters:
  - `expanded` [Boolean] Is the disclosure expanded

Note that an ARIA disclosure is typically hidden when closed.  Using `expanded: false` will only find an element where `visible:` is set to `false` or `:all`.

Also see:

- [↓ `toggle_disclosure` action](#toggle_disclosure)
- [↓ `expectation shortcuts`](expectation_shortcuts)

#### `disclosure_button`

Finds the open and close button associated with a [disclosure](https://www.w3.org/TR/wai-aria-practices-1.1/#disclosure).  This will be a `<summary>`, a `<button>` or an element with the role of button.

- `locator` [String, Symbol] The text label of the disclosure
- Filters:
  - `expanded` [Boolean] Is the disclosure expanded

Also see:

- [↓ `toggle_disclosure` action](#toggle_disclosure)
- [↓ `expectation shortcuts`](expectation_shortcuts)

#### `item`

Finds a [microdata](https://developer.mozilla.org/en-US/docs/Web/HTML/Microdata) item.

Microdata isn't exposed to users, including screen-readers.  However this can still be a useful way to check a page has the expected information in the expected place.

- `locator` [String, Symbol] The `itemprop` name of the item
- Filters:
  - `type` [String, Symbol, Array] The `itemtype`.  Also accepts and array of itemtypes.

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
```

Also see [↓ `expectation shortcuts`](expectation_shortcuts)

#### `modal`

Finds a [modal dialog](https://www.w3.org/TR/wai-aria-practices-1.1/#dialog_modal).

This checks for a modal with the correct aria role, `aria-modal="true"` attribute, and it has an associated title.

- `locator` [String, Symbol] The title of the modal

Also see [↓ `expectation shortcuts`](expectation_shortcuts)

#### `rich_text`

Finds a rich text editor.

This should be compatible with most browser based rich text editors.  It searches for `contenteditable` section marked up with the correct role.  It is also compatible with `<iframe>` based editors such as CKEditor 4 and TinyMCE.

- `locator` [String, Symbol] The label for the editor.  This can be an `aria-label` or `aria-labelledby`.  For iframe editors this is the `title` attribute.

For testing the content of an iframe based editor you need to use `within_frame`.

```ruby
# non-iframe based editors
expect(page).to have_selector :rich_text, "Label", text: "My content"

# iframe based editors
within_frame find(:rich_text, "Label") do
  expect(page).to have_text "My content"
end
```

Also see:

- [↓ `fill_in_rich_text` action](#fill_in_rich_text)
- [↓ `expectation shortcuts`](expectation_shortcuts)

#### `section`

Finds a section of the site based on the first heading in the section.

A section is html sectioning element: `<section>`, `<article>`, `<aside>`, `<footer>`, `<header>`, `<main>` or `<form>`.

- `locator` [String, Symbol] The text of the first heading
- filters:
  - `heading_level` [Integer, Enumerable] The heading level to find.  Defaults to `(1..6)`
  - `section_element` [String, Symbol, Array] The section element to use.  Defaults to `%i[section article aside footer header main form]`

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

Also see [↓ `expectation shortcuts`](expectation_shortcuts)

#### `tab_panel`

Finds a [tab panel](https://www.w3.org/TR/wai-aria-practices-1.1/#tabpanel).

- `locator` [String, Symbol] The text label of the tab button associated with the panel
- Filters:
  - `open` [Boolean] Is the tab panel open.

Note that a closed tab panel is not visible.  Using `open: false` will only find an element where `visible:` is set to `false` or `:all`.

Also see

- [↓ `open_tab` action](#open_tab)
- [↓ `expectation shortcuts`](expectation_shortcuts)

#### `tab_button`

Finds the button that opens a tab.

- `locator` [String, Symbol] The text label of the tab button
- Filters:
  - `open` [Boolean] Is the tab panel open.

Also see:

- [↓ `open_tab` action](#open_tab)
- [↓ `expectation shortcuts`](expectation_shortcuts)

### Actions

#### `fill_in_rich_text(locator, **options)`

Fill in a rich text field with plain text.

- `locator` [String] - Find the rich text area
- `options`:
  - `with` [String] - The text to fill the field, or nil to empty

```ruby
fill_in_rich_text "Diary entry", with: "Today I published a gem"
```

Also see [↑ `rich_text` selector](#rich_text)

#### `open_tab(name)`

Opens a tab by name.

- `name` [String] - The tab label to open

```ruby
open_tab "Client details"
```

Also see [↑ `tab_panel` selector](#tab_panel)

#### `select_combo_box_option(with, **options)`

Fill in a combo box and select an option

- `with` [String] - Option to select
- `options`:
  - `from` [String, Symbol, Array] - Locator for the field
  - `currently_with` [String] - Current value for the field

```ruby
select_combo_box_option "Apple", from: "Fruits"
```

Also see [↑ `combo_box` selector](#combo_box)

#### `toggle_disclosure(name, expand:)`

Toggle a disclosure open or closed.

- `name` [String] - Locator for the disclosure button
- options:
  - `expand` [Boolean] - Force open or closed rather than toggling.

```ruby
toggle_disclosure("Client details")
```

Also see [↑ `disclosure` selector](#disclosure)

### Expectations

#### `have_validation_errors(&block)`

Checks if a page has a set of validation errors.  This will fail if the page does not have the exact set of errors.

- `&block` - this takes a block.  In the block each validation error should be checked as in the example below.

```ruby
expect(page).to have_validation_errors do
  field "Name", validation_error: "This is required"
  select "Gender", validation_error: "This is required"
  field "Age", validation_error: "Please choose a number less than 120"
  
  # The block methods correspond to the following selectors:
  # field, radio_button, checkbox, select, file_field and combo_box
end
```

Also see [↑ `validation_error` filter](#validation_error_string)

#### `have_no_validation_errors`

Checks if a page has no invalid fields.

```ruby
expect(page).to have_no_validation_errors
``` 
  
Also see [↑ `validation_error` filter](#validation_error_string)  
  
#### Expectation shortcuts

The following expectation shortcuts are also added for both "have\__selector_" and "have\_no\__selector_":

- `have_alert`
- `have_combo_box`
- `have_disclosure`
- `have_disclosure_button`
- `have_item`
- `have_modal`
- `have_section`
- `have_tab_panel`
- `have_tab_button`

For example the following two are equivalent:

```ruby
expect(page).to have_selector :combo_box, "Foo"
expect(page).to have_combo_box, "Foo"

```
  
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
