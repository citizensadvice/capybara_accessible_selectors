# frozen_string_literal: true

describe "row matchers" do
  before do
    visit "/grid.html"
  end

  describe "have_row" do
    it "matches using a custom matcher" do
      expect(page).to have_row("A", count: 3)
    end
  end

  describe "have_no_row" do
    it "matches does not match using a custom matcher" do
      expect(page).to have_no_row("Junk")
    end
  end

  describe "within_row" do
    it "scopes to inside a row without text" do
      render <<~HTML
        <table role="grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_row do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a row with text" do
      render <<~HTML
        <table role="grid">
          <tr><td>Some text</td></tr>
        </table>
      HTML

      within_row "Some" do
        expect(page).to have_text("text")
      end
    end
  end
end
