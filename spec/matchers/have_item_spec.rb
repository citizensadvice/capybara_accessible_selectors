# frozen_string_literal: true

describe "have_item" do
  before do
    visit "/microdata.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_item "name"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_item "foo"
  end
end
