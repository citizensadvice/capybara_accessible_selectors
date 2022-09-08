# frozen_string_literal: true

describe "row" do
  before do
    visit "/grid.html"
  end

  describe "locator" do
    it "finds rows without a locator" do
      expect(page).to have_selector :row, count: 6
    end

    context "when the [role=grid] is a table" do
      it "finds a row by exact text" do
        expect(page).to have_selector :row, "A (th) B (th) C (th)", exact: true
        expect(page).to have_no_selector :row, "A", exact: true
      end

      it "finds a row by partial text" do
        expect(page).to have_selector :row, "A", count: 3
      end
    end

    context "when the [role=grid] is not a table" do
      it "finds a row by exact text" do
        expect(page).to have_selector :row, "D7 E8 F9", exact: true
        expect(page).to have_no_selector :row, "D", exact: true
      end

      it "finds a row by partial text" do
        expect(page).to have_selector :row, "D", count: 3
      end
    end
  end

  describe "rowindex filter" do
    it "finds <tr> rows based on their index in their [role=grid]" do
      within id: "grid-table" do
        expect(page).to have_selector :row, "B", rowindex: 2, count: 1
      end
    end

    it "finds rows based on ther [aria-rowindex]" do
      within id: "grid-div" do
        expect(page).to have_selector :row, "E", rowindex: 2, count: 1
      end
    end
  end
end
