# frozen_string_literal: true

describe "grid" do
  before do
    visit "/grid.html"
  end

  describe "locator" do
    it "finds grids without a locator" do
      expect(page).to have_selector :grid, count: 3
    end

    it "finds a grid by [aria-label]" do
      grid = find(id: "grid-div")

      expect(find(:grid, "Grid (div)")).to eq grid
    end

    it "finds a grid by [aria-labelledby]" do
      grid = find(id: "grid-table")

      expect(find(:grid, "Grid (table)")).to eq grid
    end
  end

  describe "described_by filter" do
    it "finds a [role=grid] by [aria-describedby]" do
      grid = find(id: "grid-div")

      expect(find(:grid, described_by: "Grid (div caption)")).to eq grid
    end

    it "finds a table[role=grid] by caption" do
      grid = find(id: "grid-table")

      expect(find(:grid, described_by: "Grid (table caption)")).to eq grid
    end

    it "does not find a div[role=grid] by caption" do
      expect(page).to have_no_selector :grid, described_by: "Grid (invalid caption)"
    end
  end
end
