# frozen_string_literal: true

describe "have_disclosure_button" do
  before do
    visit "/disclosure.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_disclosure_button "Summary button"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_disclosure_button "foo"
  end
end
