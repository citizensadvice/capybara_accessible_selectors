# frozen_string_literal: true

describe "current" do
  before { visit "/current.html" }

  describe "#have_selector" do
    it "selects a link without [aria-current]" do
      expect(page).to have_selector :link, "Home", current: nil
    end

    it "selects a link with aria-current=page" do
      expect(page).to have_selector :link, "About us", current: "page"
    end

    it "selects a link_or_button with aria-current=page" do
      expect(page).to have_selector :link_or_button, "About us", current: "page"
    end
  end

  describe "#have_no_selector" do
    it "selects a link without [aria-current]" do
      expect(page).to have_no_selector :link, "About us", current: nil
    end
  end
end
