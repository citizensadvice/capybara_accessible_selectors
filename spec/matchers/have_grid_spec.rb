# frozen_string_literal: true

describe "grid matchers" do
  before do
    visit "/grid.html"
  end

  describe "have_grid" do
    it "matches using a custom matcher" do
      expect(page).to have_grid("Grid (table)", count: 1)
    end
  end

  describe "have_no_grid" do
    it "matches does not match using a custom matcher" do
      expect(page).to have_no_grid("Grid (some other kind)")
    end
  end

  describe "within_grid" do
    it "scopes to inside a grid without text" do
      render <<~HTML
        <table role="grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_grid do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a grid with text" do
      render <<~HTML
        <table role="grid" aria-label="A grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_grid "A grid" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
