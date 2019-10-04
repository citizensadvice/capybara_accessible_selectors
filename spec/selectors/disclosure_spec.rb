# frozen_string_literal: true

describe "Disclosure" do
  before { visit "/disclosure.html" }

  context "Details/Summary" do
    it "selects a details" do
      details = page.find(:element, :details, text: "Summary button")
      expect(page.find(:disclosure, "Summary button")).to eq details
      expect(page).to have_selector :disclosure, "Summary button", expanded: false
      expect(page).to have_no_selector :disclosure, "Summary button", expanded: true
    end

    it "selects a summary button" do
      summary = page.find(:element, :summary, text: "Summary button")
      expect(page.find(:disclosure_button, "Summary button")).to eq summary
      expect(page).to have_selector :disclosure_button, "Summary button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Summary button", expanded: true
    end

    it "toggles a details open and closed" do
      expect(page).to have_selector :disclosure, "Summary button", expanded: false
      # Open
      toggle_disclosure("Summary button")
      expect(page).to have_selector :disclosure, "Summary button", expanded: true
      expect(page).to have_selector :disclosure_button, "Summary button", expanded: true
      # Force open
      toggle_disclosure("Summary button", expand: true)
      expect(page).to have_selector :disclosure, "Summary button", expanded: true
      expect(page).to have_selector :disclosure_button, "Summary button", expanded: true
      # Close
      toggle_disclosure("Summary button")
      expect(page).to have_selector :disclosure, "Summary button", expanded: false
      # Force close
      toggle_disclosure("Summary button", expand: false)
      expect(page).to have_selector :disclosure, "Summary button", expanded: false
    end
  end

  context "disclosure pattern with button" do
    it "selects the button" do
      button = page.find(:button, "Disclosure button")
      expect(page.find(:disclosure_button, "Disclosure button")).to eq button
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Disclosure button", expanded: true
    end

    it "selects the disclosure" do
      # The disclosure isn't visible
      button = page.find(:element, :div, text: "Disclosure content", visible: false)
      expect(page.find(:disclosure, "Disclosure button", visible: false)).to eq button
      expect(page).to have_no_selector :disclosure, "Disclosure button"
    end

    it "toggles a disclosure open and closed" do
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
      # Open
      toggle_disclosure("Disclosure button")
      expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: true
      # Force open
      toggle_disclosure("Disclosure button", expand: true)
      expect(page).to have_selector :disclosure, "Disclosure button", expanded: true
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: true
      # Close
      toggle_disclosure("Disclosure button")
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
      # Force close
      toggle_disclosure("Disclosure button", expand: false)
      expect(page).to have_selector :disclosure_button, "Disclosure button", expanded: false
    end
  end

  context "disclosure pattern with simluated button" do
    it "selects the button" do
      button = page.find(:element, :span, text: "Disclosure span button")
      expect(page.find(:disclosure_button, "Disclosure span button")).to eq button
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
      expect(page).to have_no_selector :disclosure_button, "Disclosure span button", expanded: true
    end

    it "selects the disclosure" do
      # The disclosure isn't visible
      button = page.find(:element, :div, text: "Disclosure span content", visible: false)
      expect(page.find(:disclosure, "Disclosure span button", visible: false)).to eq button
      expect(page).to have_no_selector :disclosure, "Disclosure span button"
    end

    it "toggles a disclosure open and closed" do
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
      # Open
      toggle_disclosure("Disclosure span button")
      expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: true
      # Force open
      toggle_disclosure("Disclosure span button", expand: true)
      expect(page).to have_selector :disclosure, "Disclosure span button", expanded: true
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: true
      # Close
      toggle_disclosure("Disclosure span button")
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
      # Force close
      toggle_disclosure("Disclosure span button", expand: false)
      expect(page).to have_selector :disclosure_button, "Disclosure span button", expanded: false
    end
  end
end
