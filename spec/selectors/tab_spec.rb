# frozen_string_literal: true

describe "tab selector" do
  before do
    visit "/tab.html"
  end

  describe "tabpanel selector" do
    it "finds an open tabpanel" do
      tabpanel = find(:element, :div, text: "Panel one")
      expect(find(:tab_panel, "One")).to eq tabpanel
    end

    it "finds a closed tabpanel" do
      tabpanel = find(:element, :div, text: "Panel two", visible: false)
      expect(find(:tab_panel, "Two", visible: false)).to eq tabpanel
    end

    it "finds content in an open tabpanel" do
      expect(page).to have_selector :tab_panel, "One", text: "Panel one"
    end

    it "filters by open tabpanel" do
      expect(page).to have_selector :tab_panel, "One", open: true
      expect(page).to have_no_selector :tab_panel, "Two", open: true, visible: :all
    end

    it "filters by closed tabpanel" do
      expect(page).to have_no_selector :tab_panel, "One", open: false
      expect(page).to have_selector :tab_panel, "Two", open: false, visible: :all
    end

    it "matches by tabpanel" do
      tabpanel = find(:element, :div, text: "Panel one")
      expect(tabpanel).to match_selector :tab_panel
    end

    it "matches by tabpanel and name" do
      tabpanel = find(:element, :div, text: "Panel one")
      expect(tabpanel).to match_selector :tab_panel, "One"
    end
  end

  describe "tab_button selector" do
    it "finds a tab" do
      tab = find(:button, "One")
      expect(find(:tab_button, "One")).to eq tab
    end

    it "finds a open tab" do
      expect(page).to have_selector :tab_button, "One", open: true
      expect(page).to have_no_selector :tab_button, "Two", open: true
    end

    it "finds a closed tab" do
      expect(page).to have_selector :tab_button, "Two", open: false
      expect(page).to have_no_selector :tab_button, "One", open: false
    end

    it "matches by tab button" do
      tab = find(:button, "One")
      expect(tab).to match_selector :tab_button
    end

    it "matches by tab button and name" do
      tab = find(:button, "One")
      expect(tab).to match_selector :tab_button, "One"
    end
  end

  describe "select_tab action" do
    it "opens a tabs" do
      expect(page).to have_selector :tab_button, "One", open: true
      expect(page).to have_selector :tab_panel, "One"
      expect(page).to have_no_selector :tab_panel, "Two"
      select_tab "Two"
      expect(page).to have_selector :tab_button, "One", open: false
      expect(page).to have_selector :tab_button, "Two", open: true
      expect(page).to have_no_selector :tab_panel, "One"
      expect(page).to have_selector :tab_panel, "Two"
      select_tab "Three"
      expect(page).to have_selector :tab_button, "Three", open: true
      expect(page).to have_selector :tab_panel, "Three"
    end

    it "can be called on a tab_button" do
      button = find(:button, "Two")
      button.select_tab
      expect(page).to have_selector :tab_panel, "Two", open: true
    end

    context "with a block" do
      it "runs block within the tab panel" do
        select_tab "Three" do
          expect(page).to have_text "Panel three", exact: true
        end
      end
    end
  end

  describe "within_tab_panel" do
    it "selects within a tab panel" do
      within_tab_panel "One" do
        expect(page).to have_text "Panel one", exact: true
      end
    end
  end
end
