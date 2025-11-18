# frozen_string_literal: true

describe "grid" do
  before do
    visit "/grid.html"
  end

  describe "locator" do
    it "finds grids without a locator" do
      expect(page).to have_selector :grid, count: 3
    end

    it "finds a div based grid by name" do
      grid = find(id: "grid-div")

      expect(find(:grid, "Grid (div)")).to eq grid
    end

    it "finds a table based grid by name", skip_driver: :safari do
      grid = find(id: "grid-table")

      expect(find(:grid, "Grid (table)")).to eq grid
    end
  end
end
