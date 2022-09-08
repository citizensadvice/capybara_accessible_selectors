# frozen_string_literal: true

describe "columnheader" do
  before do
    visit "/grid.html"
  end

  describe "locator" do
    it "finds columnheaders without a locator" do
      expect(page).to have_selector :columnheader, count: 6
    end

    context "when the [role=grid] is a table" do
      it "finds a columnheader by exact text" do
        expect(page).to have_selector :columnheader, "A (th)", exact: true
        expect(page).to have_no_selector :columnheader, "A", exact: true
      end

      it "finds a columnheader by partial text" do
        expect(page).to have_selector :columnheader, "A", count: 1
      end
    end

    context "when the [role=grid] is not a table" do
      it "finds a columnheader by exact text" do
        expect(page).to have_selector :columnheader, "D (columnheader)", exact: true
        expect(page).to have_no_selector :columnheader, "D", exact: true
      end

      it "finds a columnheader by partial text" do
        expect(page).to have_selector :columnheader, "D", count: 1
      end
    end
  end

  describe "colindex filter" do
    it "finds <th> columnheaders based on their index in their <tr>" do
      within id: "grid-table" do
        expect(page).to have_selector :columnheader, "B", colindex: 2
      end
    end

    it "finds columnheaders based on ther [aria-colindex]" do
      within id: "grid-div" do
        expect(page).to have_selector :columnheader, "E", colindex: 2
      end
    end
  end
end
