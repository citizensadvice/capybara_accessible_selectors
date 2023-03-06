# frozen_string_literal: true

describe "aria" do
  it "selects an element with matching aria- attributes by xpath selector" do
    render <<~HTML
      <button aria-selected="true" aria-pressed="true">A button</button>
    HTML

    expect(page).to have_xpath XPath.descendant(:button), aria: { selected: true, pressed: true }
  end

  it "selects an element with matching aria- attributes by css selector" do
    render <<~HTML
      <button aria-selected="true" aria-pressed="true">A button</button>
    HTML

    expect(page).to have_css "button", aria: { selected: true, pressed: true }
  end

  it "selects a button with matching aria- attributes" do
    render <<~HTML
      <button aria-pressed="true">A button</button>
    HTML

    expect(page).to have_selector :button, "A button", aria: { pressed: true }
  end

  it "selects a checkbox with matching aria- attributes" do
    render <<~HTML
      <input type="checkbox" aria-hidden="true">
    HTML

    expect(page).to have_selector :checkbox, aria: { hidden: true }
  end

  it "selects a field with matching aria- attributes" do
    render <<~HTML
      <input aria-hidden="true">
    HTML

    expect(page).to have_selector :field, aria: { hidden: true }
  end

  it "selects a file field with matching aria- attributes" do
    render <<~HTML
      <input type="file" aria-hidden="true">
    HTML

    expect(page).to have_selector :file_field, aria: { hidden: true }
  end

  it "selects a fillable field with matching aria- attributes" do
    render <<~HTML
      <input aria-hidden="true">
    HTML

    expect(page).to have_selector :fillable_field, aria: { hidden: true }
  end

  it "selects a link with matching aria- attributes" do
    render <<~HTML
      <a href="#" aria-hidden="true">Link</a>
    HTML

    expect(page).to have_selector :link, "Link", aria: { hidden: true }
  end

  it "selects a link_or_button with matching aria- attributes" do
    render <<~HTML
      <a href="#" aria-hidden="true">Link</a>
    HTML

    expect(page).to have_selector :link_or_button, "Link", aria: { hidden: true }
  end

  it "selects a radio button with matching aria- attributes" do
    render <<~HTML
      <input type="radio" aria-hidden="true">
    HTML

    expect(page).to have_selector :radio_button, aria: { hidden: true }
  end

  it "selects a select with matching aria- attributes" do
    render <<~HTML
      <select aria-hidden="true"></select>
    HTML

    expect(page).to have_selector :select, aria: { hidden: true }
  end

  it "does not select an element without matching aria- attributes" do
    render <<~HTML
      <div>Not a tablist</div>
    HTML

    expect(page).to have_no_selector :element, aria: { hidden: true }
  end

  it "does not select an element with matching aria- attributes" do
    render <<~HTML
      <button type="button" role="tab">Tab</button>
    HTML

    expect(page).to have_no_selector :element, aria: { hidden: true }
  end

  it "provides a friendly error for the aria-prefixed attributes" do
    render <<~HTML
      <div>An element</div>
    HTML

    expect do
      expect(page).to have_css "div", aria: { selected: false, pressed: false }, wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /with aria-selected="false" and aria-pressed="false"/
  end
end
