# frozen_string_literal: true

describe "dialog selector" do
  before do
    visit "/dialog.html"
  end

  it "selects a dialog by title" do
    modal = find(:element, :div, text: "Dialog content")
    expect(find(:dialog, "Dialog title")).to eq modal
  end

  it "selects an alertdialog by title" do
    modal = find(:element, :div, text: "Alertdialog content")
    expect(find(:dialog, "Alertdialog title")).to eq modal
  end

  it "matches a dialog" do
    modal = find(:element, :div, text: "Dialog content")
    expect(modal).to match_selector :dialog
  end

  it "selects by aria-label" do
    modal = find(:element, :div, text: "Aria label content")
    expect(find(:dialog, "aria-label")).to eq modal
  end

  it "selects by partial aria-label" do
    modal = find(:element, :div, text: "Aria label content")
    expect(find(:dialog, "aria-lab")).to eq modal
  end

  it "selects by exact aria-label" do
    modal = find(:element, :div, text: "Aria label content")
    expect(find(:dialog, "aria-label", exact: true)).to eq modal
  end

  it "does not find exact aria-label with the wrong text" do
    expect do
      find :dialog, "aria-labe", exact: true, wait: 0
    end.to raise_error Capybara::ElementNotFound
  end

  it "selects by multiple aria-labelledby" do
    modal = find(:element, :div, text: "Split label content")
    expect(find(:dialog, "split label")).to eq modal
  end

  it "selects by partial aria-labelledby" do
    modal = find(:element, :div, text: "Split label content")
    expect(find(:dialog, "split la")).to eq modal
  end

  it "selects by exact aria-labelledby" do
    modal = find(:element, :div, text: "Split label content")
    expect(find(:dialog, "split label", exact: true)).to eq modal
  end

  it "does not find by exact aria-labelledby with the wrong text" do
    expect do
      find :dialog, "split la", exact: true, wait: 0
    end.to raise_error Capybara::ElementNotFound
  end

  it "does not select a modal missing a role" do
    expect(page).to have_no_selector :dialog, "Missing role"
  end

  it "selects a native modal" do
    click_on "Open native modal"
    modal = find(:element, :dialog)
    expect(find(:dialog, "Native dialog heading")).to eq modal
  end

  it "does not select a native non-modal dialog" do
    click_on "Open native dialog"
    expect(page).to have_selector :element, :dialog
    expect(page).to have_no_selector :dialog, "Native modal heading"
  end

  it "does not selects an unopened native modal" do
    expect(page).to have_no_selector :dialog, "Native modal content", visible: :all
  end

  describe "within_dialog" do
    it "limits to within the dialog" do
      within_dialog "Dialog title" do
        expect(page).to have_text <<~TEXT.strip, exact: true
          Dialog title
          Dialog content
        TEXT
      end
    end
  end

  context "with modal:true filter" do
    it "does not find a non-native alertdialog without aria-modal" do
      expect(page).to have_no_selector :dialog, "Missing aria modal", modal: true
    end

    it "does not find a non-native dialog without aria-modal" do
      expect(page).to have_no_selector :dialog, "aria-label", modal: true
    end

    it "finds a non-native dialog with aria-modal" do
      expect(page).to have_selector :dialog, "Modal title", modal: true
    end

    it "finds a non-native alertdialog with aria-modal" do
      expect(page).to have_selector :dialog, "Alertdialog title", modal: true
    end

    it "does not find a closed native dialog" do
      expect(page).to have_no_selector :dialog, "Native dialog heading", modal: true
    end

    it "does not find a open native dialog opened as a non-modal dialog" do
      click_on "Open native dialog"
      expect(page).to have_no_selector :dialog, "Native dialog heading", modal: true
    end

    it "finds a open native dialog opened as a modal dialog" do
      click_on "Open native modal"
      expect(page).to have_selector :dialog, "Native dialog heading", modal: true
    end

    it "does not find a closed native dialog with role alertdialog" do
      expect(page).to have_no_selector :dialog, "Native alertdialog heading", modal: true
    end

    it "does not finds an open native dialog with role alertdialog opened as a non-modal" do
      click_on "Open native alertdialog as dialog"
      expect(page).to have_no_selector :dialog, "Native alertdialog heading", modal: true
    end

    it "finds an open native dialog with role alertdialog opened as a modal" do
      click_on "Open native alertdialog as modal"
      expect(page).to have_selector :dialog, "Native alertdialog heading", modal: true
    end

    describe "within_dialog with modal true" do
      it "limits to within the modal" do
        within_dialog "Modal title", modal: true do
          expect(page).to have_text <<~TEXT.strip, exact: true
            Modal title
            Modal content
          TEXT
        end
      end
    end
  end

  context "with modal:false filter" do
    it "does not find a non-native alertdialog without aria-modal" do
      expect(page).to have_no_selector :dialog, "Missing aria modal", modal: false
    end

    it "finds a non-native dialog without aria-modal" do
      expect(page).to have_selector :dialog, "aria-label", modal: false
    end

    it "does not find a non-native dialog with aria-modal" do
      expect(page).to have_no_selector :dialog, "Modal title", modal: false
    end

    it "does not find a non-native alertdialog with aria-modal" do
      expect(page).to have_no_selector :dialog, "Alertdialog title", modal: false
    end

    it "does not find a closed native dialog" do
      expect(page).to have_no_selector :dialog, "Native dialog heading", modal: false
    end

    it "finds a open native dialog opened as a non-modal dialog" do
      click_on "Open native dialog"
      expect(page).to have_selector :dialog, "Native dialog heading", modal: false
    end

    it "does not find a open native dialog opened as a modal dialog" do
      click_on "Open native modal"
      expect(page).to have_no_selector :dialog, "Native dialog heading", modal: false
    end

    it "does not find a closed native dialog with role alertdialog" do
      expect(page).to have_no_selector :dialog, "Native alertdialog heading", modal: false
    end

    it "does not finds an open native dialog with role alertdialog opened as a non-modal" do
      click_on "Open native alertdialog as dialog"
      expect(page).to have_no_selector :dialog, "Native alertdialog heading", modal: false
    end

    it "does not find an open native dialog with role alertdialog opened as a modal" do
      click_on "Open native alertdialog as modal"
      expect(page).to have_no_selector :dialog, "Native alertdialog heading", modal: false
    end
  end
end
