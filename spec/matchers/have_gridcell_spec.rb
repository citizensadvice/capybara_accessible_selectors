# frozen_string_literal: true

describe "gridcell matchers" do
  before do
    visit "/grid.html"
  end

  describe "have_gridcell" do
    it "matches using a custom matcher" do
      expect(page).to have_gridcell("A", count: 2)
    end
  end

  describe "have_no_gridcell" do
    it "matches does not match using a custom matcher" do
      expect(page).to have_no_gridcell("Junk")
    end
  end

  describe "within_gridcell" do
    it "scopes to inside a gridcell without text" do
      render <<~HTML
        <table role="grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_gridcell do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a gridcell with text" do
      render <<~HTML
        <table role="grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_gridcell "Some" do
        expect(page).to have_text("text")
      end
    end
  end
end
