# frozen_string_literal: true

describe "described by filter" do
  before { visit "/described_by.html" }

  it "filters a field" do
    expect(page).to have_selector :field, "Text", described_by: "Text description 1"
    expect(page).to have_no_selector :field, "Text", described_by: "foo"
  end

  it "filters a fillable_field" do
    expect(page).to have_selector :fillable_field, "Text", described_by: "Text description 1"
    expect(page).to have_no_selector :fillable_field, "Text", described_by: "foo"
  end

  it "filters a radio button" do
    expect(page).to have_selector :radio_button, "Radio", described_by: "Radio description 1"
    expect(page).to have_no_selector :radio_button, "Radio", described_by: "Foo"
  end

  it "filters a checkbox" do
    expect(page).to have_selector :checkbox, "Checkbox", described_by: "Check description 1"
    expect(page).to have_no_selector :checkbox, "Checkbox", described_by: "Foo"
  end

  it "filters a select" do
    expect(page).to have_selector :select, "Select", described_by: "Select description 1"
    expect(page).to have_no_selector :select, "Select", described_by: "Foo"
  end

  it "filters a file_field" do
    expect(page).to have_selector :file_field, "File", described_by: "File description 1"
    expect(page).to have_no_selector :file_field, "File", described_by: "Foo"
  end

  it "filters a combo box" do
    expect(page).to have_selector :combo_box, "Combo box", described_by: "Combo description 1"
    expect(page).to have_no_selector :combo_box, "Combo box", described_by: "Foo"
  end
end
