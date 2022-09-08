# frozen_string_literal: true

describe "article matchers" do
  describe "have_article" do
    it "matches using a custom matcher" do
      render <<~HTML
        <article aria-label="A article">Content</article>
      HTML

      expect(page).to have_article("A article")
    end
  end

  describe "have_no_article" do
    it "matches using a negated custom matcher" do
      render <<~HTML
        <article aria-label="A article">Content</article>
      HTML

      expect(page).to have_no_article("Some junk")
    end
  end

  describe "within_article" do
    it "scopes to inside a article without text" do
      render <<~HTML
        <article>Some text</article>
      HTML

      within_article do
        expect(page).to have_text("Some text")
      end
    end

    it "scopes to inside a article with text" do
      render <<~HTML
        <article aria-label="A article">Some text</article>
      HTML

      within_article "A article" do
        expect(page).to have_text("Some text")
      end
    end
  end
end
