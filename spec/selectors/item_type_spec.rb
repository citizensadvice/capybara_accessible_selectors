# frozen_string_literal: true

describe "item_type" do
  before { visit "/microdata.html" }

  it "selects a type" do
    expect(page).to have_selector :item_type, "building", text: "Forth bridge"
  end

  it "does not select a missing type" do
    expect do
      expect(page).to have_selector :item_type, "build", text: "Forth bridge", wait: false
    end.to raise_error RSpec::Expectations::ExpectationNotMetError, include(<<~EXPECTED.squish)
      expected to find item_type "build" but there were no matches
    EXPECTED
  end
end
