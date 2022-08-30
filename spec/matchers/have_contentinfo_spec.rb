# frozen_string_literal: true

describe "contentinfo matchers" do
  describe "have_contentinfo" do
    it "matches using a custom matcher" do
      render <<~HTML
        <footer aria-label="A contentinfo">Content</footer>
      HTML

      expect(page).to have_contentinfo("A contentinfo")
    end
  end

  describe "have_no_contentinfo" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <footer aria-label="A contentinfo">Content</footer>
      HTML

      expect(page).to have_no_contentinfo("Some junk")
    end
  end

  describe "within_contentinfo" do
    it "scopes to inside a contentinfo without text" do
      render <<~HTML
        <footer>Some text</footer>
      HTML

      within_contentinfo do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a contentinfo with text" do
      render <<~HTML
        <footer aria-label="A contentinfo">Some text</footer>
      HTML

      within_contentinfo "A contentinfo" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
