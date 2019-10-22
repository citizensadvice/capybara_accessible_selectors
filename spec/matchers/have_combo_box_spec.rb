# frozen_string_literal: true

describe "have_combo_box" do
  before do
    visit "/combo_box.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_combo_box "aria 1.0"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_combo_box "foo"
  end
end
