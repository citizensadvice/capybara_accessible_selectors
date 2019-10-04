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
      expect(page).to have_no_selector :tab_panel, "Two", open: true, visible: false
    end

    it "filters by closed tabpanel" do
      expect(page).to have_no_selector :tab_panel, "One", open: false
      expect(page).to have_selector :tab_panel, "Two", open: false, visible: false
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
  end
end
