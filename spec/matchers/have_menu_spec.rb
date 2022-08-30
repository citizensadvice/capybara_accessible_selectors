# frozen_string_literal: true

describe "have_menu" do
  before do
    visit "/menu.html"
  end

  it "finds a menu by [aria-label]" do
    expect(page).to have_menu("Menu (expanded)")
  end

  it "finds a menu by [aria-labelledby]" do
    expect(page).to have_menu("Menu (collapsed)")
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_menu("foo")
  end
end
