# frozen_string_literal: true

describe "have_menu" do
  before do
    visit "/menu.html"
  end

  it "finds a menuitem by its text content" do
    within :menu, "Menu (expanded)" do
      expect(page).to have_menuitem, "Menuitem (textContent)"
    end
  end

  it "finds a menuitem by [aria-label]" do
    within :menu, "Menu (expanded)" do
      expect(page).to have_menuitem, "Menuitem ([aria-label])"
    end
  end

  it "finds a menuitem by [aria-labelledby]" do
    within :menu, "Menu (expanded)" do
      expect(page).to have_menuitem, "Menuitem ([aria-labelledby])"
    end
  end

  it "matches using a negated custom matcher" do
    expect(page).to have_no_menuitem("foo")
  end
end
