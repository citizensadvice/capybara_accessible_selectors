# frozen_string_literal: true

describe "have_status" do
  before do
    visit "/status.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_status("Status")
    expect(page).to have_status(text: "Status")
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_status("foo")
    expect(page).to have_no_status(text: "foo")
  end
end
