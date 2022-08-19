# frozen_string_literal: true

describe "have_alert" do
  before do
    visit "/alert.html"
  end

  it "matches using a custom matcher with locator" do
    expect(page).to have_alert("Alert")
  end

  it "matches using a custom matcher with text: filter" do
    expect(page).to have_alert(text: "Alert")
  end

  it "matches using a negated custom matcher with locator" do
    expect(page).to have_no_alert("foo")
  end

  it "matches using a negated custom matcher with text: filter" do
    expect(page).to have_no_alert(text: "foo")
  end
end
