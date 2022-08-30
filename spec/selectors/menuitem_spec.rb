# frozen_string_literal: true

describe "menuitem selector" do
  before do
    visit "/menu.html"
  end

  describe "locator" do
    it "finds menuitems without a locator" do
      within :menu, "Menu (expanded)" do
        expect(page).to have_selector :menuitem, count: 3
      end
    end

    it "finds a menuitem by its text content" do
      within :menu, "Menu (expanded)" do
        expect(page).to have_selector :menuitem, "Menuitem (textContent)"
      end
    end

    it "finds a menuitem by [aria-label]" do
      within :menu, "Menu (expanded)" do
        expect(page).to have_selector :menuitem, "Menuitem ([aria-label])"
      end
    end

    it "finds a menuitem by [aria-labelledby]" do
      within :menu, "Menu (expanded)" do
        expect(page).to have_selector :menuitem, "Menuitem ([aria-labelledby])"
      end
    end
  end

  describe "disabled" do
    context "when omitted" do
      it "finds not disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_selector :menuitem, "Menuitem (textContent)"
        end
      end

      it "does not find disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_no_selector :menuitem, "Menuitem (disabled)"
        end
      end
    end

    context "when true" do
      it "finds disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_selector :menuitem, "Menuitem (disabled)", disabled: true
        end
      end

      it "does not find not disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_no_selector :menuitem, "Menuitem (textContent)", disabled: true
        end
      end
    end

    context "when false" do
      it "finds not disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_selector :menuitem, "Menuitem (textContent)", disabled: false
        end
      end

      it "does not find disabled" do
        within :menu, "Menu (expanded)" do
          expect(page).to have_no_selector :menuitem, "Menuitem (disabled)", disabled: false
        end
      end
    end
  end
end
