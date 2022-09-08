# frozen_string_literal: true

describe "columnheader matchers" do
  before do
    visit "/grid.html"
  end

  describe "have_columnheader" do
    it "matches using a custom matcher" do
      expect(page).to have_columnheader("A (th)", count: 1)
    end
  end

  describe "have_no_columnheader" do
    it "matches does not match using a custom matcher" do
      expect(page).to have_no_columnheader("Junk")
    end
  end

  describe "within_columnheader" do
    it "scopes to inside a columnheader without text" do
      render <<~HTML
        <table role="grid">
          <tr><th>Some text</th></tr>
        </table>
      HTML

      within_columnheader do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a columnheader with text" do
      render <<~HTML
        <table role="grid">
          <tr><th>Some text</th></tr>
        </table>
      HTML

      within_columnheader "Some" do
        expect(page).to have_text("text")
      end
    end
  end
end
