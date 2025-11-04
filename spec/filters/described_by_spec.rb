# frozen_string_literal: true

describe "described by filter" do
  before do
    visit "/described_by.html"

    allow(Capybara::Helpers).to receive(:warn)
  end

  it "filters a field" do
    expect(page).to have_selector :field, "Text", described_by: "Text description"
    expect(page).to have_no_selector :field, "Text", described_by: "foo"
  end

  it "filters a fillable_field" do
    expect(page).to have_selector :fillable_field, "Text", described_by: "Text description"
    expect(page).to have_no_selector :fillable_field, "Text", described_by: "foo"
  end

  it "filters a datalist_input" do
    expect(page).to have_selector :datalist_input, "Text", described_by: "Text description"
    expect(page).to have_no_selector :datalist_input, "Text", described_by: "foo"
  end

  it "filters a radio button" do
    expect(page).to have_selector :radio_button, "Radio", described_by: "Radio description"
    expect(page).to have_no_selector :radio_button, "Radio", described_by: "Foo"
  end

  it "filters a checkbox" do
    expect(page).to have_selector :checkbox, "Checkbox", described_by: "Check description"
    expect(page).to have_no_selector :checkbox, "Checkbox", described_by: "Foo"
  end

  it "filters a select" do
    expect(page).to have_selector :select, "Select", described_by: "Select description"
    expect(page).to have_no_selector :select, "Select", described_by: "Foo"
  end

  it "filters a file_field" do
    expect(page).to have_selector :file_field, "File", described_by: "File description"
    expect(page).to have_no_selector :file_field, "File", described_by: "Foo"
  end

  it "filters a combo box" do
    expect(page).to have_selector :combo_box, "Combo box", described_by: "Combo description"
    expect(page).to have_no_selector :combo_box, "Combo box", described_by: "Foo"
  end

  it "filters a rich text box" do
    expect(page).to have_selector :rich_text, "Rich text", described_by: "Rich text description"
    expect(page).to have_no_selector :rich_text, "Rich text", described_by: "Foo"
  end

  it "filters a fieldset" do
    expect(page).to have_selector :fieldset, described_by: "description"
    expect(page).to have_no_selector :fieldset, described_by: "Foo"
  end

  it "filters an element" do
    expect(page).to have_selector :element, "fieldset", described_by: "description"
    expect(page).to have_no_selector :element, "fieldset", described_by: "Foo"
  end

  it "provides a friendly error" do
    expect do
      expect(page).to have_selector :field, "Text", described_by: "foo", wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                       /expected to be described by "foo" but it was described by "Text description"/
  end

  context "with a regular expression" do
    it "filters a field" do
      expect(page).to have_selector :field, "Text", described_by: /description/
    end

    it "provides a friendly error" do
      expect do
        expect(page).to have_selector :field, "Text", described_by: /foo/, wait: false
      end.to raise_error RSpec::Expectations::ExpectationNotMetError,
                         %r{expected to be described by /foo/ but it was described by "Text description"}
    end
  end
end
