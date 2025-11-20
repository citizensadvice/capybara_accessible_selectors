# frozen_string_literal: true

describe "gridcell" do
  before do
    visit "/grid.html"
  end

  describe "locator" do
    it "finds gridcells without a locator" do
      expect(page).to have_selector :gridcell, count: 12
    end

    context "when the [role=grid] is a table" do
      it "finds a gridcell by exact text" do
        expect(page).to have_selector :gridcell, "A1", exact: true, count: 1
      end

      it "finds a gridcell by partial text" do
        expect(page).to have_selector :gridcell, "A", count: 2
      end
    end

    context "when the [role=grid] is not a table" do
      it "finds a gridcell by exact text" do
        expect(page).to have_selector :gridcell, "D7", exact: true, count: 1
      end

      it "finds a gridcell by partial text" do
        expect(page).to have_selector :gridcell, "D", count: 2
      end
    end
  end

  describe "colindex filter" do
    it "finds <td> gridcells based on their index in their <tr>" do
      within id: "grid-table" do
        expect(page).to have_selector :gridcell, colindex: 2, count: 2

        gridcell_texts = page.all(:gridcell, colindex: 2).map(&:text)
        expect(gridcell_texts).to eq(%w[B2 B5])
      end
    end

    it "finds gridcells based on ther [aria-colindex]" do
      within id: "grid-div" do
        expect(page).to have_selector :gridcell, colindex: 2, count: 2

        gridcell_texts = page.all(:gridcell, colindex: 2).map(&:text)
        expect(gridcell_texts).to eq(%w[E8 E11])
      end
    end
  end

  describe "rowindex filter" do
    it "finds <td> gridcells based on the index of their <tr> in the <table>" do
      within id: "grid-table" do
        expect(page).to have_selector :gridcell, rowindex: 2, count: 3

        gridcell_texts = page.all(:gridcell, rowindex: 2).map(&:text)
        expect(gridcell_texts).to eq(%w[A4 B5 C6])
      end
    end

    it "finds gridcells based on the [aria-rowindex] of their [role=row]" do
      within id: "grid-div" do
        expect(page).to have_selector :gridcell, rowindex: 2, count: 3

        gridcell_texts = page.all(:gridcell, rowindex: 2).map(&:text)
        expect(gridcell_texts).to eq(%w[D7 E8 F9])
      end
    end
  end

  describe "columnheader filter" do
    it "finds gridcells based on the text of their th" do
      within id: "grid-table" do
        expect(page).to have_selector :gridcell, columnheader: "A", count: 2

        gridcell_texts = page.all(:gridcell, columnheader: "A").map(&:text)
        expect(gridcell_texts).to eq(%w[A1 A4])
      end
    end

    it "finds gridcells based on the text of their [role=columnheader]" do
      within id: "grid-div" do
        expect(page).to have_selector :gridcell, columnheader: "D", count: 2

        gridcell_texts = page.all(:gridcell, columnheader: "D").map(&:text)
        expect(gridcell_texts).to eq(%w[D7 D10])
      end
    end
  end
end
