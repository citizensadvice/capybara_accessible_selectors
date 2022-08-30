# frozen_string_literal: true

describe "navigation matchers" do
  describe "have_navigation" do
    it "matches using a custom matcher" do
      render <<~HTML
        <nav aria-label="A navigation">Content</nav>
      HTML

      expect(page).to have_navigation("A navigation")
    end
  end

  describe "have_no_navigation" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <nav aria-label="A navigation">Content</nav>
      HTML

      expect(page).to have_no_navigation("Some junk")
    end
  end

  describe "within_navigation" do
    it "scopes to inside a navigation without text" do
      render <<~HTML
        <nav>Some text</nav>
      HTML

      within_navigation do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a navigation with text" do
      render <<~HTML
        <nav aria-label="A navigation">Some text</nav>
      HTML

      within_navigation "A navigation" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
