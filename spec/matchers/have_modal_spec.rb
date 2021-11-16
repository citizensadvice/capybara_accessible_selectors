# frozen_string_literal: true

describe "have_modal" do
  before do
    visit "/modal.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_modal "Dialog title"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_modal "foo"
  end
end
