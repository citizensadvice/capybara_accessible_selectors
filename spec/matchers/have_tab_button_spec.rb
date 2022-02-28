# frozen_string_literal: true

describe "have_tab_button" do
  before do
    visit "/tab.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_tab_button "One"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_tab_button "Foo"
  end
end
