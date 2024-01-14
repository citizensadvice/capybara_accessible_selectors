# frozen_string_literal: true

describe "role" do
  it "selects an element with a matching role by xpath selector" do
    render <<~HTML
      <div role="tablist">Tablist</div>
    HTML

    expect(page).to have_xpath XPath.descendant(:div), role: "tablist"
  end

  it "selects an element with a matching role by css selector" do
    render <<~HTML
      <div role="tablist">Tablist</div>
    HTML

    expect(page).to have_css "div", role: "tablist"
  end

  it "selects a button with a matching role by selector" do
    render <<~HTML
      <button type="button" role="tab">Tab</button>
    HTML

    expect(page).to have_selector :button, "Tab", type: "button", role: "tab"
  end

  it "selects a checkbox with a matching role" do
    render <<~HTML
      <input type="checkbox" role="presentation">
    HTML

    expect(page).to have_selector :checkbox, role: "presentation"
  end

  it "selects a field with a matching role" do
    render <<~HTML
      <input role="presentation">
    HTML

    expect(page).to have_selector :field, role: "presentation"
  end

  it "selects a file field with a matching role" do
    render <<~HTML
      <input type="file" role="presentation">
    HTML

    expect(page).to have_selector :file_field, role: "presentation"
  end

  it "selects a fillable field with a matching role" do
    render <<~HTML
      <input role="presentation">
    HTML

    expect(page).to have_selector :fillable_field, role: "presentation"
  end

  it "selects a link with a matching role" do
    render <<~HTML
      <a href="#" role="presentation">Link</a>
    HTML

    expect(page).to have_selector :link, "Link", role: "presentation"
  end

  it "selects a link_or_button with a matching role" do
    render <<~HTML
      <a href="#" role="presentation">Link</a>
    HTML

    expect(page).to have_selector :link_or_button, "Link", role: "presentation"
  end

  it "selects a radio button with a matching role" do
    render <<~HTML
      <input type="radio" role="presentation">
    HTML

    expect(page).to have_selector :radio_button, role: "presentation"
  end

  it "selects a select with a matching role" do
    render <<~HTML
      <select role="presentation"></select>
    HTML

    expect(page).to have_selector :select, role: "presentation"
  end

  it "does not select an element without a role" do
    render <<~HTML
      <div>Not a tablist</div>
    HTML

    expect(page).to have_no_selector :element, role: "tablist"
  end

  it "does not select an element with a different role" do
    render <<~HTML
      <button type="button" role="tab">Tab</button>
    HTML

    expect(page).to have_no_selector :element, role: "tablist"
  end

  it "provides a friendly error for role" do
    render <<~HTML
      <button type="button" role="tab">Tab</button>
    HTML

    expect do
      expect(page).to have_selector :button, "Tab", role: "tablist", wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /with role tablist/
  end
end
