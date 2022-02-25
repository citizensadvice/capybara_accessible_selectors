# frozen_string_literal: true

describe "focused" do
  before { visit "/focused.html" }

  it "selects an focused field" do
    expect(page).to have_selector :field, "Input", focused: false
    expect(page).to have_no_selector :field, "Input", focused: true
    focus_on find(:field, "Input")
    expect(page).to have_selector :field, "Input", focused: true
  end

  it "selects an focused select" do
    expect(page).to have_no_selector :select, "Select", focused: true
    expect(page).to have_selector :select, "Select", focused: false
    focus_on find(:select, "Select")
    expect(page).to have_selector :select, "Select", focused: true
  end

  it "selects an focused fillable_field" do
    expect(page).to have_no_selector :fillable_field, "Textarea", focused: true
    expect(page).to have_selector :fillable_field, "Textarea", focused: false
    focus_on find(:fillable_field, "Textarea")
    expect(page).to have_selector :fillable_field, "Textarea", focused: true
  end

  it "selects an focused datalist_input" do
    expect(page).to have_no_selector :datalist_input, "Input", focused: true
    expect(page).to have_selector :datalist_input, "Input", focused: false
    focus_on find(:datalist_input, "Input")
    expect(page).to have_selector :datalist_input, "Input", focused: true
  end

  it "selects a focused button" do
    expect(page).to have_no_selector :button, "Button", focused: true
    expect(page).to have_selector :button, "Button", focused: false
    focus_on find(:button, "Button")
    expect(page).to have_selector :button, "Button", focused: true
  end

  it "selects a focused link" do
    expect(page).to have_no_selector :link, "Link", focused: true
    expect(page).to have_selector :link, "Link", focused: false
    focus_on find(:link, "Link")
    expect(page).to have_selector :link, "Link", focused: true
  end

  it "selects a focused link_or_button" do
    expect(page).to have_no_selector :link_or_button, "Link", focused: true
    expect(page).to have_selector :link_or_button, "Link", focused: false
    focus_on find(:link_or_button, "Link")
    expect(page).to have_selector :link_or_button, "Link", focused: true
  end

  it "selects a focused radio_button" do
    expect(page).to have_no_selector :radio_button, "Radio", focused: true
    expect(page).to have_selector :radio_button, "Radio", focused: false
    focus_on find(:radio_button, "Radio")
    expect(page).to have_selector :radio_button, "Radio", focused: true
  end

  it "selects a focused checkbox" do
    expect(page).to have_no_selector :checkbox, "Checkbox", focused: true
    expect(page).to have_selector :checkbox, "Checkbox", focused: false
    focus_on find(:checkbox, "Checkbox")
    expect(page).to have_selector :checkbox, "Checkbox", focused: true
  end

  it "selects a focused file_field" do
    expect(page).to have_no_selector :file_field, "File", focused: true
    focus_on find(:file_field, "File")
    expect(page).to have_selector :file_field, "File", focused: true
  end

  it "selects a focused element" do
    expect(page).to have_no_selector :element, :div, text: "Focusable", focused: true
    expect(page).to have_selector :element, :div, text: "Focusable", focused: false
    focus_on find(:element, :div, text: "Focusable")
    expect(page).to have_selector :element, :div, text: "Focusable", focused: true
  end

  it "selects a focused xpath selector" do
    expect(page).to have_no_selector :xpath, XPath.descendant(:div), text: "Focusable", focused: true
    expect(page).to have_selector :xpath, XPath.descendant(:div), text: "Focusable", focused: false
    focus_on find(:xpath, XPath.descendant(:div), text: "Focusable")
    expect(page).to have_selector :xpath, XPath.descendant(:div), text: "Focusable", focused: true
  end

  it "selects a focused css selector" do
    expect(page).to have_no_selector :css, "div", text: "Focusable", focused: true
    expect(page).to have_selector :css, "div", text: "Focusable", focused: false
    focus_on find(:css, "div", text: "Focusable")
    expect(page).to have_selector :css, "div", text: "Focusable", focused: true
  end

  it "selects a focused combo box" do
    expect(page).to have_no_selector :combo_box, "Combo box", focused: true
    expect(page).to have_selector :combo_box, "Combo box", focused: false
    focus_on find(:combo_box, "Combo box")
    expect(page).to have_selector :combo_box, "Combo box", focused: true
  end

  it "selects a focused rich text" do
    expect(page).to have_no_selector :rich_text, "Rich text", focused: true
    expect(page).to have_selector :rich_text, "Rich text", focused: false
    focus_on find(:rich_text, "Rich text")
    expect(page).to have_selector :rich_text, "Rich text", focused: true
  end

  it "selects a focused rich text iframe" do
    expect(page).to have_no_selector :rich_text, "Editable iframe", focused: true
    expect(page).to have_selector :rich_text, "Editable iframe", focused: false
    focus_on find(:rich_text, "Editable iframe")
    expect(page).to have_selector :rich_text, "Editable iframe", focused: true
  end

  it "provides a friendly error for focused" do
    expect do
      expect(page).to have_selector :field, "Text", focused: true, wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /that is focused/
  end

  it "provides a friendly error for not focused" do
    expect do
      focus_on find(:field, "Text")
      find :field, "Text", focused: true
      expect(page).to have_selector :field, "Text", focused: false, wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, /that is not focused/
  end

  def focus_on(node)
    page.execute_script("arguments[0].focus()", node)
  end
end
