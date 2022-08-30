# frozen_string_literal: true

describe "current" do
  before { visit "/current.html" }

  it "selects a link with aria-current=page" do
    expect(page).to have_selector :link, "About us", current: "page"
  end

  it "selects a link_or_button with aria-current=page" do
    expect(page).to have_selector :link_or_button, "About us", current: "page"
  end
end
