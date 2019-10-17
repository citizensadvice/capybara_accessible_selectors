# frozen_string_literal: true

describe "locate_field" do
  before { visit "/locate_field.html" }

  it "locates on fieldsets with an implicit label" do
    expect(page).to have_selector :field, ["First circle", "Second circle", "Text implicit"]
  end

  it "locates on fieldsets with an explicit label" do
    expect(page).to have_selector :field, ["First circle", "Second circle", "Text explicit"]
  end
end
