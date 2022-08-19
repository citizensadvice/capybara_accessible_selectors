# frozen_string_literal: true

describe "status selector" do
  before do
    visit "/status.html"
  end

  it "finds statuses without arguments" do
    status = page.find(:css, "[role=status]")
    expect(page.find(:status)).to eq status
  end

  it "finds statuses with a locator" do
    status = page.find(:css, "[role=status]")
    expect(page.find(:status, "Status message")).to eq status
  end

  it "finds statuses with a text: filter" do
    status = page.find(:css, "[role=status]")
    expect(page.find(:status, text: "Status message")).to eq status
  end

  it "matches selector" do
    status = page.find(:css, "[role=status]")
    expect(status).to match_selector :status
  end
end
