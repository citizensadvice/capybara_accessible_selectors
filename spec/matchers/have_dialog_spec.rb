# frozen_string_literal: true

describe "have_dialog" do
  before do
    visit "/dialog.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_dialog "Dialog title"
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_modal "foo"
  end
end
