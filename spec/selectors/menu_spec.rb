# frozen_string_literal: true

describe "menu selector", skip_driver: :safari do
  # Safari has a weird bug with the menu role resolution being intermittent
  before do
    visit "/menu.html"
  end

  describe "locator" do
    it "finds menus without a locator" do
      expect(page).to have_selector :menu, count: 4
    end

    it "finds a menu by [aria-label]" do
      menu = find(id: "menu-expanded")

      expect(find(:menu, "Menu (expanded)")).to eq menu
    end

    it "finds a menu by [aria-labelledby]" do
      menu = find(id: "menu-collapsed")

      expect(find(:menu, "Menu (collapsed)")).to eq menu
    end
  end

  describe "expanded" do
    context "when true" do
      it "finds expanded" do
        expect(page).to have_selector :menu, "Menu (expanded)", expanded: true
      end

      it "does not find not expanded" do
        expect(page).to have_no_selector :menu, "Menu (collapsed)", expanded: true
      end
    end

    context "when false" do
      it "finds not expanded" do
        expect(page).to have_selector :menu, "Menu (collapsed)", expanded: false
      end

      it "does not find expanded" do
        expect(page).to have_no_selector :menu, "Menu (expanded)", expanded: false
      end
    end
  end

  describe "orientation" do
    context "when vertical" do
      it "finds vertical" do
        expect(page).to have_selector(:menu, "Menu (vertical)", orientation: :vertical)
        expect(page).to have_selector(:menu, "Menu (vertical)", orientation: "vertical")
        expect(page).to have_selector(:menu, "Menu (expanded)", orientation: :vertical)
        expect(page).to have_selector(:menu, "Menu (expanded)", orientation: "vertical")
      end

      it "does not find horizontal" do
        expect(page).to have_no_selector(:menu, "Menu (horizontal)", orientation: :vertical)
        expect(page).to have_no_selector(:menu, "Menu (horizontal)", orientation: "vertical")
      end
    end

    context "when horizontal" do
      it "does not find vertical" do
        expect(page).to have_no_selector(:menu, "Menu (vertical)", orientation: :horizontal)
        expect(page).to have_no_selector(:menu, "Menu (vertical)", orientation: "horizontal")
        expect(page).to have_no_selector(:menu, "Menu (expanded)", orientation: :horizontal)
        expect(page).to have_no_selector(:menu, "Menu (expanded)", orientation: "horizontal")
      end

      it "finds horizontal" do
        expect(page).to have_selector(:menu, "Menu (horizontal)", orientation: :horizontal)
        expect(page).to have_selector(:menu, "Menu (horizontal)", orientation: "horizontal")
      end
    end
  end
end
