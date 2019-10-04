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

  it "does not select a modal missing a role" do
    expect(page).to have_no_selector :modal, "Missing role"
  end

  it "does not select a modal missing aria-modal=true" do
    expect(page).to have_no_selector :modal, "Missing aria modal"
  end
end
