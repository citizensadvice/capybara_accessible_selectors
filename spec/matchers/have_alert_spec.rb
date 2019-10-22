# frozen_string_literal: true

describe "have_alert" do
  before do
    visit "/alert.html"
  end

  it "matches using a custom matcher" do
    expect(page).to have_alert(text: "Alert")
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_alert(text: "foo")
  end
end
