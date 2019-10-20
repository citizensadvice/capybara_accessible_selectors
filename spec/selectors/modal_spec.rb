# frozen_string_literal: true

describe "modal selector" do
  before do
    visit "/modal.html"
  end

  it "selects a dialog by title" do
    modal = find(:element, :div, text: "Dialog content")
    expect(find(:modal, "Dialog title")).to eq modal
  end

  it "selects an alertdialog by title" do
    modal = find(:element, :div, text: "Alertdialog content")
    expect(find(:modal, "Alertdialog title")).to eq modal
  end

  it "matches a dialog" do
    modal = find(:element, :div, text: "Dialog content")
    expect(modal).to match_selector :modal
  end

  it "selects by aria-label" do
    modal = find(:element, :div, text: "Aria label content")
    expect(find(:modal, "aria-label")).to eq modal
  end

  it "selects by multiple aria-labelledby" do
    modal = find(:element, :div, text: "Split label content")
    expect(find(:modal, "split label")).to eq modal
  end

  it "does not select a modal missing a role" do
    expect(page).to have_no_selector :modal, "Missing role"
  end

  it "does not select a modal missing aria-modal=true" do
    expect(page).to have_no_selector :modal, "Missing aria modal"
  end

  describe "within_modal" do
    it "limits to within the modal" do
      within_modal "Dialog title" do
        expect(page).to have_text <<~TEXT.strip, exact: true
          Dialog title
          Dialog content
        TEXT
      end
    end
  end
end
