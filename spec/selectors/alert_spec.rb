# frozen_string_literal: true

describe "alert selector" do
  before do
    visit "/alert.html"
  end

  it "finds alerts" do
    alert = page.find(:css, "[role=alert]")
    expect(page.find(:alert, text: "Alert message")).to eq alert
  end

  it "matches selector" do
    alert = page.find(:css, "[role=alert]")
    expect(alert).to match_selector :alert
  end
end
