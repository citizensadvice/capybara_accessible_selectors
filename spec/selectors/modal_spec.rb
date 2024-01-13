# frozen_string_literal: true

describe "modal selector" do
  before do
    visit "/dialog.html"
  end

  it "does not find a non-native dialog without aria-modal" do
    expect(page).to have_no_selector :modal, "Missing aria modal"
  end

  it "finds a non-native dialog with aria-modal" do
    expect(page).to have_selector :modal, "Modal title"
  end

  it "finds a non-native alertdialog with aria-modal" do
    expect(page).to have_selector :modal, "Alertdialog title"
  end

  it "does not find a closed native dialog" do
    expect(page).to have_no_selector :modal, "Native dialog heading"
  end

  it "does not find a open native dialog opened as a non-modal dialog" do
    click_on "Open native dialog"
    expect(page).to have_no_selector :modal, "Native dialog heading"
  end

  it "finds a open native dialog opened as a modal dialog" do
    click_on "Open native modal"
    expect(page).to have_selector :modal, "Native dialog heading"
  end

  it "does not find a closed native dialog with role alertdialog" do
    expect(page).to have_no_selector :modal, "Native alertdialog heading"
  end

  it "does not finds an open native dialog with role alertdialog opened as a non-modal" do
    click_on "Open native alertdialog as dialog"
    expect(page).to have_no_selector :modal, "Native alertdialog heading"
  end

  it "finds an open native dialog with role alertdialog opened as a modal" do
    click_on "Open native alertdialog as modal"
    expect(page).to have_selector :modal, "Native alertdialog heading"
  end

  describe "within_dialog with modal true" do
    it "limits to within the modal" do
      within_modal "Modal title" do
        expect(page).to have_text <<~TEXT.strip, exact: true
          Modal title
          Modal content
        TEXT
      end
    end
  end
end
